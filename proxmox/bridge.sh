#!/bin/bash

INTERFACE="eth0"
GATEWAY="178.211.139.129"

TABLE_NAME="additional_ip"
grep -q "$TABLE_NAME" /etc/iproute2/rt_tables || echo "100 $TABLE_NAME" >> /etc/iproute2/rt_tables

COUNTER=1

add_ip() {
    local ip=$1
    local mask=$2
    local virtual_interface="$INTERFACE:$COUNTER"

    ip addr add $ip/$mask dev $virtual_interface

    echo "auto $virtual_interface" >> /etc/network/interfaces
    echo "iface $virtual_interface inet static" >> /etc/network/interfaces
    echo "    address $ip" >> /etc/network/interfaces
    echo "    netmask $mask" >> /etc/network/interfaces
    echo "    gateway $GATEWAY" >> /etc/network/interfaces

    COUNTER=$((COUNTER+1))
}

while IFS= read -r line; do
    add_ip $line 255.255.255.128
done < ips.txt

echo "Init ipv4 finished"
