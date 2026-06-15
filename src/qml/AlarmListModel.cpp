#include "AlarmListModel.h"

#include <QtCore/QVariant>

AlarmListModel::AlarmListModel(QObject *parent)
    : QAbstractListModel(parent)
{
    connect(&m_fetchWatcher, &QFutureWatcherBase::finished, this, &AlarmListModel::onFetchFinished);
    connect(&m_ackWatcher, &QFutureWatcherBase::finished, this, &AlarmListModel::onAckFinished);
}

int AlarmListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_items.size();
}

QVariant AlarmListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid() || index.row() < 0 || index.row() >= m_items.size())
        return {};

    const auto &a = m_items.at(index.row());

    switch (role) {
    case AlarmIdRole:
        return a.alarmId;
    case ZoneRole:
        return a.zone;
    case BuildingRole:
        return a.building;
    case RoomRole:
        return a.room;
    case EquipmentRole:
        return a.equipment;
    case AlarmTypeRole:
        return a.alarmType;
    case PriorityRole:
        return a.priority;
    case StatusRole:
        return a.status;
    case OwnerRole:
        return a.owner;
    case SlaRole:
        return a.sla;
    case ReadingRole:
        return a.reading;
    case TrendRole:
        return a.trend;
    }

    return {};
}

QHash<int, QByteArray> AlarmListModel::roleNames() const
{
    return {
        { AlarmIdRole, "alarmId" },
        { ZoneRole, "zone" },
        { BuildingRole, "building" },
        { RoomRole, "room" },
        { EquipmentRole, "equipment" },
        { AlarmTypeRole, "alarmType" },
        { PriorityRole, "priority" },
        { StatusRole, "status" },
        { OwnerRole, "owner" },
        { SlaRole, "sla" },
        { ReadingRole, "reading" },
        { TrendRole, "trend" }
    };
}

void AlarmListModel::setBusy(bool b)
{
    if (m_busy == b)
        return;
    m_busy = b;
    emit busyChanged();
}

void AlarmListModel::refresh()
{
    if (m_busy)
        return;

    beginResetModel();
    m_items.clear();
    endResetModel();

    setBusy(true);

    auto f = m_facade.getAlarms();
    m_fetchWatcher.setFuture(f);
}

void AlarmListModel::acknowledgeAt(int index)
{
    if (m_busy)
        return;
    if (index < 0 || index >= m_items.size())
        return;

    const auto &a = m_items.at(index);
    if (a.status != "Active")
        return;

    m_pendingAckId = a.alarmId;
    setBusy(true);
    m_ackWatcher.setFuture(m_facade.acknowledgeAlarm(m_pendingAckId));
}

void AlarmListModel::onFetchFinished()
{
    const auto vec = m_fetchWatcher.result();
    beginResetModel();
    m_items = vec;
    endResetModel();

    emit countChanged();
    setBusy(false);
}

void AlarmListModel::onAckFinished()
{
    setBusy(false);
    // After acknowledging, refresh list so UI stays consistent.
    refresh();
}

