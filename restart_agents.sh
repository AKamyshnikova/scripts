#!/bin/bash

# Restart l3 agents on all nodes
ssh node-1 'pcs resource disable p_neutron-l3-agent'
ssh node-1 'pcs resource enable p_neutron-l3-agent'

for i in $(fuel node | grep compute | awk '{print$1}'); do ssh node-$i 'service neutron-l3-agent restart';done

# Restart dhcp-agents

ssh node-1 'pcs resource disable p_neutron-dhcp-agent'
ssh node-1 'pcs resource enable p_neutron-dhcp-agent'

# Restart metadata-agents

ssh node-1 'pcs resource disable p_neutron-metadata-agent'
ssh node-1 'pcs resource enable p_neutron-metadata-agent'



