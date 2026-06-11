# Design Architecture

## Objective

EnergyBuildAI Qt Dashboard is the embedded-native version of the BMS operations dashboard. It targets a Digi ConnectCore 93 EVK/DVK or comparable ARM64 Yocto device where a Qt Quick application is a better fit than a browser dashboard.

The dashboard keeps the same operator concepts as the web version:

- Building operation overview.
- Active alarm count.
- Alarm queue.
- Separate acknowledgement page.
- Active alarm clearing after acknowledgement.
- Kiosk-style deployment through systemd.

## Runtime Layers

```text
EVK display / touch panel
  |
Qt Quick Controls 2 UI
  |
QML dashboard shell
  |
Local alarm state model
  |
Future API adapter or edge telemetry bridge
  |
BEMS Node API / MySQL / edge-core / BACnet devices
```

The first implementation intentionally keeps alarm data local in QML so the UI behavior can be built, reviewed, and deployed before binding it to a live BMS API. The source is structured so the local `ListModel` can later be replaced by a C++ `QAbstractListModel`, REST adapter, MQTT client, or local IPC bridge.

## Process Model

`src/main.cpp` owns only process bootstrap:

1. Create `QGuiApplication`.
2. Set application and organization names.
3. Apply the Fusion control style.
4. Load the QML module with `engine.loadFromModule("EnergyBuildAI", "Main")`.
5. Exit with failure if the QML root object cannot be created.

Keeping C++ bootstrap small leaves UI iteration in QML while preserving the option to add native services later.

## QML Module Structure

`qml/Main.qml` is the application composition root. It owns:

- Application window dimensions.
- Header and sidebar navigation.
- Page mode: `overview`, `alarms`, or `acknowledge`.
- Seeded alarm model.
- Active, acknowledged, and auto-clear KPI counts.
- Page-level functions for selecting and acknowledging alarms.

Reusable components live under `qml/components/`:

- `KpiCard.qml` handles repeated metric panels.
- `AlarmTicket.qml` handles the alarm queue row/card.
- `StatusBadge.qml` handles compact status labels.

The component split keeps the QML readable and makes touch-size controls consistent across pages.

## Alarm State Model

The current model uses a QML `ListModel` with three seeded alarms:

| ID | Zone | Type | Initial Status |
| --- | --- | --- | --- |
| `ALM-1042` | Tower B Floor 1 | Demand peak | Active |
| `ALM-1038` | Floor 1 AHU | Static pressure drift | Acknowledged |
| `ALM-1029` | Lobby Lighting | Schedule override | Auto-clear |

The dashboard exposes derived counts:

- `activeAlarmCount`
- `acknowledgedAlarmCount`
- `autoClearAlarmCount`

`recalcAlarmCounts()` recomputes those values after any alarm status change.

## Acknowledgement Rules

Two actions acknowledge an active alarm:

1. Click the Active alarms KPI, open the acknowledgement page, then press `Acknowledge Alarm`.
2. Click an active Alarm Queue ticket on the Alarm Center page.

Both paths change `ALM-1042` from `Active` to `Acknowledged` and recalculate the KPI state. The alarm remains selectable for review but is no longer counted as active and no longer uses active red text.

## Visual System

The visual system is intentionally industrial and compact:

- Dark operations sidebar.
- Blue portfolio header.
- Green normal state.
- Red active alarm state.
- Dense KPI cards.
- Touch-safe buttons.
- 6 px panel radius.

The Qt dashboard avoids marketing layout patterns and keeps the first screen focused on the control-room workflow.

## Embedded Deployment Boundary

The app can run three ways:

| Mode | Use |
| --- | --- |
| Desktop Qt build | Developer UI iteration and screenshot capture. |
| Yocto SDK cross-build | ARM64 binary generation for Digi/NXP target. |
| Yocto recipe | Production image integration through a custom layer. |

`packaging/energybuildai-dashboard.service` launches the app at boot. The default platform plugin is Wayland, but the deployment doc explains when to use `eglfs` or `xcb`.

## Future Live Data Integration

The next production step is replacing local QML seed data with a target-side adapter:

- C++ REST client polling the BEMS Node API.
- WebSocket/SSE bridge for live alarms.
- MQTT client consuming edge-core alarm topics.
- Local SQLite cache for offline display.
- MySQL access only through API/service boundaries, not directly from the QML UI.

Recommended direction: add a C++ `AlarmModel` backed by API responses, then expose it to QML as a context property or registered QML type.
