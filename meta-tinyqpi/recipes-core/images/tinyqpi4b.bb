SUMMARY = "Image for the Raspberry Pi 4B"

# Base this image on core-image-base
include recipes-core/images/core-image-base.bb

COMPATIBLE_MACHINE = "^rpi$"

OMXPLAYER = "${@bb.utils.contains('MACHINE_FEATURES', 'vc4graphics', '', 'omxplayer', d)}"

IMAGE_INSTALL:append = "\
    ${OMXPLAYER} \
    bcm2835-tests \
    pi-blaster \
    connman \
    connman-client \
    piosk \
"

RRECOMMENDS:${PN} = "\
    ${@bb.utils.contains("BBFILE_COLLECTIONS", "meta-multimedia", "bigbuckbunny-1080p bigbuckbunny-480p bigbuckbunny-720p", "", d)} \
    ${MACHINE_EXTRA_RRECOMMENDS} \
"