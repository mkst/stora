#!/bin/bash

# purpose: installs nzbget
# version: 1.0

# variables
transmissiond_location="./dl/transmissiond"

# get daemon user, use sudo-er by default
echo -n "Please enter the daemon user: [$SUDO_USER]: "
read -r TRANSMISSION_USER

if [ -z "${TRANSMISSION_USER}" ]
then
    TRANSMISSION_USER=${SUDO_USER}
fi

# get transmission home location, use ~/transmission by default
echo -n "Please enter the destination where you want files saved: [/home/${TRANSMISSION_USER}/transmission/]: "
read -r TRANSMISSION_HOME
if [ -z "${TRANSMISSION_HOME}" ]
then
    TRANSMISSION_HOME=/home/${TRANSMISSION_USER}/transmission
fi

# get monitoring directory, use ~/transmission/monitor by default
echo -n "Please enter the directory to monitor for new .torrent files: [/home/${TRANSMISSION_USER}/transmission/monitor/]: "
read -r TRANSMISSION_MONITOR_HOME
if [ -z "${TRANSMISSION_MONITOR_HOME}" ]
then
    TRANSMISSION_MONITOR_HOME=/home/${TRANSMISSION_USER}/transmission/monitor
fi

# install using ipkg
/opt/bin/ipkg install transmission

# get daemon and setup home dir
sed "${transmissiond_location}" -e "s#TRANSMISSION_HOME=#TRANSMISSION_HOME=${TRANSMISSION_HOME}#"\
                                -e "s#DAEMON_USER=#DAEMON_USER=\"${TRANSMISSION_USER}\"#" > /etc/init.d/transmissiond

# make executable
chmod 755 /etc/init.d/transmissiond

# create dirs if they dont exist
if [ ! -d "${TRANSMISSION_HOME}" ]
then
    echo "Creating ${TRANSMISSION_HOME}..."
    mkdir -p "${TRANSMISSION_HOME}"
    chmod 777 "${TRANSMISSION_HOME}"
    chown "${TRANSMISSION_USER}":"${TRANSMISSION_USER}" "${TRANSMISSION_HOME}"
fi

if [ ! -d "${TRANSMISSION_MONITOR_HOME}" ]
then
    echo "Creating ${TRANSMISSION_MONITOR_HOME}..."
    mkdir -p "${TRANSMISSION_MONITOR_HOME}"
    chmod 777 "${TRANSMISSION_MONITOR_HOME}"
    chown "${TRANSMISSION_USER}":"${TRANSMISSION_USER}" "${TRANSMISSION_MONITOR_HOME}"
fi

# start/stop daemon to generate config file
echo "Starting Transmission to generate config file..."
/etc/init.d/transmissiond start
# kill the daemon
echo "Killing Transmission"
/etc/init.d/transmissiond stop

# add extra excape chars
TRANSMISSION_MONITOR_HOME=$(echo "${TRANSMISSION_MONITOR_HOME}" | sed 's#\/#\\\\\\\/#g')

# add configuration

mv "${TRANSMISSION_HOME}"/settings.json "${TRANSMISSION_HOME}"/settings.json.original
sleep 1
sed "${TRANSMISSION_HOME}"/settings.json.original "s#\"rpc-whitelist-enabled\": true,#\"rpc-whitelist-enabled\": false,\n    \"watch-dir\":\"${TRANSMISSION_MONITOR_HOME}\",\n    \"watch-dir-enabled\":true,#" > "${TRANSMISSION_HOME}"/settings.json

# make daemon start at boot
echo "Adding transmissiond to startup..."
/sbin/chkconfig --add transmissiond
/sbin/chkconfig --levels 2345 transmissiond on

# start transmission and we're done
/etc/init.d/transmissiond start
