import QtQuick

QtObject {
    readonly property color background: "#090a0c"
    readonly property color railBackground: "#a6031219"
    readonly property color surface: "#ee121315"
    readonly property color surfaceRaised: "#f5161719"
    readonly property color surfaceHover: "#ff25221f"
    readonly property color outline: "#493c3128"
    readonly property color outlineStrong: "#80684c2f"
    readonly property color accent: "#f5b257"
    readonly property color accentSoft: "#40322119"
    readonly property color text: "#f5f0e6"
    readonly property color textMuted: "#a69f95"
    readonly property color textFaint: "#6f6a63"
    readonly property color danger: "#e67e80"
    readonly property color success: "#a9c181"

    readonly property string fontUi: "Cantarell"
    readonly property string fontMono: "JetBrains Mono"
    readonly property string fontIcon: "JetBrainsMono Nerd Font"

    readonly property int railWidth: 42
    readonly property int railMargin: 2
    readonly property int railZone: 44
    readonly property int radiusSmall: 8
    readonly property int radiusMedium: 14
    readonly property int radiusLarge: 22
    readonly property int motionFast: 150
    readonly property int motionNormal: 210
}
