FROM centos:centos6

# Update CentOS
RUN yum -y update

# Install ssh
#RUN yum -y install openssh-server-5.3p1 openssh-client-5.3p1 openssh-clients-5.3p1
RUN yum -y install openssh-server-5.3p1 openssh-clients-5.3p1
RUN mkdir /var/run/sshd
#RUN sed -i 's/^#PermitRootLogin/PermitRootLogin/g' /etc/ssh/sshd_config
RUN /etc/init.d/sshd start && /etc/init.d/sshd stop

# Install centreon
RUN yum -y install python-setuptools-0.6.10

RUN yum -y install http://yum.centreon.com/standard/3.0/stable/noarch/RPMS/ces-release-3.0-1.noarch.rpm

RUN yum -y install centreon-engine-1.5.3 centreon-broker-cbmod-2.11.6 nagios-plugins-1.4.16 centreon-plugins-2.7.8 centreon-plugin-meta-2.7.8 

# Install openvpn
RUN yum -y install epel-release
RUN yum -y install openvpn-2.3.14 easy-rsa-2.2.2

# Set rights for setuid
RUN chown root:centreon-engine /usr/lib/nagios/plugins/check_icmp
RUN chmod -w /usr/lib/nagios/plugins/check_icmp
RUN chmod u+s /usr/lib/nagios/plugins/check_icmp
RUN chown apache.centreon-engine /etc/centreon-engine -R
RUN chown apache.centreon-broker /etc/centreon-broker -R
RUN chown centreon.centreon /etc/centreon-engine/ -R
RUN chown centreon-engine.centreon-engine /var/log/centreon-broker/
RUN usermod -G centreon-engine centreon-broker
RUN usermod -G centreon-broker centreon-engine
RUN usermod -aG centreon centreon-engine
RUN usermod -aG centreon centreon-broker
RUN mkdir /var/lib/centreon-broker_tmp/ && chown centreon-broker.centreon-broker /var/lib/centreon-broker_tmp/ && chmod g+w /var/lib/centreon-broker_tmp/
RUN touch /var/log/centreon-engine/retention.dat && chown centreon-engine.centreon-engine /var/log/centreon-engine/retention.dat

#changing restarting of the centengine as it's run from supervisord not normal init.d script
RUN sed -i 's/service_restart$/killall -9 centengine/' /etc/init.d/centengine 

RUN easy_install supervisor

ADD scripts/supervisord.conf /etc/supervisord.conf

EXPOSE 22

#adding new sudoers to the centron file
ADD scripts/sudoers.new /tmp/sudoers.new
RUN cat /tmp/sudoers.new >> /etc/sudoers.d/centreon && rm /tmp/sudoers.new

# Add entry point script
ADD scripts/entrypoint.sh /tmp/entrypoint.sh
ENTRYPOINT ["/tmp/entrypoint.sh"]

# Add script to launch centreon-poller
ADD scripts/waitVPNForPoller.sh /etc/centreon/waitVPNForPoller.sh
RUN chown centreon-engine:centreon-engine /etc/centreon/waitVPNForPoller.sh
RUN chmod u+x /etc/centreon/waitVPNForPoller.sh

# Add script for openVpn route
ADD scripts/customRoute.sh /etc/openvpn/config/customRoute.sh
RUN chmod u+x /etc/openvpn/config/customRoute.sh

CMD /usr/bin/supervisord --configuration=/etc/supervisord.conf
