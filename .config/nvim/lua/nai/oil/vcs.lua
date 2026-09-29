-- VCS status column for oil.nvim: shows which entries git or jj changed.
--
-- oil ships no VCS column (only type/icon/size/permissions/mtime), and a column
-- render() must be synchronous, so status is fetched by an async `git status` /
-- `jj diff` per directory, cached, and the oil buffers are rerendered once the
-- answer lands.

local oil = require("oil")
local constants = require("oil.constants")
local view = require("oil.view")

local FIELD_NAME = constants.FIELD_NAME

local M = {}

-- dir -> { [entry name] = code }; a missing key means "not fetched yet"
local cache = {}
local inflight = {}
-- every dir we ever tried to fetch, including the ones whose fetch failed
local tracked = {}
-- dir -> time before which a failed fetch is not retried; keeps a broken VCS
-- from spawning a process on every redraw
local retry_at = {}

-- worst status wins when several files inside one directory changed
local rank = { D = 6, M = 5, R = 4, C = 3, A = 2, ["?"] = 1, ["!"] = 0 }

-- status code -> highlight group, derived from a group the colorscheme already
-- colors (Diff* groups only carry a background, which reads as invisible here)
local hl = {
	M = { group = "OilVcsModified", base = "DiagnosticWarn" },
	A = { group = "OilVcsAdded", base = "Added" },
	D = { group = "OilVcsDeleted", base = "Removed" },
	R = { group = "OilVcsRenamed", base = "Changed" },
	C = { group = "OilVcsCopied", base = "Changed" },
	["?"] = { group = "OilVcsUntracked", base = "DiagnosticHint" },
	["!"] = { group = "OilVcsIgnored", base = "Comment", plain = true },
}

local function define_highlights()
	for _, spec in pairs(hl) do
		local base = vim.api.nvim_get_hl(0, { name = spec.base, link = false })
		if base.fg then
			-- one character needs the extra weight to stand out
			vim.api.nvim_set_hl(0, spec.group, { fg = base.fg, bold = not spec.plain })
		else
			vim.api.nvim_set_hl(0, spec.group, { link = spec.base })
		end
	end
end

---@param path string
---@return string
local function unquote(path)
	return path:gsub('^"(.*)"$', "%1"):gsub('\\"', '"'):gsub("\\\\", "\\")
end

---@param status table<string, string>
---@param path string
---@param code string
local function add(status, path, code)
	-- jj reports paths outside the current directory as well
	if path == "" or path:sub(1, 3) == "../" then
		return
	end
	-- anything deeper is reported against the directory that contains it
	local name = path:match("^([^/]+)/") or path
	local prev = status[name]
	if not prev or (rank[code] or 0) > (rank[prev] or 0) then
		status[name] = code
	end
end

---@param out string
---@return table<string, string>
local function parse_git(out)
	local status = {}
	for _, line in ipairs(vim.split(out, "\n", { plain = true })) do
		-- "XY path", a rename is "R  old -> new"
		if #line > 3 and line:sub(3, 3) == " " then
			local xy, path = line:sub(1, 2), unquote(line:sub(4))
			local arrow = path:find(" -> ", 1, true)
			if arrow then
				path = path:sub(arrow + 4)
			end
			-- the worktree flag wins over the index flag: " M" and "MM" both mean modified
			local code = xy:sub(2, 2)
			if code == " " then
				code = xy:sub(1, 1)
			end
			add(status, path, code)
		end
	end
	return status
end

---@param out string
---@return table<string, string>
local function parse_jj(out)
	local status = {}
	for _, line in ipairs(vim.split(out, "\n", { plain = true })) do
		-- "M path", a rename is "R {old => new}"
		local code, path = line:match("^(%a) (.+)$")
		if code then
			if path:sub(1, 1) == "{" then
				path = path:match("=> ([^}]+)") or path
			end
			add(status, path, code)
		end
	end
	return status
end

