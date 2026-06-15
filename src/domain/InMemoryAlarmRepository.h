#pragma once

#include "IAlarmRepository.h"

#include <QtCore/QMutex>
#include <QtCore/QFuture>
#include <QtCore/QPromise>
#include <QtCore/QVector>

namespace Domain {

class InMemoryAlarmRepository final : public IAlarmRepository
{
public:
    InMemoryAlarmRepository();

    QFuture<QVector<Alarm>> fetchAlarms() override;
    QFuture<void> acknowledgeAlarm(const QString &alarmId) override;

private:
    QMutex m_mutex;
    QVector<Alarm> m_alarms;
};

} // namespace Domain

