#!/bin/sh

# Wait 1 min tun0 to be mounted to start centreon poller
counter=60
while ! ifconfig | grep 'tun0'; do
    echo "$(date) [INFO] 'waitVPNForPoller.sh' Waiting openVPN network to be mounted to start centreon poller..."
    sleep 1
    counter=$(( $counter - 1 ))
    if [ $counter -eq 0 ]
    then
        echo "$(date) [ERROR] 'waitVPNForPoller.sh' $counter seconds timeout while waiting openVPN network"
        exit 1
    fi
done

echo "$(date) [INFO] 'waitVPNForPoller.sh' Start centreon poller"
/usr/sbin/centengine /etc/centreon-engine/centengine.cfg