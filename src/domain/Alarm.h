#pragma once

#include <QtCore/QString>

namespace Domain {

struct Alarm
{
    QString alarmId;
    QString zone;
    QString building;
    QString room;
    QString equipment;
    QString alarmType;
    QString priority;

    // Examples used by existing QML:
    //  - "Active"
    //  - "Acknowledged"
    //  - "Auto-clear"
    QString status;

    QString owner;
    QString sla;
    QString reading;
    QString trend;
};

} // namespace Domain

