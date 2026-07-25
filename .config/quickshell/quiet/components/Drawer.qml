import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland
import Quickshell.Services.SystemTray
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
    id: root

    required property var theme
    required property var shellState
    required property var services

    color: "transparent"
    visible: shellState.drawerOpen
    focusable: true
    exclusionMode: ExclusionMode.Ignore
    implicitWidth: 374

    anchors {
        top: true
        bottom: true
        right: true
    }

    margins {
        top: root.theme.railZone + 4
        bottom: 10
        right: 10
    }

    WlrLayershell.namespace: "quiet-drawer"
    WlrLayershell.layer: WlrLayer.Overlay

    onVisibleChanged: if (visible) content.forceActiveFocus()

    Rectangle {
        id: content
        anchors.fill: parent
        radius: root.theme.radiusLarge
        color: root.theme.surfaceRaised
        border.width: 1
        border.color: root.theme.outlineStrong
        focus: true

        Keys.onEscapePressed: root.shellState.closeOverlays()

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 14

            RowLayout {
                Layout.fillWidth: true

                ColumnLayout {
                    spacing: 0

                    SystemClock {
                        id: clock
                        precision: SystemClock.Minutes
                    }

                    Text {
                        text: Qt.formatDateTime(clock.date, "dddd")
                        color: root.theme.text
                        font.family: root.theme.fontUi
                        font.pixelSize: 24
                        font.weight: Font.DemiBold
                    }

                    Text {
                        text: Qt.formatDateTime(clock.date, "d MMMM yyyy")
                        color: root.theme.textMuted
                        font.family: root.theme.fontUi
                        font.pixelSize: 13
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: Qt.formatDateTime(clock.date, "HH:mm")
                    color: root.theme.accent
                    font.family: root.theme.fontMono
                    font.pixelSize: 25
                    font.weight: Font.DemiBold
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 58
                    radius: root.theme.radiusMedium
                    color: wifiMouse.containsMouse ? root.theme.surfaceHover : root.theme.accentSoft
                    border.width: 1
                    border.color: root.services.wifiEnabled ? root.theme.outlineStrong : root.theme.outline

                    Column {
                        anchors.centerIn: parent
                        spacing: 1
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "⌁"; color: root.services.wifiEnabled ? root.theme.accent : root.theme.textMuted; font.pixelSize: 18; font.family: root.theme.fontIcon }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: root.services.networkName; color: root.theme.text; font.pixelSize: 10; font.family: root.theme.fontUi; width: 92; horizontalAlignment: Text.AlignHCenter; elide: Text.ElideRight }
                    }

                    MouseArea {
                        id: wifiMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton | Qt.RightButton
                        onClicked: event => {
                            if (event.button === Qt.RightButton) root.services.toggleWifi();
                            else root.services.openNetworkSettings();
                        }
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 58
                    radius: root.theme.radiusMedium
                    color: bluetoothMouse.containsMouse ? root.theme.surfaceHover : root.theme.accentSoft
                    border.width: 1
                    border.color: root.services.bluetoothEnabled ? root.theme.outlineStrong : root.theme.outline

                    Column {
                        anchors.centerIn: parent
                        spacing: 1
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: root.services.bluetoothEnabled ? "󰂯" : "󰂲"
                            color: root.services.bluetoothEnabled ? root.theme.accent : root.theme.textMuted
                            font.pixelSize: 18
                            font.family: root.theme.fontIcon
                        }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: "Bluetooth"; color: root.theme.text; font.pixelSize: 10; font.family: root.theme.fontUi }
                    }

                    MouseArea {
                        id: bluetoothMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        onClicked: root.services.openBluetoothSettings()
                    }
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 58
                    radius: root.theme.radiusMedium
                    color: nightLightMouse.containsMouse ? root.theme.surfaceHover : root.theme.accentSoft
                    border.width: 1
                    border.color: root.services.nightLightEnabled ? root.theme.outlineStrong : root.theme.outline

                    Column {
                        anchors.centerIn: parent
                        spacing: 1
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "☾"
                            color: root.services.nightLightEnabled ? root.theme.accent : root.theme.textMuted
                            font.pixelSize: 18
                            font.family: root.theme.fontUi
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: root.services.nightLightEnabled
                                ? root.services.nightLightTemperature + " K"
                                : "Night light"
                            color: root.theme.text
                            font.pixelSize: 10
                            font.family: root.theme.fontUi
                        }
                    }

                    MouseArea {
                        id: nightLightMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        enabled: root.services.nightLightAvailable
                        onClicked: root.services.toggleNightLight()
                    }
                }

                Rectangle {
                    Layout.preferredWidth: 70
                    Layout.preferredHeight: 58
                    radius: root.theme.radiusMedium
                    color: root.services.hasBattery ? root.theme.accentSoft : root.theme.surface
                    border.width: 1
                    border.color: root.theme.outline

                    Column {
                        anchors.centerIn: parent
                        spacing: 1
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: root.services.hasBattery ? Math.round(root.services.batteryLevel * 100) + "%" : "AC"; color: root.theme.accent; font.pixelSize: 14; font.family: root.theme.fontMono; font.weight: Font.DemiBold }
                        Text { anchors.horizontalCenter: parent.horizontalCenter; text: root.services.hasBattery ? "battery" : "power"; color: root.theme.textMuted; font.pixelSize: 9; font.family: root.theme.fontUi }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: root.services.player ? 104 : 0
                visible: root.services.player !== null
                radius: root.theme.radiusMedium
                color: root.theme.accentSoft
                border.width: 1
                border.color: root.theme.outline

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 12

                    Rectangle {
                        Layout.preferredWidth: 72
                        Layout.preferredHeight: 72
                        radius: root.theme.radiusSmall
                        color: root.theme.surfaceHover
                        clip: true

                        Image {
                            anchors.fill: parent
                            source: root.services.player ? root.services.player.trackArtUrl : ""
                            fillMode: Image.PreserveAspectCrop
                            visible: status === Image.Ready
                        }

                        Text {
                            anchors.centerIn: parent
                            text: "♪"
                            visible: parent.children[0].status !== Image.Ready
                            color: root.theme.accent
                            font.pixelSize: 24
                        }
                    }

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 3

                        Text { Layout.fillWidth: true; text: root.services.player ? (root.services.player.trackTitle || root.services.player.identity) : ""; color: root.theme.text; font.family: root.theme.fontUi; font.pixelSize: 14; font.weight: Font.DemiBold; elide: Text.ElideRight }
                        Text { Layout.fillWidth: true; text: root.services.player ? (root.services.player.trackArtist || "Now playing") : ""; color: root.theme.textMuted; font.family: root.theme.fontUi; font.pixelSize: 11; elide: Text.ElideRight }

                        RowLayout {
                            spacing: 12
                            Text { text: "‹"; color: root.theme.text; font.pixelSize: 22; MouseArea { anchors.fill: parent; onClicked: if (root.services.player && root.services.player.canGoPrevious) root.services.player.previous() } }
                            Text { text: root.services.player && root.services.player.isPlaying ? "Ⅱ" : "▶"; color: root.theme.accent; font.pixelSize: 17; MouseArea { anchors.fill: parent; onClicked: if (root.services.player && root.services.player.canTogglePlaying) root.services.player.togglePlaying() } }
                            Text { text: "›"; color: root.theme.text; font.pixelSize: 22; MouseArea { anchors.fill: parent; onClicked: if (root.services.player && root.services.player.canGoNext) root.services.player.next() } }
                        }
                    }
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 8

                RowLayout {
                    Layout.fillWidth: true
                    Text { text: root.services.muted ? "×" : "♪"; color: root.theme.accent; font.family: root.theme.fontIcon; font.pixelSize: 17 }
                    Text { text: root.services.muted ? "Muted" : "Volume"; color: root.theme.text; font.family: root.theme.fontUi; font.pixelSize: 12 }
                    Item { Layout.fillWidth: true }
                    Text { text: Math.round(root.services.volume * 100) + "%"; color: root.theme.textMuted; font.family: root.theme.fontMono; font.pixelSize: 11 }
                }

                Slider {
                    Layout.fillWidth: true
                    from: 0
                    to: 1
                    value: root.services.volume
                    onMoved: root.services.setVolume(value)

                    background: Rectangle {
                        x: parent.leftPadding
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: parent.availableWidth
                        height: 5
                        radius: 3
                        color: root.theme.surfaceHover
                        Rectangle { width: parent.width * root.services.volume; height: parent.height; radius: parent.radius; color: root.theme.accent }
                    }
                    handle: Rectangle {
                        x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: 15
                        height: 15
                        radius: 8
                        color: root.theme.text
                        border.width: 3
                        border.color: root.theme.accent
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Text { text: "◐"; color: root.theme.accent; font.family: root.theme.fontIcon; font.pixelSize: 17 }
                    Text { text: "Brightness"; color: root.theme.text; font.family: root.theme.fontUi; font.pixelSize: 12 }
                    Item { Layout.fillWidth: true }
                    Text { text: Math.round(root.services.brightness * 100) + "%"; color: root.theme.textMuted; font.family: root.theme.fontMono; font.pixelSize: 11 }
                }

                Slider {
                    Layout.fillWidth: true
                    from: 0.05
                    to: 1
                    value: root.services.brightness
                    onMoved: root.services.setBrightness(value)

                    background: Rectangle {
                        x: parent.leftPadding
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: parent.availableWidth
                        height: 5
                        radius: 3
                        color: root.theme.surfaceHover
                        Rectangle { width: parent.width * root.services.brightness; height: parent.height; radius: parent.radius; color: root.theme.accent }
                    }
                    handle: Rectangle {
                        x: parent.leftPadding + parent.visualPosition * (parent.availableWidth - width)
                        y: parent.topPadding + parent.availableHeight / 2 - height / 2
                        width: 15
                        height: 15
                        radius: 8
                        color: root.theme.text
                        border.width: 3
                        border.color: root.theme.accent
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Text { text: "NOTIFICATIONS"; color: root.theme.textFaint; font.family: root.theme.fontMono; font.pixelSize: 10; font.letterSpacing: 1.2 }
                Item { Layout.fillWidth: true }
                Text {
                    text: root.services.notificationServer.trackedNotifications.values.length ? "clear" : "quiet"
                    color: root.theme.textMuted
                    font.family: root.theme.fontMono
                    font.pixelSize: 10
                    MouseArea {
                        anchors.fill: parent
                        enabled: root.services.notificationServer.trackedNotifications.values.length > 0
                        onClicked: {
                            const items = [...root.services.notificationServer.trackedNotifications.values];
                            items.forEach(notification => notification.dismiss());
                        }
                    }
                }
            }

            ListView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                model: root.services.notificationServer.trackedNotifications
                clip: true
                spacing: 7

                delegate: Rectangle {
                    id: notificationItem
                    required property var modelData
                    width: ListView.view.width
                    height: 68
                    radius: root.theme.radiusMedium
                    color: root.theme.surface
                    border.width: 1
                    border.color: root.theme.outline

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10
                        spacing: 10

                        IconImage {
                            source: Quickshell.iconPath(notificationItem.modelData.appIcon, "dialog-information")
                            implicitWidth: 30
                            implicitHeight: 30
                        }

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 1
                            Text { Layout.fillWidth: true; text: notificationItem.modelData.summary || notificationItem.modelData.appName; color: root.theme.text; font.family: root.theme.fontUi; font.pixelSize: 12; font.weight: Font.DemiBold; elide: Text.ElideRight }
                            Text { Layout.fillWidth: true; text: notificationItem.modelData.body || notificationItem.modelData.appName; color: root.theme.textMuted; font.family: root.theme.fontUi; font.pixelSize: 10; elide: Text.ElideRight; textFormat: Text.PlainText }
                        }

                        Text { text: "×"; color: root.theme.textMuted; font.pixelSize: 16; MouseArea { anchors.fill: parent; onClicked: notificationItem.modelData.dismiss() } }
                    }
                }

                Text {
                    anchors.centerIn: parent
                    visible: parent.count === 0
                    text: "Nothing needs your attention"
                    color: root.theme.textFaint
                    font.family: root.theme.fontUi
                    font.pixelSize: 12
                }
            }

            RowLayout {
                Layout.fillWidth: true
                spacing: 8

                Repeater {
                    model: SystemTray.items

                    Item {
                        id: trayItem
                        required property var modelData
                        implicitWidth: 28
                        implicitHeight: 28

                        IconImage {
                            anchors.centerIn: parent
                            source: trayItem.modelData.icon
                            implicitWidth: 20
                            implicitHeight: 20
                        }

                        MouseArea {
                            anchors.fill: parent
                            acceptedButtons: Qt.LeftButton | Qt.RightButton
                            onClicked: event => {
                                if (event.button === Qt.RightButton && trayItem.modelData.hasMenu)
                                    trayItem.modelData.display(root, trayItem.x, trayItem.y);
                                else
                                    trayItem.modelData.activate();
                            }
                        }
                    }
                }

                Item { Layout.fillWidth: true }

                Text {
                    text: "session  ›"
                    color: root.theme.accent
                    font.family: root.theme.fontMono
                    font.pixelSize: 11
                    MouseArea { anchors.fill: parent; onClicked: root.shellState.toggleSession() }
                }
            }
        }
    }
}
