#include "AppFacade.h"

#include "../domain/InMemoryAlarmRepository.h"
#include "../domain/usecases/AcknowledgeAlarmUseCase.h"
#include "../domain/usecases/FetchAlarmsUseCase.h"

using namespace App;

AppFacade::AppFacade(QObject *parent)
    : QObject(parent)
{
    m_repo = new Domain::InMemoryAlarmRepository();
    m_fetchUseCase = new Domain::FetchAlarmsUseCase(m_repo);
    m_ackUseCase = new Domain::AcknowledgeAlarmUseCase(m_repo);
}

QFuture<QVector<Domain::Alarm>> AppFacade::getAlarms()
{
    return m_fetchUseCase->execute();
}

QFuture<void> AppFacade::acknowledgeAlarm(const QString &alarmId)
{
    return m_ackUseCase->execute(alarmId);
}

