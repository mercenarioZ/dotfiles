import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io
import "components"

ShellRoot {
    id: root

    Theme { id: themeObject }
    ShellState { id: shellStateObject }
    Services {
        id: servicesObject
        onOsdRequested: (kind, label, value, icon) => shellStateObject.showOsd(kind, label, value, icon)
    }

    IpcHandler {
        target: "quiet"
        function toggleLauncher(): void { shellStateObject.toggleLauncher(); }
        function toggleDrawer(): void { shellStateObject.toggleDrawer(); }
        function toggleSession(): void { shellStateObject.toggleSession(); }
        function close(): void { shellStateObject.closeOverlays(); }
        function reloadShell(): void { Quickshell.reload(true); }
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "launcher"
        description: "Toggle Quiet launcher"
        onPressed: shellStateObject.toggleLauncher()
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "drawer"
        description: "Toggle Quiet control drawer"
        onPressed: shellStateObject.toggleDrawer()
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "session"
        description: "Toggle Quiet session menu"
        onPressed: shellStateObject.toggleSession()
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "volumeUp"
        onPressed: servicesObject.changeVolume(0.05)
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "volumeDown"
        onPressed: servicesObject.changeVolume(-0.05)
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "volumeMute"
        onPressed: servicesObject.toggleMute()
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "brightnessUp"
        onPressed: servicesObject.changeBrightness(0.05)
    }

    GlobalShortcut {
        appid: "quickshell"
        name: "brightnessDown"
        onPressed: servicesObject.changeBrightness(-0.05)
    }

    Variants {
        model: Quickshell.screens

        Rail {
            required property var modelData
            screen: modelData
            theme: themeObject
            shellState: shellStateObject
            services: servicesObject
        }
    }

    Variants {
        model: Quickshell.screens

        Launcher {
            required property var modelData
            screen: modelData
            theme: themeObject
            shellState: shellStateObject
        }
    }

    Variants {
        model: Quickshell.screens

        Drawer {
            required property var modelData
            screen: modelData
            theme: themeObject
            shellState: shellStateObject
            services: servicesObject
        }
    }

    Variants {
        model: Quickshell.screens

        NotificationToasts {
            required property var modelData
            screen: modelData
            theme: themeObject
            services: servicesObject
        }
    }

    Variants {
        model: Quickshell.screens

        Osd {
            required property var modelData
            screen: modelData
            theme: themeObject
            shellState: shellStateObject
        }
    }

    Variants {
        model: Quickshell.screens

        SessionMenu {
            required property var modelData
            screen: modelData
            theme: themeObject
            shellState: shellStateObject
        }
    }
}
