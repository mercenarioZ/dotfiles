import QtQuick
import Quickshell
import Quickshell.Widgets

ClippingRectangle {
    id: root

    required property var notification
    property real implicitSize: 34
    readonly property string attachedImage: {
        const image = String(notification.image || "");
        return image.startsWith("image://icon/") ? "" : image;
    }
    readonly property string fallbackIcon: {
        let appIcon = String(notification.appIcon || "");
        const image = String(notification.image || "");
        if (!appIcon && image.startsWith("image://icon/")) {
            appIcon = decodeURIComponent(image.slice("image://icon/".length).split("?")[0]);
        }
        if (appIcon === "utilities-terminal") return "com.mitchellh.ghostty";
        return appIcon || String(notification.desktopEntry || "");
    }

    implicitWidth: implicitSize
    implicitHeight: implicitSize
    radius: 6
    color: "transparent"

    Image {
        id: notificationImage
        anchors.fill: parent
        source: root.attachedImage
        fillMode: Image.PreserveAspectCrop
        asynchronous: true
        cache: false
        visible: status === Image.Ready
    }

    IconImage {
        anchors.fill: parent
        source: Quickshell.iconPath(root.fallbackIcon, "dialog-information")
        visible: notificationImage.status !== Image.Ready
    }
}
