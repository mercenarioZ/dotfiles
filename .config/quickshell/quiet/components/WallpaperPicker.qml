import QtQuick
import QtQuick.Layouts
import Qt.labs.folderlistmodel
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root

    required property var theme
    required property var shellState
    required property var services

    color: "#a6090a0c"
    visible: shellState.wallpaperOpen
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

    WlrLayershell.namespace: "quiet-wallpaper-picker"
    WlrLayershell.layer: WlrLayer.Overlay

    function localPath(fileUrl: var): string {
        const encoded = String(fileUrl);
        return decodeURIComponent(encoded.startsWith("file://") ? encoded.slice(7) : encoded);
    }

    function displayName(path: string): string {
        if (!path) return "No wallpaper selected";
        return path.slice(path.lastIndexOf("/") + 1).replace(/\.[^.]+$/, "");
    }

    onVisibleChanged: {
        if (visible) {
            query.text = "";
            query.forceActiveFocus();
        }
    }

    FolderListModel {
        id: wallpaperFiles
        folder: "file://" + root.services.wallpaperDirectory
        rootFolder: folder
        nameFilters: ["*.png", "*.jpg", "*.jpeg", "*.webp"]
        showFiles: true
        showDirs: false
        showDotAndDotDot: false
        showHidden: false
        showOnlyReadable: true
        caseSensitive: false
        sortField: FolderListModel.Name
        sortCaseSensitive: false
    }

    ScriptModel {
        id: filteredWallpapers
        values: {
            const needle = query.text.trim().toLowerCase();
            const files = [];
            const count = wallpaperFiles.count;

            for (let index = 0; index < count; index++) {
                const fileName = String(wallpaperFiles.get(index, "fileName") || "");
                if (!needle || fileName.toLowerCase().includes(needle)) {
                    files.push({
                        fileName: fileName,
                        fileUrl: wallpaperFiles.get(index, "fileUrl")
                    });
                }
            }

            return files;
        }
    }

    Rectangle {
        id: palette
        z: 1
        anchors.centerIn: parent
        width: Math.min(940, root.width - 72)
        height: Math.min(700, root.height - 72)
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
            anchors.margins: 18
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                Layout.preferredHeight: 48
                spacing: 12

                Text {
                    text: "󰸉"
                    color: root.theme.accent
                    font.family: root.theme.fontIcon
                    font.pixelSize: 24
                }

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 0

                    Text {
                        text: "Choose wallpaper"
                        color: root.theme.text
                        font.family: root.theme.fontUi
                        font.pixelSize: 20
                        font.weight: Font.DemiBold
                    }

                    Text {
                        Layout.fillWidth: true
                        text: root.services.wallpaperStatus
                            || root.displayName(root.services.currentWallpaper)
                        color: root.services.wallpaperStatus ? root.theme.accent : root.theme.textMuted
                        font.family: root.theme.fontUi
                        font.pixelSize: 10
                        elide: Text.ElideRight
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 110
                    Layout.preferredHeight: 34
                    radius: root.theme.radiusSmall
                    color: folderMouse.containsMouse ? root.theme.surfaceHover : root.theme.surface
                    border.width: 1
                    border.color: root.theme.outline

                    Row {
                        anchors.centerIn: parent
                        spacing: 6
                        Text { text: "□"; color: root.theme.accent; font.family: root.theme.fontIcon; font.pixelSize: 13 }
                        Text { text: "Open folder"; color: root.theme.text; font.family: root.theme.fontUi; font.pixelSize: 10 }
                    }

                    MouseArea {
                        id: folderMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.services.openWallpaperFolder()
                    }
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
                Layout.preferredHeight: 42
                radius: root.theme.radiusMedium
                color: root.theme.surface
                border.width: 1
                border.color: query.activeFocus ? root.theme.outlineStrong : root.theme.outline

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 12
                    anchors.rightMargin: 12
                    spacing: 9

                    Text {
                        text: "⌕"
                        color: root.theme.accent
                        font.family: root.theme.fontIcon
                        font.pixelSize: 18
                    }

                    TextInput {
                        id: query
                        Layout.fillWidth: true
                        color: root.theme.text
                        selectionColor: root.theme.accent
                        selectedTextColor: root.theme.background
                        font.family: root.theme.fontUi
                        font.pixelSize: 14
                        clip: true

                        Text {
                            anchors.fill: parent
                            text: "Filter " + wallpaperFiles.count + " wallpapers"
                            visible: !query.text
                            color: root.theme.textFaint
                            font: query.font
                            verticalAlignment: Text.AlignVCenter
                        }

                        Keys.onEscapePressed: root.shellState.closeOverlays()
                    }

                    Text {
                        text: filteredWallpapers.values.length + " shown"
                        color: root.theme.textFaint
                        font.family: root.theme.fontMono
                        font.pixelSize: 9
                    }
                }
            }

            GridView {
                id: wallpaperGrid
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                model: filteredWallpapers
                cellWidth: width / Math.max(1, Math.floor(width / 196))
                cellHeight: 148
                boundsBehavior: Flickable.StopAtBounds

                delegate: Item {
                    id: tile
                    required property var modelData
                    required property int index

                    readonly property string filePath: root.localPath(modelData.fileUrl)
                    readonly property bool selected: filePath === root.services.currentWallpaper

                    width: wallpaperGrid.cellWidth
                    height: wallpaperGrid.cellHeight

                    Rectangle {
                        id: card
                        anchors.fill: parent
                        anchors.margins: 5
                        radius: root.theme.radiusMedium
                        color: tile.selected || tileMouse.containsMouse
                            ? root.theme.accentSoft
                            : root.theme.surface
                        border.width: tile.selected ? 2 : 1
                        border.color: tile.selected ? root.theme.accent : root.theme.outline
                        clip: true

                        Image {
                            id: thumbnail
                            anchors.top: parent.top
                            anchors.left: parent.left
                            anchors.right: parent.right
                            height: parent.height - 29
                            source: tile.modelData.fileUrl
                            fillMode: Image.PreserveAspectCrop
                            asynchronous: true
                            cache: false
                            sourceSize.width: Math.round(card.width * 1.5)
                            sourceSize.height: Math.round(height * 1.5)
                        }

                        Text {
                            anchors.centerIn: thumbnail
                            visible: thumbnail.status !== Image.Ready
                            text: thumbnail.status === Image.Error ? "preview unavailable" : "loading…"
                            color: root.theme.textFaint
                            font.family: root.theme.fontUi
                            font.pixelSize: 9
                        }

                        RowLayout {
                            anchors.left: parent.left
                            anchors.right: parent.right
                            anchors.bottom: parent.bottom
                            anchors.leftMargin: 9
                            anchors.rightMargin: 9
                            height: 29
                            spacing: 6

                            Text {
                                Layout.fillWidth: true
                                text: root.displayName(tile.modelData.fileName)
                                color: tile.selected ? root.theme.accent : root.theme.text
                                font.family: root.theme.fontUi
                                font.pixelSize: 10
                                font.weight: tile.selected ? Font.DemiBold : Font.Normal
                                elide: Text.ElideRight
                            }

                            Text {
                                text: tile.selected ? "●" : ""
                                color: root.theme.accent
                                font.pixelSize: 8
                            }
                        }

                        MouseArea {
                            id: tileMouse
                            anchors.fill: parent
                            hoverEnabled: true
                            enabled: !root.services.wallpaperBusy
                            onClicked: root.services.setWallpaper(tile.filePath)
                        }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: filteredWallpapers.values.length === 0
                    text: wallpaperFiles.count === 0
                        ? "Put images in ~/Pictures/wallpapers"
                        : "No wallpaper matches this search"
                    color: root.theme.textFaint
                    font.family: root.theme.fontUi
                    font.pixelSize: 12
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
