#include "InMemoryAlarmRepository.h"

#include <QtCore/QPromise>
#include <QtCore/QThread>

using namespace Domain;

InMemoryAlarmRepository::InMemoryAlarmRepository()
{
    // Initialize using the same data that previously lived in QML.
    m_alarms = {
        Alarm{.alarmId = "ALM-1042",
              .zone = "Tower B Floor 1",
              .building = "EnergyBuildAI Tower",
              .room = "Server Room / Open Office Return",
              .equipment = "VAV-TB1-14",
              .alarmType = "Demand peak",
              .priority = "High",
              .status = "Active",
              .owner = "Facilities team",
              .sla = "4 min dispatch",
              .reading = "24.1 kWh interval",
              .trend = "Rising 11% over last interval"},
        Alarm{.alarmId = "ALM-1038",
              .zone = "Floor 1 AHU",
              .building = "EnergyBuildAI Tower",
              .room = "Mechanical / AHU Closet",
              .equipment = "AHU-01",
              .alarmType = "Static pressure drift",
              .priority = "Medium",
              .status = "Acknowledged",
              .owner = "Controls technician",
              .sla = "12 min review",
              .reading = "1.9 in. w.c.",
              .trend = "Stable after acknowledgement"},
        Alarm{.alarmId = "ALM-1029",
              .zone = "Lobby Lighting",
              .building = "EnergyBuildAI Tower",
              .room = "Lobby",
              .equipment = "Lighting Bus LB-01",
              .alarmType = "Schedule override",
              .priority = "Low",
              .status = "Auto-clear",
              .owner = "Facilities operator",
              .sla = "Monitor only",
              .reading = "Manual override active",
              .trend = "Clearing on next schedule pulse"},
    };
}

QFuture<QVector<Alarm>> InMemoryAlarmRepository::fetchAlarms()
{
    QPromise<QVector<Alarm>> p;
    auto f = p.future();

    // For now simulate async latency.
    QtConcurrent::run([this, p = std::move(p)]() mutable {
        QThread::msleep(150);
        QMutexLocker locker(&m_mutex);
        p.addResult(m_alarms);
        p.finish();
    });

    return f;
}

QFuture<void> InMemoryAlarmRepository::acknowledgeAlarm(const QString &alarmId)
{
    QPromise<void> p;
    auto f = p.future();

    QtConcurrent::run([this, alarmId, p = std::move(p)]() mutable {
        QThread::msleep(120);
        {
            QMutexLocker locker(&m_mutex);
            for (auto &a : m_alarms) {
                if (a.alarmId == alarmId && a.status == "Active") {
                    a.status = "Acknowledged";
                }
            }
        }
        p.finish();
    });

    return f;
}

