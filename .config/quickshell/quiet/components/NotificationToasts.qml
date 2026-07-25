import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: root

    required property var theme
    required property var services

    color: "transparent"
    implicitWidth: 390
    implicitHeight: Math.max(1, toastColumn.height + 20)
    exclusionMode: ExclusionMode.Ignore
    visible: true

    anchors {
        top: true
        right: true
    }

    margins {
        top: root.theme.railZone + 8
        right: 14
    }

    WlrLayershell.namespace: "quiet-toast"
    WlrLayershell.layer: WlrLayer.Overlay

    Column {
        id: toastColumn
        anchors.top: parent.top
        anchors.right: parent.right
        width: 370
        spacing: 8

        Repeater {
            model: root.services.notificationServer.trackedNotifications

            Rectangle {
                id: toast
                required property var modelData
                required property int index
                property bool showing: !modelData.lastGeneration
                readonly property bool amongNewest: index >= Math.max(0, root.services.notificationServer.trackedNotifications.values.length - 4)

                width: toastColumn.width
                height: showing && amongNewest ? 82 : 0
                opacity: showing && amongNewest ? 1 : 0
                radius: root.theme.radiusMedium
                color: root.theme.surfaceRaised
                border.width: 1
                border.color: root.theme.outlineStrong
                clip: true

                Behavior on height { NumberAnimation { duration: root.theme.motionNormal; easing.type: Easing.OutCubic } }
                Behavior on opacity { NumberAnimation { duration: root.theme.motionFast } }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 11

                    IconImage {
                        source: Quickshell.iconPath(toast.modelData.appIcon, "dialog-information")
                        implicitWidth: 34
                        implicitHeight: 34
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 2

                        Text {
                            Layout.fillWidth: true
                            text: toast.modelData.summary || toast.modelData.appName
                            color: root.theme.text
                            font.family: root.theme.fontUi
                            font.pixelSize: 13
                            font.weight: Font.DemiBold
                            elide: Text.ElideRight
                        }

                        Text {
                            Layout.fillWidth: true
                            text: toast.modelData.body || toast.modelData.appName
                            color: root.theme.textMuted
                            font.family: root.theme.fontUi
                            font.pixelSize: 11
                            elide: Text.ElideRight
                            maximumLineCount: 2
                            wrapMode: Text.Wrap
                            textFormat: Text.PlainText
                        }
                    }

                    Text {
                        text: "×"
                        color: root.theme.textMuted
                        font.pixelSize: 18
                        MouseArea { anchors.fill: parent; onClicked: toast.modelData.dismiss() }
                    }
                }

                Timer {
                    running: toast.showing
                    interval: toast.modelData.expireTimeout > 0
                        ? Math.max(3200, toast.modelData.expireTimeout * 1000)
                        : 5200
                    onTriggered: toast.showing = false
                }

                MouseArea {
                    anchors.fill: parent
                    z: -1
                    onClicked: toast.showing = false
                }
            }
        }
    }
}
