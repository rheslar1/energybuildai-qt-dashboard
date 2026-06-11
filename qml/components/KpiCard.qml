import QtQuick

Rectangle {
    id: card

    property string label: ""
    property string value: ""
    property string helper: ""
    property bool critical: false
    property bool clickable: false

    signal clicked()

    radius: 6
    color: mouseArea.containsMouse && clickable
           ? (critical ? "#fee2e2" : "#dcfce7")
           : "#f8fafc"
    border.width: 1
    border.color: critical ? "#dc2626" : "#d7dfdc"
    implicitHeight: 112

    Rectangle {
        id: topBand
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 4
        radius: 2
        color: critical ? "#dc2626" : "#32d45f"
    }

    Column {
        anchors.fill: parent
        anchors.margins: 14
        spacing: 7

        Text {
            text: card.label.toUpperCase()
            color: "#5b6573"
            font.pixelSize: 13
            font.bold: true
            elide: Text.ElideRight
        }

        Text {
            text: card.value
            color: critical ? "#dc2626" : "#101827"
            font.pixelSize: 30
            font.bold: true
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            text: card.helper
            color: "#5b6573"
            font.pixelSize: 14
            font.bold: true
            wrapMode: Text.WordWrap
            maximumLineCount: 2
            elide: Text.ElideRight
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        enabled: card.clickable
        hoverEnabled: true
        cursorShape: card.clickable ? Qt.PointingHandCursor : Qt.ArrowCursor
        onClicked: card.clicked()
    }
}