---@param dir string
---@return nil|string
local function detect(dir)
	-- a jj-colocated repo has both markers; the deeper one owns this directory
	local jj = vim.fs.find(".jj", { upward = true, path = dir, type = "directory" })[1]
	local git = vim.fs.find(".git", { upward = true, path = dir })[1]
	if jj and (not git or #vim.fs.dirname(jj) >= #vim.fs.dirname(git)) then
		return "jj"
	end
	if git then
		return "git"
	end
end

---A failed fetch is not the same as a clean tree: leave it unknown, tell the
---user once per failure spell, and retry after a short backoff.
---@param dir string
---@param backend string
---@param reason string
local function report_failure(dir, backend, reason)
	local first = retry_at[dir] == nil
	retry_at[dir] = vim.uv.now() + 5000
	if first then
		vim.schedule(function()
			vim.notify(
				("oil vcs: %s failed in %s: %s"):format(backend, dir, vim.trim(reason)),
				vim.log.levels.WARN
			)
		end)
	end
	vim.schedule(M.refresh)
end

---@param dir string
---@param force nil|boolean Refetch even if the last attempt failed just now
local function load(dir, force)
	tracked[dir] = true
	if inflight[dir] then
		return
	end
	local now = vim.uv.now()
	if not force and retry_at[dir] and now < retry_at[dir] then
		return
	end
	local backend = detect(dir)
	if not backend then
		cache[dir] = {}
		return
	end
	inflight[dir] = true
	local cmd = backend == "jj" and { "jj", "diff", "--summary" }
		or { "git", "-c", "core.quotepath=false", "status", ".", "--short" }
	-- vim.system throws when the binary is missing, so a broken PATH or a
	-- vanished cwd must not take the oil listing down with it
	local spawned, spawn_err = pcall(vim.system, cmd, { cwd = dir, text = true }, function(res)
		inflight[dir] = nil
		if res.code ~= 0 then
			report_failure(dir, backend, res.stderr or ("exit code " .. res.code))
			return
		end
		retry_at[dir] = nil
		cache[dir] = backend == "jj" and parse_jj(res.stdout) or parse_git(res.stdout)
		vim.schedule(M.refresh)
	end)
	if not spawned then
		inflight[dir] = nil
		report_failure(dir, backend, tostring(spawn_err))
	end
end

---Rerender the oil buffers showing statuses we just learned.
M.refresh = function()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		-- oil deletes hidden buffers after cleanup_delay_ms, so re-check liveness
		if vim.api.nvim_buf_is_valid(bufnr) and vim.api.nvim_buf_is_loaded(bufnr) then
			if vim.bo[bufnr].filetype == "oil" then
				local dir = oil.get_current_dir(bufnr)
				-- rerendering throws away unsaved edits; never do that behind the user's back
				if dir and cache[dir] and not vim.bo[bufnr].modified then
					view.render_buffer_async(bufnr, { refetch = false })
				end
			end
		end
	end
end

---Drop the cached status for a directory and fetch it again.
---@param dir string
M.invalidate = function(dir)
	cache[dir] = nil
	retry_at[dir] = nil
	load(dir, true)
end

M.setup = function()
	define_highlights()

	require("oil.columns").register("vcs", {
		render = function(entry, _, bufnr)
			local name = entry[FIELD_NAME]
			if name == ".." then
				return ""
			end
			local dir = oil.get_current_dir(bufnr)
			if not dir then
				return ""
			end
			local status = cache[dir]
			if not status then
				load(dir)
				return ""
			end
			local code = status[name]
			if not code then
				return ""
			end
			return { code, hl[code].group }
		end,

		-- oil parses every line of the buffer, so consume our own column text
		parse = function(line)
			return line:match("^(%S+)%s+(.*)$")
		end,
	})

	local augroup = vim.api.nvim_create_augroup("nai_oil_vcs", { clear = true })

	-- colors are copied out of the colorscheme, so redo that on every switch
	vim.api.nvim_create_autocmd("ColorScheme", {
		group = augroup,
		callback = define_highlights,
	})

	-- entering a directory refetches it without emptying the cache first,
	-- so the column never flickers back to "-"
	vim.api.nvim_create_autocmd("User", {
		group = augroup,
		pattern = "OilEnter",
		callback = function(args)
			local dir = oil.get_current_dir(args.data.buf)
			if dir then
				load(dir, true)
			end
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		group = augroup,
		pattern = "OilMutationComplete",
		callback = function()
			for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
				if vim.api.nvim_buf_is_valid(bufnr) and vim.bo[bufnr].filetype == "oil" then
					local dir = oil.get_current_dir(bufnr)
					if dir then
						M.invalidate(dir)
					end
				end
			end
		end,
	})

	vim.api.nvim_create_autocmd("BufWritePost", {
		group = augroup,
		callback = function(args)
			local path = vim.api.nvim_buf_get_name(args.buf)
			-- a write can change the status of every directory above it;
			-- get_current_dir keeps a trailing slash, so compare prefixes directly
			for dir in pairs(tracked) do
				if path:sub(1, #dir) == dir then
					M.invalidate(dir)
				end
			end
		end,
	})
end

return M
