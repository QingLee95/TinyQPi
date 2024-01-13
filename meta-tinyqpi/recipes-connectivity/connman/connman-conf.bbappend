# Disable connman for interface eth0 to prevent DHCP for that interface
# Interface eth0 is set statically by ifupdown

# File in this path needs to be added in order for it to find it
FILESEXTRAPATHS:prepend:static_eth0 := "${THISDIR}/${PN}:"
#Override main.conf in lower layer
SRC_URI:prepend:static_eth0 = "file://main.conf "

do_install:append:static_eth0() {
    mkdir -p ${D}${sysconfdir}/connman
    cp ${S}/main.conf ${D}${sysconfdir}/connman/main.conf
}

# Configure connman to add a configured wifi
# At startup it wil immeadiatly connect to a defined wifi network

# File in this path needs to be added in order for it to find it
FILESEXTRAPATHS:append:configured_wifi := ":${THISDIR}/${PN}"
SRC_URI:append:configured_wifi = "file://settings "

CONNMAN_CONFIG = "/var/lib/connman"

do_install:append:configured_wifi(){
    if [ "${WIFI_NAME}" = "" ]; then
        bberror "Variable WIFI_NAME is not set"
    fi
    if [ "${WIFI_PWD}" = "" ]; then
        bberror "Variable WIFI_PWD is not set"
    fi
    install -d ${D}${CONNMAN_CONFIG}
    install -m 0644 ${WORKDIR}/settings ${D}${CONNMAN_CONFIG}/
    
# Don't add spaces
    echo "[service_${WIFI_NAME}]
Type = wifi
Name = ${WIFI_NAME}
Passphrase = ${WIFI_PWD}
IPv4 = dhcp
DeviceName = wlan0
Security = psk" > ${D}${CONNMAN_CONFIG}/${WIFI_NAME}.config
}

FILES:${PN}:append:configured_wifi = " ${CONNMAN_CONFIG}"