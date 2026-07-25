import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

PanelWindow {
    id: root

    required property var theme
    required property var shellState

    property string confirmation: ""

    color: "#b0090a0c"
    visible: shellState.sessionOpen
    focusable: true
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: screen ? screen.width : 1920
    implicitHeight: screen ? screen.height : 1080

    anchors {
        top: true
        right: true
        bottom: true
        left: true
    }

    WlrLayershell.namespace: "quiet-session"
    WlrLayershell.layer: WlrLayer.Overlay

    function runAction(action: string): void {
        if (action === "lock") {
            shellState.closeOverlays();
            Quickshell.execDetached(["hyprlock"]);
            return;
        }
        if (action === "suspend") {
            shellState.closeOverlays();
            Quickshell.execDetached(["systemctl", "suspend"]);
            return;
        }

        if (confirmation !== action) {
            confirmation = action;
            confirmTimer.restart();
            return;
        }

        shellState.closeOverlays();
        if (action === "logout") Quickshell.execDetached(["hyprctl", "dispatch", "hl.dsp.exit()"]);
        if (action === "reboot") Quickshell.execDetached(["systemctl", "reboot"]);
        if (action === "poweroff") Quickshell.execDetached(["systemctl", "poweroff"]);
    }

    onVisibleChanged: {
        confirmation = "";
        if (visible) menu.forceActiveFocus();
    }

    Timer {
        id: confirmTimer
        interval: 4500
        onTriggered: root.confirmation = ""
    }

    Rectangle {
        id: menu
        z: 1
        anchors.centerIn: parent
        width: Math.min(680, root.width - 80)
        height: 260
        radius: root.theme.radiusLarge
        color: root.theme.surfaceRaised
        border.width: 1
        border.color: root.theme.outlineStrong
        focus: true

        Keys.onEscapePressed: root.shellState.closeOverlays()

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 24
            spacing: 20

            ColumnLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 3
                Text { Layout.alignment: Qt.AlignHCenter; text: "End this session?"; color: root.theme.text; font.family: root.theme.fontUi; font.pixelSize: 23; font.weight: Font.DemiBold }
                Text { Layout.alignment: Qt.AlignHCenter; text: root.confirmation ? "Select " + root.confirmation + " again to confirm" : "Lock, rest, or leave quietly"; color: root.confirmation ? root.theme.accent : root.theme.textMuted; font.family: root.theme.fontUi; font.pixelSize: 12 }
            }

            RowLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                spacing: 10

                Repeater {
                    model: [
                        { action: "lock", icon: "◈", label: "Lock", danger: false },
                        { action: "suspend", icon: "◐", label: "Suspend", danger: false },
                        { action: "logout", icon: "↪", label: "Logout", danger: false },
                        { action: "reboot", icon: "↻", label: "Reboot", danger: true },
                        { action: "poweroff", icon: "⏻", label: "Power off", danger: true },
                    ]

                    Rectangle {
                        id: actionButton
                        required property var modelData
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: root.theme.radiusMedium
                        color: actionMouse.containsMouse
                            ? (modelData.danger ? "#382123" : root.theme.surfaceHover)
                            : (root.confirmation === modelData.action ? root.theme.accentSoft : root.theme.surface)
                        border.width: 1
                        border.color: root.confirmation === modelData.action ? root.theme.accent : root.theme.outline

                        Column {
                            anchors.centerIn: parent
                            spacing: 8
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: actionButton.modelData.icon; color: actionButton.modelData.danger ? root.theme.danger : root.theme.accent; font.family: root.theme.fontIcon; font.pixelSize: 25 }
                            Text { anchors.horizontalCenter: parent.horizontalCenter; text: actionButton.modelData.label; color: root.theme.text; font.family: root.theme.fontUi; font.pixelSize: 12; font.weight: Font.Medium }
                        }

                        MouseArea {
                            id: actionMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            onClicked: root.runAction(actionButton.modelData.action)
                        }
                    }
                }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        z: -1
        onClicked: root.shellState.closeOverlays()
    }
}
