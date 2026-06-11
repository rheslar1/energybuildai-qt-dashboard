# EnergyBuildAI Qt Dashboard

Qt Quick version of the EnergyBuildAI/BMS operator dashboard for Digi ConnectCore-class Linux EVKs and other ARM64 Yocto targets.

The app mirrors the portfolio dashboard workflow:

- Building operation overview with live load, peak demand, active alarms, and acknowledged alarm KPIs.
- Alarm Center with `ALM-1042`, `ALM-1038`, and `ALM-1029` queue cards.
- Clicking an active queue alarm acknowledges it and removes it from the Active alarms count.
- Separate Alarm Acknowledge Page with `Acknowledge Alarm` and `Alarm Details` navigation.
- Touch-friendly 1280x800 layout intended for a 10 in EVK LCD or kiosk display.

## Target Notes

The user target is a Digi ConnectCore i.MX94 EVK. Public Digi documentation currently exposes ConnectCore 95 and ConnectCore 93 development targets for Digi Embedded Yocto and Qt application workflows. This project is kept as a portable Qt 6/CMake application so it can be built with the matching Digi/NXP ARM64 Yocto SDK for the final EVK.

Useful references:

- Digi ConnectCore 95 product page: https://www.digi.com/products/embedded-systems/digi-connectcore/system-on-modules/digi-connectcore-95-som-nxp-i-mx-95
- Digi ConnectCore 95 Qt install workflow: https://www.digi.com/resources/documentation/digidocs/embedded/dey/5.0/cc95/yocto-qt-install_t.html
- Digi Embedded Yocto layers: https://github.com/digi-embedded/meta-digi

## Repository

Standalone source repository:

https://github.com/rheslar1/energybuildai-qt-dashboard

Portfolio mirror path:

```text
qt/energybuildai-dashboard/
```

## Build On A Desktop Host

Install Qt 6.5 or newer with Qt Quick and Qt Quick Controls 2, then build:

```bash
cmake -S qt/energybuildai-dashboard -B /tmp/energybuildai-dashboard-build -GNinja
cmake --build /tmp/energybuildai-dashboard-build
/tmp/energybuildai-dashboard-build/energybuildai-dashboard
```

## Cross-Build With Digi Embedded Yocto SDK

Install the Digi Embedded Yocto SDK with Qt support for your EVK image. Digi's ConnectCore 95 documentation shows an ARM64 SDK flow that sources `environment-setup-armv8a-dey-linux` before starting Qt Creator or building Qt applications.

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
