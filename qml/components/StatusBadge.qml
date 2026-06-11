import QtQuick

Rectangle {
    id: badge

    property string text: ""
    property bool critical: false

    radius: height / 2
    color: critical ? "#fee2e2" : "#dcfce7"
    border.width: 1
    border.color: critical ? "#fecaca" : "#bbf7d0"
    implicitWidth: badgeLabel.implicitWidth + 24
    implicitHeight: 32

    Text {
        id: badgeLabel
        anchors.centerIn: parent
        text: badge.text
        color: badge.critical ? "#dc2626" : "#0f7a36"
        font.pixelSize: 13
        font.bold: true
    }
}
