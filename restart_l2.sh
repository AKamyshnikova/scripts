#!/bin/bash


ssh node-$i 'pcs resource disable p_neutron-plugin-openvswitch-agent'


ssh node-$i 'pcs resource enable p_neutron-plugin-openvswitch-agent'


for i in $(fuel node | grep compute| awk '{print$1}'); do ssh node-$i 'service neutron-plugin-openvswitch-agent stop';done

# Correct config file name
sed -i -e 's/openvswith_agent.ini/ml2_conf.ini/g' test.conf

for i in $(fuel node | grep compute| awk '{print$1}'); do ssh node-$i 'service neutron-openvswitch-agent start';done
