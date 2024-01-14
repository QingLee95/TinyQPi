SUMMARY = "Raspbery Pi Kiosk"
DESCRIPTION = "Wayland web kiosk using chromium and weston"
#No license
LICENSE = "CLOSED"

REQUIRED_MACHINE_FEATURES = "vc4graphics"
REQUIRED_DISTRO_FEATURES = "wayland"
CONFLICT_DISTRO_FEATURES = "x11"

SRC_URI = "file://piosk_chromium_init.sh"
RDEPENDS:${PN} = "wayland weston-init weston chromium-ozone-wayland"


initd="${sysconfdir}/init.d"
do_install() {
    # For sysvinit
    if ${@bb.utils.contains('DISTRO_FEATURES', 'sysvinit', 'true', 'false', d)}; then
        install -Dm 0755 ${WORKDIR}/piosk_chromium_init.sh ${D}${initd}/piosk.sh
    fi
}

INITSCRIPT_NAME = "piosk.sh"
# Start/stop after weston (level 20)
INITSCRIPT_PARAMS = "start 98 5 . stop 19 0 1 6 ."

inherit update-rc.d features_check

