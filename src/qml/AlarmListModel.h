#pragma once

#include "../app/AppFacade.h"
#include "../domain/Alarm.h"

#include <QtCore/QAbstractListModel>
#include <QtCore/QFutureWatcher>
#include <QtCore/QVector>
#include <QtQml/QQmlEngine>

class AlarmListModel final : public QAbstractListModel
{
    Q_OBJECT

    Q_PROPERTY(bool busy READ busy NOTIFY busyChanged)
    Q_PROPERTY(int count READ rowCount NOTIFY countChanged)

public:
    enum Roles {
        AlarmIdRole = Qt::UserRole + 1,
        ZoneRole,
        BuildingRole,
        RoomRole,
        EquipmentRole,
        AlarmTypeRole,
        PriorityRole,
        StatusRole,
        OwnerRole,
        SlaRole,
        ReadingRole,
        TrendRole
    };

    explicit AlarmListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role) const override;
    QHash<int, QByteArray> roleNames() const override;

    Q_INVOKABLE void refresh();
    Q_INVOKABLE void acknowledgeAt(int index);

    bool busy() const { return m_busy; }

signals:
    void busyChanged();
    void countChanged();

private slots:
    void onFetchFinished();
    void onAckFinished();

private:
    void setBusy(bool b);

    bool m_busy{false};
    QVector<Domain::Alarm> m_items;

    App::AppFacade m_facade;
    QFutureWatcher<QVector<Domain::Alarm>> m_fetchWatcher;
    QFutureWatcher<void> m_ackWatcher;

    QString m_pendingAckId;
};

