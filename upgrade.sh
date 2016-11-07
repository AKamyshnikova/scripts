#!/bin/bash

#backup all configs
cp -avr /etc/neutron/ ~/backup_conf/

#Remove cleaning up namespaces on stop/start in pacemaker
pcs resource update p_neutron-l3-agent remove_artifacts_on_stop_start=false
pcs resource update p_neutron-dhcp-agent remove_artifacts_on_stop_start=false

# Prevent restart of server during update
echo 'manual' > /etc/init/neutron-server.override

echo exit 101 > /usr/sbin/policy-rc.d
chmod +x /usr/sbin/policy-rc.d

echo 'deb http://mirror.fuel-infra.org/mos-repos/ubuntu/9.0/ mos9.0 main' > /etc/apt/sources.list.d/mos9.0.list

apt-get update

sed -i 's/1050/500/g' /etc/apt/preferences.d/*

# Update neutron packages
DEBIAN_FRONTEND=noninteractive apt-get install --only-upgrade --yes --force-yes -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" python-neutron

# Manually install library that installed incorrecly.
apt-get install --only-upgrade --yes --force-yes python-os-cloud-config

service neutron-server stop
