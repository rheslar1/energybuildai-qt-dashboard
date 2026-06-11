SUMMARY = "EnergyBuildAI Qt Quick BMS dashboard"
DESCRIPTION = "Qt Quick operator dashboard for EnergyBuildAI/BMS alarm acknowledgement and building energy status."
HOMEPAGE = "https://github.com/rheslar1/energybuildai-qt-dashboard"
LICENSE = "MIT"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/MIT;md5=0835ade698e0bcf8506ecda2f7b4f302"

SRC_URI = "git://github.com/rheslar1/energybuildai-qt-dashboard.git;protocol=https;branch=main"
SRCREV = "${AUTOREV}"

S = "${WORKDIR}/git"

inherit cmake_qt6 systemd

DEPENDS += "qtdeclarative qtquickcontrols2"
RDEPENDS:${PN} += "qtdeclarative-qmlplugins qtquickcontrols2-qmlplugins"

SYSTEMD_SERVICE:${PN} = "energybuildai-dashboard.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

EXTRA_OECMAKE += "-DCMAKE_BUILD_TYPE=Release"

do_install:append() {
    install -d ${D}${systemd_system_unitdir}
    install -m 0644 ${S}/packaging/energybuildai-dashboard.service ${D}${systemd_system_unitdir}/
}

FILES:${PN} += "${systemd_system_unitdir}/energybuildai-dashboard.service"
