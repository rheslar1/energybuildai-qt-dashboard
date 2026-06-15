#pragma once

#include "../IAlarmRepository.h"

#include <QtCore/QFuture>

namespace Domain {

class FetchAlarmsUseCase
{
public:
    explicit FetchAlarmsUseCase(IAlarmRepository *repo)
        : m_repo(repo)
    {
    }

    QFuture<QVector<Alarm>> execute()
    {
        return m_repo->fetchAlarms();
    }

private:
    IAlarmRepository *m_repo{};
};

} // namespace Domain

