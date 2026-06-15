#pragma once

#include "../domain/Alarm.h"

#include <QtCore/QFuture>
#include <QtCore/QVector>
#include <QtCore/QObject>
#include <QtCore/QString>

namespace App {

class AppFacade : public QObject
{
    Q_OBJECT
public:
    explicit AppFacade(QObject *parent = nullptr);

    QFuture<QVector<Domain::Alarm>> getAlarms();
    QFuture<void> acknowledgeAlarm(const QString &alarmId);

private:
    // Domain objects owned by the facade.
    Domain::InMemoryAlarmRepository *m_repo{};
    Domain::FetchAlarmsUseCase *m_fetchUseCase{};
    Domain::AcknowledgeAlarmUseCase *m_ackUseCase{};
};

} // namespace App

