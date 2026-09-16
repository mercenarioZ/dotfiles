local icons = require("mini.icons")

icons.setup()

-- plugins that ask for nvim-web-devicons (lualine, oil) get mini.icons instead
icons.mock_nvim_web_devicons()
