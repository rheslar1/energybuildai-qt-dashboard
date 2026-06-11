# EnergyBuildAI Qt Dashboard

Qt Quick version of the EnergyBuildAI/BMS operator dashboard for the Digi ConnectCore 93 EVK/DVK and other ARM64 Yocto targets.

The app mirrors the portfolio dashboard workflow:

- Building operation overview with live load, peak demand, active alarms, and acknowledged alarm KPIs.
- Alarm Center with `ALM-1042`, `ALM-1038`, and `ALM-1029` queue cards.
- Clicking an active queue alarm acknowledges it and removes it from the Active alarms count.
- Separate Alarm Acknowledge Page with `Acknowledge Alarm` and `Alarm Details` navigation.
- Touch-friendly 1280x800 layout intended for a 10 in EVK LCD or kiosk display.

## Target Notes

The user target is a Digi ConnectCore 93 EVK/DVK. Digi's current ConnectCore 93 documentation covers Digi Embedded Yocto, Qt Creator development, prebuilt Qt images, and the `environment-setup-armv8a-dey-linux` SDK workflow used by this project.

Useful references:

- Digi ConnectCore 93 documentation portal: https://www.digi.com/resources/documentation/digidocs/embedded/dey/5.0/cc93/index.html
- Digi ConnectCore 93 Qt install workflow: https://www.digi.com/resources/documentation/digidocs/embedded/dey/5.0/cc93/yocto-qt-install_t.html
- Digi ConnectCore 93 Qt image demo: https://docs.digi.com/resources/documentation/digidocs/embedded/dey/5.0/cc93/yocto-prebuilt-image-qt_t.html
- Digi Embedded Yocto layers: https://github.com/digi-embedded/meta-digi

## Repository

Standalone source repository:

https://github.com/rheslar1/energybuildai-qt-dashboard

Portfolio mirror path:

```text
qt/energybuildai-dashboard/
```

## Design Documentation

| Document | Purpose |
| --- | --- |
| [docs/README.md](docs/README.md) | Documentation index and source map. |
| [docs/DESIGN_ARCHITECTURE.md](docs/DESIGN_ARCHITECTURE.md) | Runtime layers, QML module boundaries, alarm state model, deployment boundary, and future live-data adapter path. |
| [docs/ALARM_ACKNOWLEDGEMENT_WORKFLOW.md](docs/ALARM_ACKNOWLEDGEMENT_WORKFLOW.md) | KPI click path, Alarm Queue click path, state transitions, and regression contract. |
| [docs/DIGI_CONNECTCORE_DEPLOYMENT.md](docs/DIGI_CONNECTCORE_DEPLOYMENT.md) | Digi/Yocto SDK build, target install, Qt platform plugin selection, systemd service, and recipe integration. |
| [docs/VALIDATION_MATRIX.md](docs/VALIDATION_MATRIX.md) | Host, target, Yocto, and portfolio verification checklist. |

Simulated view:

```text
docs/evidence/energybuildai-qt-dashboard-simulated.png
```

## Build On A Desktop Host

Install Qt 6.5 or newer with Qt Quick and Qt Quick Controls 2, then build:

```bash
cmake -S qt/energybuildai-dashboard -B /tmp/energybuildai-dashboard-build -GNinja
cmake --build /tmp/energybuildai-dashboard-build
/tmp/energybuildai-dashboard-build/energybuildai-dashboard
```

## Cross-Build With Digi Embedded Yocto SDK

Install the Digi Embedded Yocto SDK with Qt support for the ConnectCore 93 EVK/DVK image. Digi's ConnectCore 93 documentation shows an ARM64 SDK flow that sources `environment-setup-armv8a-dey-linux` before starting Qt Creator or building Qt applications.

```bash
cd /opt/dey/5.0-r4
. environment-setup-armv8a-dey-linux

cmake -S /path/to/energybuildai-qt-dashboard \
  -B /tmp/energybuildai-dashboard-ccimx \
  -GNinja \
  -DCMAKE_BUILD_TYPE=Release

cmake --build /tmp/energybuildai-dashboard-ccimx
```

If the SDK exports a specific `CMAKE_TOOLCHAIN_FILE`, pass it to CMake:

```bash
cmake -S . -B build-ccimx -GNinja \
  -DCMAKE_TOOLCHAIN_FILE="$CMAKE_TOOLCHAIN_FILE" \
  -DCMAKE_BUILD_TYPE=Release
```

## Install On The EVK

```bash
scp build-ccimx/energybuildai-dashboard root@<evk-ip>:/usr/bin/
scp packaging/energybuildai-dashboard.service root@<evk-ip>:/lib/systemd/system/
ssh root@<evk-ip> 'systemctl daemon-reload && systemctl enable --now energybuildai-dashboard'
```

The service defaults to Wayland:

```ini
Environment=QT_QPA_PLATFORM=wayland
```

For a direct framebuffer/kiosk image, change it to `eglfs`. For an Xwayland/X11 image, change it to `xcb`.

## Yocto Recipe

The `yocto/energybuildai-dashboard_git.bb` recipe is a starting point for a custom layer:

```text
meta-rheslar/
  recipes-apps/
    energybuildai-dashboard/
      energybuildai-dashboard_git.bb
```

For production builds, replace `SRCREV = "${AUTOREV}"` with a pinned commit from `rheslar1/energybuildai-qt-dashboard`.

## Runtime Behavior

- The Active alarms KPI opens the acknowledge page.
- `Acknowledge Alarm` changes the selected alarm to `Acknowledged`.
- Clicking an active `Alarm Queue` ticket also acknowledges it and drops Active alarms from `1` to `0`.
- Acknowledged queue cards remain selectable but no longer use active red text.
