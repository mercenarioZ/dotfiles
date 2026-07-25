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
        radius: root.theme.radiusMedium
        color: root.theme.surface
        border.width: 1
        border.color: root.theme.outline

        MouseArea {
            anchors.fill: parent
            acceptedButtons: Qt.NoButton
            onWheel: event => Hyprland.dispatch(
                event.angleDelta.y < 0
                    ? 'hl.dsp.focus({ workspace = "e+1" })'
                    : 'hl.dsp.focus({ workspace = "e-1" })'
            )
        }

        HoverButton {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 4
            theme: root.theme
            icon: "◇"
            iconSize: 20
            implicitWidth: 34
            implicitHeight: 34
            active: root.shellState.launcherOpen
            onClicked: root.shellState.toggleLauncher()
        }

        Row {
            id: workspaces
            anchors.centerIn: parent
            spacing: 2

            Repeater {
                model: 8

                HoverButton {
                    required property int index
                    theme: root.theme
                    label: String(index + 1)
                    active: root.activeWorkspace === index + 1
                    implicitWidth: 34
                    implicitHeight: 34
                    buttonRadius: 10
                    onClicked: Hyprland.dispatch('hl.dsp.focus({ workspace = "' + (index + 1) + '" })')
                }
            }
        }

        Rectangle {
            anchors.top: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: 2
            width: 44
            height: 3
            radius: 2
            color: root.theme.accent
            opacity: Hyprland.activeToplevel ? 0.9 : 0.25

            Behavior on opacity { NumberAnimation { duration: root.theme.motionNormal } }
        }

        Row {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 4
            spacing: 3

            HoverButton {
                theme: root.theme
                icon: root.services.networkName === "offline" ? "×" : "⌁"
                iconSize: 17
                implicitWidth: 34
                implicitHeight: 34
                onClicked: root.shellState.toggleDrawer()
            }

            HoverButton {
                theme: root.theme
                icon: root.services.muted ? "×" : "♪"
                iconSize: 17
                implicitWidth: 34
                implicitHeight: 34
                onClicked: root.services.toggleMute()
                onSecondaryClicked: root.shellState.toggleDrawer()
                onWheel: delta => root.services.changeVolume(delta > 0 ? 0.05 : -0.05)
            }

            HoverButton {
                visible: root.services.hasBattery
                theme: root.theme
                label: Math.round(root.services.batteryLevel * 100) + "%"
                implicitWidth: visible ? 46 : 0
                implicitHeight: 34
                onClicked: root.shellState.toggleDrawer()
            }

            Item {
                width: 62
                height: 34

                SystemClock {
                    id: clock
                    precision: SystemClock.Minutes
                }

                Text {
                    anchors.centerIn: parent
                    text: Qt.formatDateTime(clock.date, "HH:mm")
                    horizontalAlignment: Text.AlignHCenter
                    color: root.theme.text
                    font.family: root.theme.fontMono
                    font.pixelSize: 12
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
                icon: "⏻"
                danger: true
                implicitWidth: 34
                implicitHeight: 34
                onClicked: root.shellState.toggleSession()
            }
        }
    }
}
