#pragma once

#include "../IAlarmRepository.h"

#include <QtCore/QFuture>
#include <QtCore/QString>

namespace Domain {

class AcknowledgeAlarmUseCase
{
public:
    explicit AcknowledgeAlarmUseCase(IAlarmRepository *repo)
        : m_repo(repo)
    {
    }

    QFuture<void> execute(const QString &alarmId)
    {
        return m_repo->acknowledgeAlarm(alarmId);
    }

private:
    IAlarmRepository *m_repo{};
};

} // namespace Domain

