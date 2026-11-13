import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: root

    required property var theme
    required property var shellState

    color: "#99090a0c"
    visible: shellState.launcherOpen
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

    WlrLayershell.namespace: "quiet-launcher"
    WlrLayershell.layer: WlrLayer.Overlay

    function launchSelected(): void {
        if (apps.values.length === 0) return;
        const selected = apps.values[Math.max(0, results.currentIndex)];
        if (!selected) return;
        selected.execute();
        shellState.closeOverlays();
    }

    onVisibleChanged: {
        if (visible) {
            query.text = "";
            results.currentIndex = 0;
            query.forceActiveFocus();
        }
    }

    ScriptModel {
        id: apps
        values: {
            const queryText = query.text.trim().toLowerCase();
            const compactQuery = queryText.replace(/[\s._-]+/g, "");
            const all = [...DesktopEntries.applications.values]
                .filter(entry => entry.name)
                .sort((a, b) => a.name.localeCompare(b.name));

            if (!queryText) return all.slice(0, 12);

            return all.filter(entry => {
                const haystack = [
                    entry.name || "",
                    entry.genericName || "",
                    entry.comment || "",
                    ...(entry.keywords || []),
                    ...(entry.categories || []),
                ].join(" ").toLowerCase();
                return haystack.includes(queryText)
                    || haystack.replace(/[\s._-]+/g, "").includes(compactQuery);
            }).slice(0, 12);
        }
    }

    Rectangle {
        id: palette
        z: 1
        anchors.centerIn: parent
        width: Math.min(720, root.width - 80)
        height: Math.min(570, root.height - 80)
        radius: root.theme.radiusLarge
        color: root.theme.surfaceRaised
        border.width: 1
        border.color: root.theme.outlineStrong
        scale: root.visible ? 1 : 0.96
        opacity: root.visible ? 1 : 0

        Behavior on scale { NumberAnimation { duration: root.theme.motionNormal; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: root.theme.motionFast } }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 52
                spacing: 12

                Text {
                    text: "⌕"
                    color: root.theme.accent
                    font.family: root.theme.fontIcon
                    font.pixelSize: 24
                }

                TextInput {
                    id: query
                    Layout.fillWidth: true
                    color: root.theme.text
                    selectionColor: root.theme.accent
                    selectedTextColor: root.theme.background
                    font.family: root.theme.fontUi
                    font.pixelSize: 20
                    clip: true

                    Text {
                        anchors.fill: parent
                        text: "Search applications"
                        visible: !query.text
                        color: root.theme.textFaint
                        font: query.font
                        verticalAlignment: Text.AlignVCenter
                    }

                    Keys.onEscapePressed: root.shellState.closeOverlays()
                    Keys.onDownPressed: results.incrementCurrentIndex()
                    Keys.onUpPressed: results.decrementCurrentIndex()
                    Keys.onReturnPressed: root.launchSelected()
                    Keys.onEnterPressed: root.launchSelected()
                }

                Text {
                    text: "ESC"
                    color: root.theme.textFaint
                    font.family: root.theme.fontMono
                    font.pixelSize: 10
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 1
                color: root.theme.outline
            }

            ListView {
                id: results
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: apps
                clip: true
                spacing: 4
                currentIndex: 0
                keyNavigationWraps: true
                highlightMoveDuration: root.theme.motionFast

                highlight: Rectangle {
                    radius: root.theme.radiusMedium
                    color: root.theme.accentSoft
                    border.width: 1
                    border.color: root.theme.outlineStrong
                }

                delegate: Item {
                    id: entry
                    required property var modelData
                    required property int index
                    width: ListView.view.width
                    height: 54

                    RowLayout {
                        anchors.fill: parent
                        anchors.leftMargin: 12
                        anchors.rightMargin: 12
                        spacing: 13

                        IconImage {
                            source: Quickshell.iconPath(entry.modelData.icon, "application-x-executable")
                            implicitWidth: 30
                            implicitHeight: 30
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 0

                            Text {
                                Layout.fillWidth: true
                                text: entry.modelData.name
                                color: root.theme.text
                                elide: Text.ElideRight
                                font.family: root.theme.fontUi
                                font.pixelSize: 15
                                font.weight: Font.Medium
                            }

                            Text {
                                Layout.fillWidth: true
                                text: entry.modelData.genericName || entry.modelData.comment || "Application"
                                color: root.theme.textMuted
                                elide: Text.ElideRight
                                font.family: root.theme.fontUi
                                font.pixelSize: 11
                            }
                        }

                        Text {
                            text: entry.index === results.currentIndex ? "↵" : ""
                            color: root.theme.accent
                            font.family: root.theme.fontMono
                            font.pixelSize: 15
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: results.currentIndex = entry.index
                        onClicked: root.launchSelected()
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true

                Text {
                    text: apps.values.length + " results"
                    color: root.theme.textFaint
                    font.family: root.theme.fontMono
                    font.pixelSize: 10
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "↑ ↓ navigate   ↵ open"
                    color: root.theme.textFaint
                    font.family: root.theme.fontMono
                    font.pixelSize: 10
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
