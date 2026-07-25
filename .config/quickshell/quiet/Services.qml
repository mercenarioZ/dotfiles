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

    PwObjectTracker {
        objects: root.sink ? [root.sink] : []
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
}
