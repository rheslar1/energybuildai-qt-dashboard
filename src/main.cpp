#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>

#include "qml/AlarmListModel.h"

int main(int argc, char *argv[])
{

    QGuiApplication app(argc, argv);

    QGuiApplication::setApplicationName(QStringLiteral("EnergyBuildAI Dashboard"));
    QGuiApplication::setOrganizationName(QStringLiteral("Rheslar"));
    QQuickStyle::setStyle(QStringLiteral("Fusion"));

    QQmlApplicationEngine engine;

    // Expose the model to QML as a creatable singleton-ish type.
    qmlRegisterType<AlarmListModel>("EnergyBuildAI", 1, 0, "AlarmListModel");

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.loadFromModule(QStringLiteral("EnergyBuildAI"), QStringLiteral("Main"));

    return app.exec();
}
