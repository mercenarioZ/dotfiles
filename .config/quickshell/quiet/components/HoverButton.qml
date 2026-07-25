import QtQuick

Item {
    id: root

    required property var theme
    property string label: ""
    property string icon: ""
    property bool active: false
    property bool danger: false
    property int buttonRadius: theme.radiusSmall
    property int iconSize: 16

    signal clicked
    signal secondaryClicked
    signal wheel(real delta)

    implicitWidth: 38
    implicitHeight: 38

    Rectangle {
        anchors.fill: parent
        radius: root.buttonRadius
        color: {
            if (root.active) return root.theme.accent;
            if (mouse.containsMouse) return root.danger ? "#362022" : root.theme.surfaceHover;
            return "transparent";
        }
        border.width: root.active ? 0 : 1
        border.color: mouse.containsMouse ? root.theme.outlineStrong : "transparent"

        Behavior on color { ColorAnimation { duration: root.theme.motionFast } }
    }

    Text {
        anchors.centerIn: parent
        text: root.icon || root.label
        color: root.active ? root.theme.background : (root.danger ? root.theme.danger : root.theme.text)
        font.family: root.icon ? root.theme.fontIcon : root.theme.fontMono
        font.pixelSize: root.icon ? root.iconSize : 12
        font.weight: root.active ? Font.DemiBold : Font.Medium
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        onClicked: event => {
            if (event.button === Qt.RightButton) root.secondaryClicked();
            else root.clicked();
        }
        onWheel: event => root.wheel(event.angleDelta.y)
    }
}
