#!/bin/sh

MESOS_CENTREON_POLLER_SSH_KEY=authorized_keys
MESOS_CENTREON_POLLER_OPENVPN_CONFIG=pollerConfig.ovpn

# Check if keys variable to centreon user is set
# If so, add key
mkdir /var/spool/centreon/.ssh
touch /var/spool/centreon/.ssh/authorized_keys
if [ -n "${MESOS_SANDBOX}" ]; then
    if [ -f "${MESOS_SANDBOX}/${MESOS_CENTREON_POLLER_SSH_KEY}" ]; then
        echo "Adding SSH key to centron user"; 
	    cd ${MESOS_SANDBOX}
	    /bin/cp ${MESOS_CENTREON_POLLER_SSH_KEY} /var/spool/centreon/.ssh/
    fi
fi

chmod 700 /var/spool/centreon/.ssh
chmod go-w /var/spool/centreon/.ssh
chmod 600 /var/spool/centreon/.ssh/authorized_keys
chown centreon.centreon /var/spool/centreon/.ssh
chown centreon.centreon /var/spool/centreon/.ssh/authorized_keys

# Configure openvpn
if [ -n "${MESOS_SANDBOX}" ]; then
    if [ -f "${MESOS_SANDBOX}/${MESOS_CENTREON_POLLER_OPENVPN_CONFIG}" ]; then
        echo "Adding openvpn configuration"; 
	    cd ${MESOS_SANDBOX}
        mkdir /etc/openvpn/config
	    cp ${MESOS_CENTREON_POLLER_OPENVPN_CONFIG} /etc/openvpn/config/
	fi
fi

# Update rigth of poller configuration
chown -R centreon:centreon /etc/centreon-broker
chown -R centreon:centreon /etc/centreon-engine

echo "Running command : $@"
exec $@