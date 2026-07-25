import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

PanelWindow {
    id: root

    required property var theme
    required property var shellState
    required property var services

    color: "transparent"
    implicitHeight: theme.railZone
    exclusiveZone: theme.railZone
    aboveWindows: true

    anchors {
        top: true
        left: true
        right: true
    }

    WlrLayershell.namespace: "quiet-rail"
    WlrLayershell.layer: WlrLayer.Top

    readonly property var monitor: Hyprland.monitorFor(root.screen)
    readonly property int activeWorkspace: monitor && monitor.activeWorkspace
        ? monitor.activeWorkspace.id
        : (Hyprland.focusedWorkspace ? Hyprland.focusedWorkspace.id : 1)
    readonly property string activeApplication: {
        const toplevel = Hyprland.activeToplevel;
        if (!toplevel) return "Desktop";

        const appId = toplevel.wayland ? String(toplevel.wayland.appId || "") : "";
        if (appId) {
            const parts = appId.replace(/\.desktop$/i, "").split(".");
            const name = parts[parts.length - 1].replace(/[-_]/g, " ");
            return name.replace(/\b\w/g, letter => letter.toUpperCase());
        }

        const title = String(toplevel.title || "").trim();
        return title ? title.split(/\s+[—–-]\s+/).pop() : "Desktop";
    }

    Rectangle {
        id: bar

        anchors {
            top: parent.top
            left: parent.left
            right: parent.right
            topMargin: root.theme.railMargin
            leftMargin: root.theme.railMargin
            rightMargin: root.theme.railMargin
        }
        height: root.theme.railWidth
        radius: 0
        color: root.theme.railBackground
        border.width: 0

        Rectangle {
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            height: 1
            color: "#26ffffff"
        }

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onWheel: event => Hyprland.dispatch(
                event.angleDelta.y < 0
                    ? 'hl.dsp.focus({ workspace = "e+1" })'
                    : 'hl.dsp.focus({ workspace = "e-1" })'
            )
        }

        Row {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 7
            spacing: 1

            HoverButton {
                theme: root.theme
                icon: ""
                iconSize: 17
                implicitWidth: 30
                implicitHeight: 28
                buttonRadius: 6
                active: root.shellState.launcherOpen
                activeColor: "#28ffffff"
                activeTextColor: root.theme.text
                onClicked: root.shellState.toggleLauncher()
                onSecondaryClicked: root.shellState.toggleSession()
            }

            Item {
                width: Math.min(260, Math.ceil(applicationName.implicitWidth) + 4)
                height: 28

                Behavior on width {
                    NumberAnimation {
                        duration: root.theme.motionFast
                        easing.type: Easing.OutCubic
                    }
                }

                Text {
                    id: applicationName
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    text: root.activeApplication
                    color: root.theme.text
                    elide: Text.ElideRight
                    font.family: root.theme.fontUi
                    font.pixelSize: 14
                    font.weight: Font.DemiBold
                }
            }

            HoverButton {
                theme: root.theme
                label: "Help"
                labelFont: root.theme.fontUi
                labelSize: 13
                labelWeight: Font.DemiBold
                implicitWidth: 46
                implicitHeight: 28
                buttonRadius: 6
                active: root.shellState.manualOpen
                activeColor: "#28ffffff"
                activeTextColor: root.theme.text
                onClicked: root.shellState.toggleManual()
            }
        }

        Rectangle {
            anchors.centerIn: parent
            width: workspaces.width + 6
            height: 26
            radius: 9
            color: "#16000000"
            border.width: 1
            border.color: "#18ffffff"

            Row {
                id: workspaces
                anchors.centerIn: parent
                spacing: 1

                Repeater {
                    model: 8

                    HoverButton {
                        required property int index
                        theme: root.theme
                        label: String(index + 1)
                        labelFont: root.theme.fontUi
                        labelSize: 12
                        labelWeight: Font.DemiBold
                        active: root.activeWorkspace === index + 1
                        activeColor: "#e8f5f0e6"
                        activeTextColor: root.theme.background
                        implicitWidth: 26
                        implicitHeight: 22
                        buttonRadius: 7
                        onClicked: Hyprland.dispatch('hl.dsp.focus({ workspace = "' + (index + 1) + '" })')
                    }
                }
            }
        }

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 7
            spacing: 1

            HoverButton {
                visible: root.services.inputMethodAvailable
                theme: root.theme
                label: root.services.inputMethodLabel
                labelFont: root.theme.fontUi
                labelSize: 13
                labelWeight: Font.DemiBold
                active: root.services.vietnameseInputActive
                activeColor: "#e8f5f0e6"
                activeTextColor: root.theme.background
                implicitWidth: visible ? 32 : 0
                implicitHeight: 28
                buttonRadius: 6
                onClicked: root.services.toggleInputMethod()
                onSecondaryClicked: root.services.openInputMethodSettings()
            }

            HoverButton {
                theme: root.theme
                icon: root.services.networkName === "offline" ? "󰤭" : "󰤨"
                iconSize: 16
                implicitWidth: 30
                implicitHeight: 28
                buttonRadius: 6
                onClicked: root.shellState.toggleDrawer()
            }

            HoverButton {
                theme: root.theme
                icon: root.services.muted ? "󰖁" : "󰕾"
                iconSize: 16
                implicitWidth: 30
                implicitHeight: 28
                buttonRadius: 6
                onClicked: root.services.toggleMute()
                onSecondaryClicked: root.shellState.toggleDrawer()
                onWheel: delta => root.services.changeVolume(delta > 0 ? 0.05 : -0.05)
            }

            HoverButton {
                visible: root.services.hasBattery
                theme: root.theme
                label: Math.round(root.services.batteryLevel * 100) + "%"
                labelFont: root.theme.fontUi
                labelSize: 13
                labelWeight: Font.DemiBold
                implicitWidth: visible ? 48 : 0
                implicitHeight: 28
                buttonRadius: 6
                onClicked: root.shellState.toggleDrawer()
            }

            Item {
                width: 126
                height: 28

                SystemClock {
                    id: clock
                    precision: SystemClock.Minutes
                }

                Text {
                    anchors.centerIn: parent
                    text: Qt.formatDateTime(clock.date, "ddd MMM d  HH:mm")
                    horizontalAlignment: Text.AlignHCenter
                    color: root.theme.text
                    font.family: root.theme.fontUi
                    font.pixelSize: 13
                    font.weight: Font.DemiBold
                }

                MouseArea {
                    anchors.fill: parent
                    hoverEnabled: true
                    onClicked: root.shellState.toggleDrawer()
                }
            }

            HoverButton {
                theme: root.theme
                icon: "󰐥"
                iconSize: 15
                danger: true
                implicitWidth: 30
                implicitHeight: 28
                buttonRadius: 6
                onClicked: root.shellState.toggleSession()
            }
        }
    }
}
