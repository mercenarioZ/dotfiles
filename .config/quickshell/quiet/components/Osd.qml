import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland

PanelWindow {
    id: root

    required property var theme
    required property var shellState

    color: "transparent"
    visible: shellState.osdVisible
    implicitWidth: 330
    implicitHeight: 68
    exclusionMode: ExclusionMode.Ignore

    anchors {
        bottom: true
    }

    margins.bottom: 42

    WlrLayershell.namespace: "quiet-osd"
    WlrLayershell.layer: WlrLayer.Overlay

    Rectangle {
        anchors.fill: parent
        radius: root.theme.radiusMedium
        color: root.theme.surfaceRaised
        border.width: 1
        border.color: root.theme.outlineStrong

        RowLayout {
            anchors.fill: parent
            anchors.margins: 14
            spacing: 13

            Text {
                text: root.shellState.osdIcon
                color: root.theme.accent
                font.family: root.theme.fontIcon
                font.pixelSize: 20
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 7

                RowLayout {
                    Layout.fillWidth: true
                    Text { text: root.shellState.osdLabel; color: root.theme.text; font.family: root.theme.fontUi; font.pixelSize: 12; font.weight: Font.DemiBold }
                    Item { Layout.fillWidth: true }
                    Text { text: Math.round(root.shellState.osdValue * 100) + "%"; color: root.theme.textMuted; font.family: root.theme.fontMono; font.pixelSize: 11 }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 5
                    radius: 3
                    color: root.theme.surfaceHover

                    Rectangle {
                        width: parent.width * root.shellState.osdValue
                        height: parent.height
                        radius: parent.radius
                        color: root.theme.accent

                        Behavior on width { NumberAnimation { duration: root.theme.motionFast } }
                    }
                }
            }
        }
    }
}
