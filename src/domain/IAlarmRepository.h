#pragma once

#include "Alarm.h"

#include <QtCore/QFuture>
#include <QtCore/QVector>
#include <QtCore/QString>

namespace Domain {

class IAlarmRepository
{
public:
    virtual ~IAlarmRepository() = default;

    virtual QFuture<QVector<Alarm>> fetchAlarms() = 0;
    virtual QFuture<void> acknowledgeAlarm(const QString &alarmId) = 0;
};

} // namespace Domain

