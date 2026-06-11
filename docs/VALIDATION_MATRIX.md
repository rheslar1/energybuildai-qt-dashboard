# Validation Matrix

## Current Validation

| Area | Check | Status |
| --- | --- | --- |
| Portfolio React typecheck | `npm run typecheck` | Passing |
| Portfolio React tests | `npm test -- --watchAll=false` | Passing |
| MySQL backup shell syntax | `bash -n scripts/backup-bems-mysql.sh scripts/restore-bems-mysql.sh` | Passing |
| Standalone Qt repo push | `git push -u origin main` | Passing |

## Qt Host Checks

Run on a host with Qt 6.5+ installed:

```bash
cmake -S . -B build-host -GNinja -DCMAKE_BUILD_TYPE=Debug
cmake --build build-host
./build-host/energybuildai-dashboard
```

Acceptance:

- Window opens at 1280x800.
- Sidebar and header render.
- Overview page renders KPI cards.
- Active alarms KPI opens the acknowledge page.
- `Acknowledge Alarm` changes the count to `0`.
- Alarm Details returns to the queue.

## Qt Target Checks

Run on the EVK:

```bash
systemctl enable --now energybuildai-dashboard
systemctl status energybuildai-dashboard
journalctl -u energybuildai-dashboard -n 80 --no-pager
```

Acceptance:

- Service starts without restart loops.
- Qt platform plugin matches the image.
- Local display is not blank.
- Touch or mouse input can select alarm queue tickets.
- Active alarm red text disappears after acknowledgement.

## Yocto Checks

```bash
bitbake energybuildai-dashboard
oe-pkgdata-util list-pkg-files energybuildai-dashboard
```

Acceptance:

- Binary installs under `/usr/bin/energybuildai-dashboard`.
- Service installs under `/lib/systemd/system/energybuildai-dashboard.service`.
- Runtime image contains Qt Quick and Quick Controls 2 QML plugins.

## Evidence To Capture

- Desktop Qt screenshot.
- EVK LCD photo or screenshot.
- `systemctl status` output.
- `journalctl` output after launch.
- Active alarm before/after screenshot.
- Yocto build log and deployed package manifest.
