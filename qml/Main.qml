import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import "components"

ApplicationWindow {
    id: root

    width: 1280
    height: 800
    visible: true
    title: "EnergyBuildAI Dashboard"
    color: "#e9efec"

    property int selectedAlarmIndex: 0
    property string pageMode: "overview"
    property int activeAlarmCount: 1
    property int acknowledgedAlarmCount: 1
    property int autoClearAlarmCount: 1

    function selectedAlarm() {
        return alarmModel.get(selectedAlarmIndex)
    }

    function recalcAlarmCounts() {
        var active = 0
        var acknowledged = 0
        var autoClear = 0

        for (var index = 0; index < alarmModel.count; index += 1) {
            var event = alarmModel.get(index)
            if (event.status === "Active") {
                active += 1
            } else if (event.status === "Acknowledged") {
                acknowledged += 1
            } else if (event.status === "Auto-clear") {
                autoClear += 1
            }
        }

        activeAlarmCount = active
        acknowledgedAlarmCount = acknowledged
        autoClearAlarmCount = autoClear
    }

    function selectAlarm(index) {
        selectedAlarmIndex = index
        pageMode = "alarms"

        if (alarmModel.get(index).status === "Active") {
            alarmModel.setProperty(index, "status", "Acknowledged")
            recalcAlarmCounts()
        }
    }

    function openAcknowledgePage() {
        pageMode = "acknowledge"
        for (var index = 0; index < alarmModel.count; index += 1) {
            if (alarmModel.get(index).status === "Active") {
                selectedAlarmIndex = index
                return
            }
        }
    }

    function acknowledgeSelectedAlarm() {
        if (selectedAlarm().status === "Active") {
            alarmModel.setProperty(selectedAlarmIndex, "status", "Acknowledged")
            recalcAlarmCounts()
        }
    }

    Component.onCompleted: recalcAlarmCounts()

    ListModel {
        id: alarmModel

        ListElement {
            alarmId: "ALM-1042"
            zone: "Tower B Floor 1"
            building: "EnergyBuildAI Tower"
            room: "Server Room / Open Office Return"
            equipment: "VAV-TB1-14"
            alarmType: "Demand peak"
            priority: "High"
            status: "Active"
            owner: "Facilities team"
            sla: "4 min dispatch"
            reading: "24.1 kWh interval"
            trend: "Rising 11% over last interval"
        }

        ListElement {
            alarmId: "ALM-1038"
            zone: "Floor 1 AHU"
            building: "EnergyBuildAI Tower"
            room: "Mechanical / AHU Closet"
            equipment: "AHU-01"
            alarmType: "Static pressure drift"
            priority: "Medium"
            status: "Acknowledged"
            owner: "Controls technician"
            sla: "12 min review"
            reading: "1.9 in. w.c."
            trend: "Stable after acknowledgement"
        }

        ListElement {
            alarmId: "ALM-1029"
            zone: "Lobby Lighting"
            building: "EnergyBuildAI Tower"
            room: "Lobby"
            equipment: "Lighting Bus LB-01"
            alarmType: "Schedule override"
            priority: "Low"
            status: "Auto-clear"
            owner: "Facilities operator"
            sla: "Monitor only"
            reading: "Manual override active"
            trend: "Clearing on next schedule pulse"
        }
    }

    Rectangle {
        id: header
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        height: 60
        color: "#386fa8"

        RowLayout {
            anchors.fill: parent
            anchors.leftMargin: 28
            anchors.rightMargin: 28
            spacing: 28

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 2

                Text {
                    text: "ROBERT HESLAR"
                    color: "white"
                    font.pixelSize: 20
                    font.bold: true
                }

                Text {
                    text: "EMBEDDED SYSTEMS AND SOFTWARE PORTFOLIO"
                    color: "#eaf2fb"
                    font.pixelSize: 11
                    font.bold: true
                    letterSpacing: 0
                }
            }

            Button {
                text: "Dashboard"
                onClicked: root.pageMode = "overview"
            }

            Button {
                text: "Alarms"
                onClicked: root.pageMode = "alarms"
            }
        }
    }

    RowLayout {
        anchors.top: header.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        spacing: 0

        Rectangle {
            Layout.preferredWidth: 236
            Layout.fillHeight: true
            color: "#101827"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 18
                spacing: 14

                Rectangle {
                    radius: 5
                    color: "#32d45f"
                    implicitWidth: 46
                    implicitHeight: 31

                    Text {
                        anchors.centerIn: parent
                        text: "BMS"
                        color: "#06130a"
                        font.pixelSize: 12
                        font.bold: true
                    }
                }

                Text {
                    text: "Operations"
                    color: "white"
                    font.pixelSize: 20
                    font.bold: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 1
                    color: "#2e3b4f"
                }

                Repeater {
                    model: [
                        { label: "Overview", mode: "overview" },
                        { label: "Alarms", mode: "alarms" },
                        { label: "Acknowledge", mode: "acknowledge" },
                        { label: "Building", mode: "overview" },
                        { label: "Schedules", mode: "overview" },
                        { label: "Energy", mode: "overview" }
                    ]

                    delegate: Button {
                        Layout.fillWidth: true
                        text: modelData.label
                        flat: true
                        highlighted: root.pageMode === modelData.mode
                        onClicked: root.pageMode = modelData.mode
                    }
                }

                Item {
                    Layout.fillHeight: true
                }
            }
        }

        Flickable {
            id: scroll
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            contentWidth: width
            contentHeight: workspace.implicitHeight + 32

            Rectangle {
                anchors.fill: parent
                color: "#e9efec"
            }

            ColumnLayout {
                id: workspace
                width: scroll.width - 36
                x: 18
                y: 18
                spacing: 12

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 12

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 4

                        Text {
                            text: "ENERGYBUILDAI"
                            color: "#386fa8"
                            font.pixelSize: 14
                            font.bold: true
                        }

                        Text {
                            text: pageMode === "acknowledge" ? "Alarm Acknowledge Page"
                                  : pageMode === "alarms" ? "Alarm Center"
                                  : "Building Operation Center"
                            color: "#101827"
                            font.pixelSize: 40
                            font.bold: true
                            wrapMode: Text.WordWrap
                        }
                    }

                    StatusBadge {
                        text: "Live"
                    }

                    Button {
                        text: "Alarm Details"
                        onClicked: root.pageMode = "alarms"
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 4
                    columnSpacing: 10
                    rowSpacing: 10

                    KpiCard {
                        Layout.fillWidth: true
                        label: "Live building load"
                        value: "68.0 kWh"
                        helper: "Sampled across 5 zones"
                    }

                    KpiCard {
                        Layout.fillWidth: true
                        label: "Peak demand"
                        value: "24.1 kWh"
                        helper: "Tower B Floor 1"
                    }

                    KpiCard {
                        Layout.fillWidth: true
                        label: "Active alarms"
                        value: String(root.activeAlarmCount)
                        helper: root.activeAlarmCount === 0 ? "No active alarms" : "1 high priority dispatch"
                        critical: true
                        clickable: true
                        onClicked: root.openAcknowledgePage()
                    }

                    KpiCard {
                        Layout.fillWidth: true
                        label: "Acknowledged"
                        value: String(root.acknowledgedAlarmCount)
                        helper: "Operator-reviewed events"
                        critical: pageMode !== "overview"
                    }
                }

                Loader {
                    Layout.fillWidth: true
                    sourceComponent: pageMode === "acknowledge" ? acknowledgePage
                                     : pageMode === "alarms" ? alarmDetailsPage
                                     : overviewPage
                }
            }
        }
    }

    Component {
        id: overviewPage

        GridLayout {
            columns: 2
            columnSpacing: 12
            rowSpacing: 12

            Rectangle {
                Layout.fillWidth: true
                Layout.columnSpan: 2
                implicitHeight: 240
                radius: 6
                color: "#f8fafc"
                border.color: "#d7dfdc"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    Text {
                        text: "Building Energy Status"
                        color: "#101827"
                        font.pixelSize: 24
                        font.bold: true
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        spacing: 10

                        Repeater {
                            model: [
                                { zone: "Lobby", load: "8.4 kWh", risk: "Low", color: "#dcfce7" },
                                { zone: "Floor 1", load: "18.7 kWh", risk: "Elevated", color: "#fef3c7" },
                                { zone: "Floor 2", load: "11.2 kWh", risk: "Normal", color: "#dcfce7" },
                                { zone: "Tower B", load: "24.1 kWh", risk: "High", color: "#fee2e2" }
                            ]

                            delegate: Rectangle {
                                Layout.fillWidth: true
                                Layout.fillHeight: true
                                radius: 6
                                color: modelData.color
                                border.color: "#cbd5e1"

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 8

                                    Text {
                                        text: modelData.zone
                                        color: "#101827"
                                        font.pixelSize: 18
                                        font.bold: true
                                    }

                                    Text {
                                        text: modelData.load
                                        color: "#101827"
                                        font.pixelSize: 24
                                        font.bold: true
                                    }

                                    Text {
                                        text: modelData.risk + " risk"
                                        color: "#5b6573"
                                        font.pixelSize: 14
                                        font.bold: true
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Component {
        id: alarmDetailsPage

        GridLayout {
            columns: 2
            columnSpacing: 12
            rowSpacing: 12

            Rectangle {
                Layout.fillWidth: true
                Layout.columnSpan: 2
                implicitHeight: 230
                radius: 6
                color: "#f8fafc"
                border.color: selectedAlarm().status === "Active" ? "#dc2626" : "#d7dfdc"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 12

                    RowLayout {
                        Layout.fillWidth: true

                        ColumnLayout {
                            Layout.fillWidth: true

                            Text {
                                text: "SELECTED ALARM"
                                color: "#5b6573"
                                font.pixelSize: 13
                                font.bold: true
                            }

                            Text {
                                text: selectedAlarm().alarmType
                                color: "#101827"
                                font.pixelSize: 26
                                font.bold: true
                            }
                        }

                        StatusBadge {
                            text: selectedAlarm().status
                            critical: selectedAlarm().status === "Active"
                        }

                        Button {
                            text: "Acknowledge Page"
                            onClicked: root.pageMode = "acknowledge"
                        }
                    }

                    GridLayout {
                        Layout.fillWidth: true
                        columns: 4
                        columnSpacing: 10

                        Repeater {
                            model: [
                                { label: "Current Reading", value: selectedAlarm().reading, helper: "Target 18.0 kWh" },
                                { label: "Trend", value: selectedAlarm().trend, helper: selectedAlarm().sla },
                                { label: "Equipment", value: selectedAlarm().equipment, helper: selectedAlarm().room },
                                { label: "Owner", value: selectedAlarm().owner, helper: selectedAlarm().building }
                            ]

                            delegate: Rectangle {
                                Layout.fillWidth: true
                                implicitHeight: 92
                                radius: 6
                                color: "#eef5f2"
                                border.color: "#d7dfdc"

                                Column {
                                    anchors.fill: parent
                                    anchors.margins: 12
                                    spacing: 5

                                    Text {
                                        text: modelData.label.toUpperCase()
                                        color: "#5b6573"
                                        font.pixelSize: 12
                                        font.bold: true
                                    }

                                    Text {
                                        text: modelData.value
                                        color: "#101827"
                                        font.pixelSize: 17
                                        font.bold: true
                                        elide: Text.ElideRight
                                    }

                                    Text {
                                        text: modelData.helper
                                        color: "#5b6573"
                                        font.pixelSize: 13
                                        font.bold: true
                                        elide: Text.ElideRight
                                    }
                                }
                            }
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 320
                radius: 6
                color: "#f8fafc"
                border.color: "#d7dfdc"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10

                    Text {
                        text: "Alarm Queue"
                        color: "#5b6573"
                        font.pixelSize: 13
                        font.bold: true
                    }

                    Text {
                        text: "Events And Acknowledgement"
                        color: "#101827"
                        font.pixelSize: 24
                        font.bold: true
                    }

                    Repeater {
                        model: alarmModel

                        delegate: AlarmTicket {
                            Layout.fillWidth: true
                            alarmId: model.alarmId
                            zone: model.zone
                            alarmType: model.alarmType
                            status: model.status
                            priority: model.priority
                            selected: index === root.selectedAlarmIndex
                            onClicked: root.selectAlarm(index)
                        }
                    }
                }
            }

            Rectangle {
                Layout.fillWidth: true
                implicitHeight: 320
                radius: 6
                color: "#f8fafc"
                border.color: "#d7dfdc"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10

                    Text {
                        text: "Alarm Location Details"
                        color: "#101827"
                        font.pixelSize: 24
                        font.bold: true
                    }

                    Text {
                        text: "Building: " + selectedAlarm().building
                        color: "#101827"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    Text {
                        text: "Zone: " + selectedAlarm().zone
                        color: "#101827"
                        font.pixelSize: 18
                        font.bold: true
                    }

                    Text {
                        text: "Room: " + selectedAlarm().room
                        color: "#101827"
                        font.pixelSize: 18
                        font.bold: true
                    }
                }
            }
        }
    }

    Component {
        id: acknowledgePage

        Rectangle {
            Layout.fillWidth: true
            implicitHeight: 320
            radius: 6
            color: "#f8fafc"
            border.width: 2
            border.color: selectedAlarm().status === "Active" ? "#dc2626" : "#32d45f"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 16
                spacing: 14

                RowLayout {
                    Layout.fillWidth: true

                    ColumnLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "ALARM ACKNOWLEDGE PAGE"
                            color: "#5b6573"
                            font.pixelSize: 13
                            font.bold: true
                        }

                        Text {
                            text: "Acknowledge Selected Alarm"
                            color: "#101827"
                            font.pixelSize: 26
                            font.bold: true
                        }

                        Text {
                            text: "Operator acknowledgement records ownership for " + selectedAlarm().alarmId + " before follow-up work continues."
                            color: "#5b6573"
                            font.pixelSize: 16
                            wrapMode: Text.WordWrap
                        }
                    }

                    StatusBadge {
                        text: selectedAlarm().status === "Active" ? "Pending" : "Acknowledged"
                        critical: selectedAlarm().status === "Active"
                    }
                }

                GridLayout {
                    Layout.fillWidth: true
                    columns: 3
                    columnSpacing: 10

                    Repeater {
                        model: [
                            { label: "Alarm", value: selectedAlarm().alarmId, helper: selectedAlarm().alarmType + " | " + selectedAlarm().priority + " priority" },
                            { label: "Owner", value: selectedAlarm().owner, helper: selectedAlarm().sla },
                            { label: "Location", value: selectedAlarm().zone, helper: selectedAlarm().room }
                        ]

                        delegate: Rectangle {
                            Layout.fillWidth: true
                            implicitHeight: 98
                            radius: 6
                            color: "#eef5f2"
                            border.color: "#d7dfdc"

                            Column {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 5

                                Text {
                                    text: modelData.label.toUpperCase()
                                    color: "#5b6573"
                                    font.pixelSize: 12
                                    font.bold: true
                                }

                                Text {
                                    text: modelData.value
                                    color: "#101827"
                                    font.pixelSize: 18
                                    font.bold: true
                                }

                                Text {
                                    text: modelData.helper
                                    color: "#5b6573"
                                    font.pixelSize: 13
                                    font.bold: true
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }

                RowLayout {
                    spacing: 12

                    Button {
                        text: selectedAlarm().status === "Active" ? "Acknowledge Alarm" : "Acknowledgement Recorded"
                        enabled: selectedAlarm().status === "Active"
                        onClicked: root.acknowledgeSelectedAlarm()
                    }

                    Button {
                        text: "Alarm Details"
                        onClicked: root.pageMode = "alarms"
                    }
                }

                Text {
                    text: selectedAlarm().status === "Active"
                          ? "Acknowledge before applying follow-up actions or closing the alarm."
                          : "Acknowledgement recorded in this console session and removed from Active alarms."
                    color: "#5b6573"
                    font.pixelSize: 16
                    font.bold: true
                }
            }
        }
    }
}
