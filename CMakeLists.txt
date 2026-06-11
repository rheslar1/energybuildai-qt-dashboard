cmake_minimum_required(VERSION 3.21)

project(EnergyBuildAIDashboard
    VERSION 1.0.0
    DESCRIPTION "Qt Quick BMS dashboard for Digi ConnectCore 93 EVK/DVK"
    LANGUAGES CXX
)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_AUTOMOC ON)

include(GNUInstallDirs)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(energybuildai-dashboard
    src/main.cpp
)

qt_add_qml_module(energybuildai-dashboard
    URI EnergyBuildAI
    VERSION 1.0
    QML_FILES
        qml/Main.qml
        qml/components/AlarmTicket.qml
        qml/components/KpiCard.qml
        qml/components/StatusBadge.qml
)

target_link_libraries(energybuildai-dashboard
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
)

install(TARGETS energybuildai-dashboard
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(FILES packaging/energybuildai-dashboard.service
    DESTINATION ${CMAKE_INSTALL_LIBDIR}/systemd/system
)
