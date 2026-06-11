# Digi ConnectCore Deployment

## Target

The project is shaped for the Digi ConnectCore 93 EVK/DVK and ARM64 Yocto images with Qt 6 support.

The requested target name is Digi ConnectCore 93 EVK. Digi documentation refers to the ConnectCore 93 Development Kit and DVK in current Digi Embedded Yocto material; this project uses EVK/DVK wording so the portfolio language matches the requested hardware while staying aligned with Digi's docs.

References:

- Digi ConnectCore 93 documentation portal: https://www.digi.com/resources/documentation/digidocs/embedded/dey/5.0/cc93/index.html
- Digi ConnectCore 93 Qt install workflow: https://www.digi.com/resources/documentation/digidocs/embedded/dey/5.0/cc93/yocto-qt-install_t.html
- Digi ConnectCore 93 Qt image demo: https://docs.digi.com/resources/documentation/digidocs/embedded/dey/5.0/cc93/yocto-prebuilt-image-qt_t.html
- Digi Embedded Yocto layers: https://github.com/digi-embedded/meta-digi

## Host Requirements

- Linux x86_64 development host.
- CMake 3.21 or newer.
- Ninja or Make.
- Qt 6.5+ for host builds.
- Digi/NXP Yocto SDK with Qt support for target builds.

## Desktop Build

```bash
cmake -S . -B build-host -GNinja -DCMAKE_BUILD_TYPE=Debug
cmake --build build-host
./build-host/energybuildai-dashboard
```

## Yocto SDK Build

After installing the target SDK:

```bash
. /opt/dey/5.0-r4/environment-setup-armv8a-dey-linux

cmake -S . -B build-ccimx -GNinja -DCMAKE_BUILD_TYPE=Release
cmake --build build-ccimx
```

Some SDKs export a specific CMake toolchain file. If present:

```bash
cmake -S . -B build-ccimx -GNinja \
  -DCMAKE_TOOLCHAIN_FILE="$CMAKE_TOOLCHAIN_FILE" \
  -DCMAKE_BUILD_TYPE=Release
```

## Manual Target Install

```bash
scp build-ccimx/energybuildai-dashboard root@<evk-ip>:/usr/bin/
scp packaging/energybuildai-dashboard.service root@<evk-ip>:/lib/systemd/system/
ssh root@<evk-ip> 'systemctl daemon-reload'
ssh root@<evk-ip> 'systemctl enable --now energybuildai-dashboard'
```

## Platform Plugin Selection

The service defaults to:

```ini
Environment=QT_QPA_PLATFORM=wayland
```

Use the platform that matches the image:

| Platform | Use When |
| --- | --- |
| `wayland` | The image boots into a Wayland compositor. |
| `eglfs` | The app owns the display directly as a fullscreen appliance. |
| `xcb` | The image runs X11/Xwayland. |

## Yocto Recipe Integration

Copy the recipe into a custom layer:

```text
meta-rheslar/
  recipes-apps/
    energybuildai-dashboard/
      energybuildai-dashboard_git.bb
```

Add the package to an image:

```bitbake
IMAGE_INSTALL:append = " energybuildai-dashboard"
```

For production, replace:

```bitbake
SRCREV = "${AUTOREV}"
```

with the exact commit hash from:

```bash
git ls-remote https://github.com/rheslar1/energybuildai-qt-dashboard.git refs/heads/main
```

## Target Smoke Test

```bash
systemctl status energybuildai-dashboard
journalctl -u energybuildai-dashboard -n 80 --no-pager
pidof energybuildai-dashboard
```

Expected result:

- Service is active.
- No QML module load errors.
- Dashboard appears on the local display.
- Active alarms KPI shows `1` on first launch.
- Clicking `ALM-1042` changes Active alarms to `0`.

## Production Hardening

- Pin `SRCREV`.
- Add watchdog or systemd restart limits.
- Add a read-only rootfs persistence plan for logs/config.
- Add API credentials through a root-owned config file or secure provisioning flow.
- Add target screenshots and boot logs as release evidence.
