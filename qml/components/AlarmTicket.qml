import QtQuick

Rectangle {
    id: ticket

    property string alarmId: ""
    property string zone: ""
    property string alarmType: ""
    property string status: ""
    property string priority: ""
    property bool selected: false

    signal clicked()

    readonly property bool activeAlarm: status === "Active"
    readonly property color statusColor: activeAlarm ? "#dc2626" : "#101827"
    readonly property color accentColor: activeAlarm ? "#dc2626" : (priority === "Medium" ? "#d97706" : "#32d45f")

    radius: 6
    color: selected ? (activeAlarm ? "#fee2e2" : "#eaf2ef") : "#f8fafc"
    border.width: 1
    border.color: selected || mouseArea.containsMouse ? accentColor : "#d7dfdc"
    implicitHeight: 92

    Rectangle {
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: 5
        color: accentColor
        radius: 3
    }

    Column {
        anchors.fill: parent
        anchors.leftMargin: 16
        anchors.rightMargin: 12
        anchors.topMargin: 12
        anchors.bottomMargin: 10
        spacing: 4

        Text {
            text: ticket.alarmId
            color: ticket.activeAlarm ? "#dc2626" : "#5b6573"
            font.pixelSize: 13
            font.bold: true
            elide: Text.ElideRight
        }

        Text {
            text: ticket.zone
            color: ticket.statusColor
            font.pixelSize: 17
            font.bold: true
            elide: Text.ElideRight
        }

        Text {
            width: parent.width
            text: ticket.alarmType + " | " + ticket.status
            color: ticket.activeAlarm ? "#dc2626" : "#5b6573"
            font.pixelSize: 14
            font.bold: true
            elide: Text.ElideRight
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: ticket.clicked()
    }
}
