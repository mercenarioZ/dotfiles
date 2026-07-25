import QtQuick
import Quickshell
import Quickshell.Io
import Quickshell.Services.Mpris
import Quickshell.Services.Notifications
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower

Scope {
    id: root

    property alias notificationServer: notifications
    readonly property var sink: Pipewire.defaultAudioSink
    readonly property var sinkAudio: sink && sink.audio ? sink.audio : null
    readonly property real volume: sinkAudio ? sinkAudio.volume : 0
    readonly property bool muted: sinkAudio ? sinkAudio.muted : false
    readonly property var audioSinks: {
        if (!Pipewire.ready) return [];
        const nodes = Pipewire.nodes.values || [];
        return nodes
            .filter(node => node && node.audio && node.isSink && !node.isStream)
            .sort((left, right) => audioDeviceName(left).localeCompare(audioDeviceName(right)));
    }
    readonly property string audioSinkName: audioDeviceName(sink)
    property int requestedAudioSinkId: -1
    property string audioOutputStatus: ""

    readonly property var battery: UPower.displayDevice
    readonly property bool hasBattery: battery && battery.ready && battery.isLaptopBattery && battery.isPresent
    readonly property real batteryLevel: {
        if (!hasBattery) return 0;
        return battery.percentage > 1 ? battery.percentage / 100 : battery.percentage;
    }

    readonly property var player: {
        const players = Mpris.players.values;
        if (!players || players.length === 0) return null;
        return players.find(candidate => candidate.isPlaying) || players[0];
    }

    property real brightness: 0.5
    property string networkName: "offline"
    property bool wifiEnabled: false
    property bool bluetoothEnabled: false
    property bool nightLightAvailable: false
    property bool nightLightEnabled: false
    readonly property int nightLightTemperature: 5600

    readonly property string homeDirectory: String(Quickshell.env("HOME") || "")
    readonly property string wallpaperDirectory: homeDirectory + "/Pictures/wallpapers"
    readonly property string wallpaperStateDirectory: homeDirectory + "/.local/state/quiet"
    readonly property string wallpaperLink: wallpaperStateDirectory + "/wallpaper"
    readonly property string defaultWallpaper: wallpaperDirectory + "/Sunset-room.png"
    property string currentWallpaper: ""
    property string pendingWallpaper: ""
    property string wallpaperStatus: ""
    property bool wallpaperReady: false
    property bool wallpaperBusy: false
    property int wallpaperApplyAttempts: 0

    signal osdRequested(string kind, string label, real value, string icon)
    signal notificationArrived(var notification)

    function changeVolume(delta: real): void {
        if (!sinkAudio) return;
        sinkAudio.muted = false;
        sinkAudio.volume = Math.max(0, Math.min(1, sinkAudio.volume + delta));
        osdRequested("volume", "Volume", sinkAudio.volume, "♪");
    }

    function setVolume(value: real): void {
        if (!sinkAudio) return;
        sinkAudio.volume = Math.max(0, Math.min(1, value));
        if (value > 0) sinkAudio.muted = false;
        osdRequested("volume", "Volume", sinkAudio.volume, "♪");
    }

    function toggleMute(): void {
        if (!sinkAudio) return;
        sinkAudio.muted = !sinkAudio.muted;
        osdRequested("volume", sinkAudio.muted ? "Muted" : "Volume", sinkAudio.muted ? 0 : sinkAudio.volume, sinkAudio.muted ? "×" : "♪");
    }

    function audioDeviceName(node: var): string {
        if (!node) return "No output device";
        return node.description || node.nickname || node.name || "Audio output";
    }

    function isActiveAudioSink(node: var): bool {
        if (!node) return false;
        const activeId = requestedAudioSinkId >= 0
            ? requestedAudioSinkId
            : (sink ? sink.id : -1);
        return node.id === activeId;
    }

    function setAudioSink(node: var): void {
        if (!node || !node.audio || !node.isSink || node.isStream) return;

        if (sink && node.id === sink.id) {
            audioOutputStatus = "Already using " + audioDeviceName(node);
            audioOutputStatusTimer.restart();
            return;
        }

        requestedAudioSinkId = node.id;
        audioOutputStatus = "Switching to " + audioDeviceName(node) + "…";
        Pipewire.preferredDefaultAudioSink = node;
        audioOutputStatusTimer.restart();
    }

    function setAudioSinkById(id: int): void {
        const node = audioSinks.find(candidate => candidate.id === id);
        if (node) setAudioSink(node);
    }

    function setBrightness(value: real): void {
        brightness = Math.max(0.05, Math.min(1, value));
        Quickshell.execDetached(["brightnessctl", "set", Math.round(brightness * 100) + "%"]);
        osdRequested("brightness", "Brightness", brightness, "◐");
    }

    function changeBrightness(delta: real): void {
        setBrightness(brightness + delta);
    }

    function toggleWifi(): void {
        wifiEnabled = !wifiEnabled;
        Quickshell.execDetached(["nmcli", "radio", "wifi", wifiEnabled ? "on" : "off"]);
        networkTimer.restart();
    }

    function openNetworkSettings(): void {
        Quickshell.execDetached(["nm-connection-editor"]);
    }

    function openBluetoothSettings(): void {
        Quickshell.execDetached(["blueman-manager"]);
    }

    function toggleNightLight(): void {
        if (nightLightEnabled) {
            Quickshell.execDetached([
                "sh", "-c",
                "hyprctl hyprsunset temperature 6000 >/dev/null && hyprctl hyprsunset identity >/dev/null"
            ]);
            nightLightEnabled = false;
        } else {
            Quickshell.execDetached([
                "hyprctl", "hyprsunset", "temperature",
                String(nightLightTemperature)
            ]);
            nightLightEnabled = true;
        }
        nightLightRefreshTimer.restart();
    }

    function openWallpaperFolder(): void {
        Quickshell.execDetached(["xdg-open", wallpaperDirectory]);
    }

    function setWallpaper(path: string): void {
        if (!wallpaperReady || wallpaperBusy || !path.startsWith(wallpaperDirectory + "/")) return;

        pendingWallpaper = path;
        wallpaperBusy = true;
        wallpaperStatus = "Saving selection…";
        wallpaperLinker.exec(["ln", "-sfn", path, wallpaperLink]);
    }

    function applyPendingWallpaper(): void {
        if (!pendingWallpaper) return;
        wallpaperStatus = "Applying wallpaper…";
        wallpaperSetter.exec([
            "hyprctl", "hyprpaper", "wallpaper",
            ", " + pendingWallpaper + ", cover"
        ]);
    }

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
    }

    Connections {
        target: Pipewire

        function onDefaultAudioSinkChanged(): void {
            if (!root.sink) return;
            root.requestedAudioSinkId = -1;
            root.audioOutputStatus = "Using " + root.audioDeviceName(root.sink);
            if (audioOutputStatusTimer) audioOutputStatusTimer.restart();
            root.osdRequested(
                "volume",
                root.audioDeviceName(root.sink),
                root.sink.audio ? root.sink.audio.volume : 0,
                "♪"
            );
        }
    }

    NotificationServer {
        id: notifications
        bodySupported: true
        actionsSupported: true
        persistenceSupported: true
        keepOnReload: true

        onNotification: notification => {
            notification.tracked = true;
            root.notificationArrived(notification);
        }
    }

    Process {
        id: brightnessReader
        command: ["sh", "-c", "brightnessctl -m | head -n 1 | cut -d, -f4 | tr -d '%' "]
        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = parseInt(text.trim());
                if (!isNaN(parsed)) root.brightness = Math.max(0, Math.min(1, parsed / 100));
            }
        }
    }

    Process {
        id: networkReader
        command: ["sh", "-c", "printf '%s\\n' \"$(nmcli -t -f TYPE,STATE,CONNECTION device status 2>/dev/null | awk -F: '$2 == \\\"connected\\\" {print $3; exit}')\"; nmcli radio wifi 2>/dev/null"]
        stdout: StdioCollector {
            onStreamFinished: {
                const lines = text.trim().split("\n");
                root.networkName = lines[0] || "offline";
                root.wifiEnabled = (lines[1] || "").trim() === "enabled";
            }
        }
    }

    Process {
        id: bluetoothReader
        command: ["sh", "-c", "bluetoothctl show 2>/dev/null | awk '/Powered:/ {print $2; exit}'"]
        stdout: StdioCollector {
            onStreamFinished: root.bluetoothEnabled = text.trim() === "yes"
        }
    }

    Process {
        id: nightLightReader
        command: ["hyprctl", "hyprsunset", "temperature"]
        stdout: StdioCollector {
            onStreamFinished: {
                const parsed = parseInt(text.trim());
                root.nightLightAvailable = !isNaN(parsed);
                if (!isNaN(parsed)) root.nightLightEnabled = parsed < 6000;
            }
        }
    }

    Process {
        id: wallpaperStateInitializer
        command: ["mkdir", "-p", root.wallpaperStateDirectory]
        running: true
        onExited: (exitCode, exitStatus) => {
            root.wallpaperReady = exitCode === 0;
            if (root.wallpaperReady) wallpaperReader.running = true;
            else root.wallpaperStatus = "Could not create wallpaper state";
        }
    }

    Process {
        id: wallpaperReader
        command: ["readlink", "-f", root.wallpaperLink]
        stdout: StdioCollector {
            onStreamFinished: {
                const path = text.trim();
                if (path) root.currentWallpaper = path;
            }
        }
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) root.setWallpaper(root.defaultWallpaper);
        }
    }

    Process {
        id: wallpaperLinker
        onExited: (exitCode, exitStatus) => {
            if (exitCode !== 0) {
                root.wallpaperBusy = false;
                root.wallpaperStatus = "Could not save wallpaper";
                return;
            }

            root.currentWallpaper = root.pendingWallpaper;
            root.wallpaperApplyAttempts = 0;
            root.applyPendingWallpaper();
        }
    }

    Process {
        id: wallpaperSetter
        onExited: (exitCode, exitStatus) => {
            if (exitCode === 0) {
                root.wallpaperBusy = false;
                root.wallpaperStatus = "Wallpaper applied";
                wallpaperStatusTimer.restart();
                return;
            }

            if (root.wallpaperApplyAttempts === 0) {
                root.wallpaperApplyAttempts = 1;
                root.wallpaperStatus = "Starting Hyprpaper…";
                Quickshell.execDetached(["hyprpaper"]);
                wallpaperRetryTimer.restart();
                return;
            }

            root.wallpaperBusy = false;
            root.wallpaperStatus = "Hyprpaper did not respond";
        }
    }

    Timer {
        id: brightnessTimer
        running: true
        repeat: true
        interval: 7000
        triggeredOnStart: true
        onTriggered: brightnessReader.running = true
    }

    Timer {
        id: networkTimer
        running: true
        repeat: true
        interval: 12000
        triggeredOnStart: true
        onTriggered: networkReader.running = true
    }

    Timer {
        running: true
        repeat: true
        interval: 15000
        triggeredOnStart: true
        onTriggered: bluetoothReader.running = true
    }

    Timer {
        id: nightLightRefreshTimer
        running: true
        repeat: true
        interval: 5000
        triggeredOnStart: true
        onTriggered: if (!nightLightReader.running) nightLightReader.running = true
    }

    Timer {
        id: wallpaperRetryTimer
        interval: 700
        onTriggered: root.applyPendingWallpaper()
    }

    Timer {
        id: wallpaperStatusTimer
        interval: 2200
        onTriggered: root.wallpaperStatus = ""
    }

    Timer {
        id: audioOutputStatusTimer
        interval: 2600
        onTriggered: root.audioOutputStatus = ""
    }
}
