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
    property int labelSize: 12
    property int labelWeight: Font.Medium
    property color activeColor: theme.accent
    property color activeTextColor: theme.background
    property string labelFont: theme.fontMono

    signal clicked
    signal secondaryClicked
    signal wheel(real delta)

    implicitWidth: 38
    implicitHeight: 38

    Rectangle {
        anchors.fill: parent
        radius: root.buttonRadius
        color: {
            if (root.active) return root.activeColor;
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
        color: root.active ? root.activeTextColor : (root.danger ? root.theme.danger : root.theme.text)
        font.family: root.icon ? root.theme.fontIcon : root.labelFont
        font.pixelSize: root.icon ? root.iconSize : root.labelSize
        font.weight: root.active ? Font.DemiBold : root.labelWeight
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
