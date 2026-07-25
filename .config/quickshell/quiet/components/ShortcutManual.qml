import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property var theme
    required property var shellState

    readonly property var sections: [
        {
            title: "ESSENTIALS",
            items: [
                { keys: "Super + Return", action: "Open terminal" },
                { keys: "Super + E", action: "Open Yazi" },
                { keys: "Super + B", action: "Open browser" },
                { keys: "Super + D / Space", action: "Application launcher" },
                { keys: "Super + O", action: "Control drawer" },
                { keys: "Super + /", action: "This manual" },
                { keys: "Super + Esc", action: "Session menu" },
                { keys: "Ctrl + Alt + L", action: "Lock session" }
            ]
        },
        {
            title: "WINDOWS",
            items: [
                { keys: "Super + Q", action: "Close window" },
                { keys: "Super + V", action: "Toggle floating" },
                { keys: "Super + F", action: "Toggle maximize" },
                { keys: "Super + Shift + F", action: "Toggle fullscreen" },
                { keys: "Super + P", action: "Toggle pseudotile" },
                { keys: "Super + J", action: "Change split direction" },
                { keys: "Super + G", action: "Toggle window group" },
                { keys: "Super + Tab", action: "Focus next window" }
            ]
        },
        {
            title: "MOVE & RESIZE",
            items: [
                { keys: "Super + Arrows", action: "Focus by direction" },
                { keys: "Super + Ctrl + Arrows", action: "Move window" },
                { keys: "Super + Alt + Arrows", action: "Swap windows" },
                { keys: "Super + Shift + Arrows", action: "Resize window" },
                { keys: "Super + Left mouse", action: "Drag window" },
                { keys: "Super + Right mouse", action: "Resize with mouse" },
                { keys: "Super + Shift + Tab", action: "Focus previous window" }
            ]
        },
        {
            title: "WORKSPACES",
            items: [
                { keys: "Super + 1…0", action: "Switch workspace 1–10" },
                { keys: "Super + Shift + 1…0", action: "Move to workspace" },
                { keys: "Super + Mouse wheel", action: "Previous / next workspace" },
                { keys: "Super + U", action: "Toggle scratchpad" },
                { keys: "Super + Shift + U", action: "Move to scratchpad" }
            ]
        },
        {
            title: "MEDIA & HARDWARE",
            items: [
                { keys: "Volume + / −", action: "Change volume" },
                { keys: "Volume mute", action: "Toggle audio mute" },
                { keys: "Microphone mute", action: "Toggle microphone" },
                { keys: "Brightness + / −", action: "Change brightness" },
                { keys: "Play / Next / Previous", action: "Control media" }
            ]
        },
        {
            title: "SCREENSHOTS",
            items: [
                { keys: "Print", action: "Capture full screen" },
                { keys: "Shift + Print", action: "Capture region" },
                { keys: "Super + Shift + S", action: "Capture and annotate" }
            ]
        }
    ]

    color: "#a6090a0c"
    visible: shellState.manualOpen
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

    WlrLayershell.namespace: "quiet-shortcut-manual"
    WlrLayershell.layer: WlrLayer.Overlay

    onVisibleChanged: {
        if (visible) manual.forceActiveFocus();
    }

    Rectangle {
        id: manual
        z: 1
        anchors.centerIn: parent
        width: Math.min(1080, root.width - 72)
        height: Math.min(720, root.height - 72)
        radius: root.theme.radiusLarge
        color: root.theme.surfaceRaised
        border.width: 1
        border.color: root.theme.outlineStrong
        focus: true
        scale: root.visible ? 1 : 0.96
        opacity: root.visible ? 1 : 0

        Behavior on scale { NumberAnimation { duration: root.theme.motionNormal; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: root.theme.motionFast } }

        Keys.onEscapePressed: root.shellState.closeOverlays()

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 14

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                spacing: 12

                Text {
                    text: "?"
                    color: root.theme.accent
                    font.family: root.theme.fontMono
                    font.pixelSize: 25
                    font.weight: Font.Bold
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        text: "Keyboard manual"
                        color: root.theme.text
                        font.family: root.theme.fontUi
                        font.pixelSize: 21
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: "Super is the Windows key · click ? or press Super + / anytime"
                        color: root.theme.textMuted
                        font.family: root.theme.fontUi
                        font.pixelSize: 10
                    }
                }

                Text {
                    text: "ESC TO CLOSE"
                    color: root.theme.textFaint
                    font.family: root.theme.fontMono
                    font.pixelSize: 10
                    font.letterSpacing: 0.8
                }
            }

            GridLayout {
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 3
                columnSpacing: 10
                rowSpacing: 10

                Repeater {
                    model: root.sections

                    Rectangle {
                        id: sectionCard
                        required property var modelData

                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignTop
                        implicitHeight: sectionContent.implicitHeight + 22
                        radius: root.theme.radiusMedium
                        color: root.theme.surface
                        border.width: 1
                        border.color: root.theme.outline

                        ColumnLayout {
                            id: sectionContent
                            anchors {
                                top: parent.top
                                left: parent.left
                                right: parent.right
                                margins: 11
                            }
                            spacing: 7

                            Text {
                                text: sectionCard.modelData.title
                                color: root.theme.accent
                                font.family: root.theme.fontMono
                                font.pixelSize: 10
                                font.weight: Font.DemiBold
                                font.letterSpacing: 1
                            }

                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 1
                                color: root.theme.outline
                            }

                            Repeater {
                                model: sectionCard.modelData.items

                                RowLayout {
                                    id: shortcutRow
                                    required property var modelData

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 25
                                    spacing: 8

                                    Rectangle {
                                        Layout.preferredWidth: 158
                                        Layout.preferredHeight: 23
                                        radius: 6
                                        color: root.theme.accentSoft
                                        border.width: 1
                                        border.color: root.theme.outlineStrong

                                        Text {
                                            anchors.centerIn: parent
                                            text: shortcutRow.modelData.keys
                                            color: root.theme.text
                                            font.family: root.theme.fontMono
                                            font.pixelSize: 9
                                            font.weight: Font.Medium
                                        }
                                    }

                                    Text {
                                        Layout.fillWidth: true
                                        text: shortcutRow.modelData.action
                                        color: root.theme.textMuted
                                        font.family: root.theme.fontUi
                                        font.pixelSize: 10
                                        elide: Text.ElideRight
                                    }
                                }
                            }
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
