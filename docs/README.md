# EnergyBuildAI Qt Dashboard Documentation

This documentation package turns the Qt dashboard into a reviewable embedded UI project rather than a single demo screen.

## Documents

| Document | Purpose |
| --- | --- |
| [Design Architecture](DESIGN_ARCHITECTURE.md) | Source layout, runtime model, QML component boundaries, alarm state handling, and target integration path. |
| [Alarm Acknowledgement Workflow](ALARM_ACKNOWLEDGEMENT_WORKFLOW.md) | Operator behavior for Active alarms KPI, Alarm Queue tickets, acknowledge page, and post-acknowledgement state. |
| [Digi ConnectCore Deployment](DIGI_CONNECTCORE_DEPLOYMENT.md) | Qt/Yocto toolchain setup, cross-build flow, systemd kiosk launch, platform plugin choices, and EVK smoke tests. |
| [Validation Matrix](VALIDATION_MATRIX.md) | Host, cross-build, target, UI, service, and portfolio verification checklist. |
| [Evidence](evidence/) | Simulated dashboard view exported as SVG/PNG until target EVK screenshots are captured. |

## Source Map

| Path | Role |
| --- | --- |
| `CMakeLists.txt` | Qt 6/CMake target, QML module, install rules, and service install hook. |
| `src/main.cpp` | Qt application bootstrap and QML module loading. |
| `qml/Main.qml` | Main shell, sidebar, KPI strip, overview, alarm details, acknowledge page, and local state transitions. |
| `qml/components/KpiCard.qml` | Reusable KPI card component with optional click behavior and critical styling. |
| `qml/components/AlarmTicket.qml` | Alarm queue ticket with status-based red active text. |
| `qml/components/StatusBadge.qml` | Reusable status badge for live/pending/acknowledged state. |
| `packaging/energybuildai-dashboard.service` | Boot-to-dashboard systemd service. |
| `yocto/energybuildai-dashboard_git.bb` | Digi Embedded Yocto recipe starter. |

## GitHub Repository

https://github.com/rheslar1/energybuildai-qt-dashboard
