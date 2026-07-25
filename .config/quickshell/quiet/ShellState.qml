import QtQuick
import Quickshell

Scope {
    id: root

    property bool launcherOpen: false
    property bool drawerOpen: false
    property bool audioOutputsOpen: false
    property bool wallpaperOpen: false
    property bool sessionOpen: false

    property bool osdVisible: false
    property string osdKind: "volume"
    property string osdLabel: "Volume"
    property real osdValue: 0
    property string osdIcon: "♪"

    function closeOverlays(): void {
        launcherOpen = false;
        drawerOpen = false;
        audioOutputsOpen = false;
        wallpaperOpen = false;
        sessionOpen = false;
    }

    function toggleLauncher(): void {
        const next = !launcherOpen;
        closeOverlays();
        launcherOpen = next;
    }

    function toggleDrawer(): void {
        const next = !drawerOpen;
        closeOverlays();
        drawerOpen = next;
    }

    function toggleWallpaper(): void {
        const next = !wallpaperOpen;
        closeOverlays();
        wallpaperOpen = next;
    }

    function toggleAudioOutputs(): void {
        audioOutputsOpen = !audioOutputsOpen;
    }

    function toggleSession(): void {
        const next = !sessionOpen;
        closeOverlays();
        sessionOpen = next;
    }

    function showOsd(kind: string, label: string, value: real, icon: string): void {
        osdKind = kind;
        osdLabel = label;
        osdValue = Math.max(0, Math.min(1, value));
        osdIcon = icon;
        osdVisible = true;
        osdTimer.restart();
    }

    Timer {
        id: osdTimer
        interval: 1250
        onTriggered: root.osdVisible = false
    }
}
