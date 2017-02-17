#!/bin/sh

# Add new route for VPN network
echo "$(date) [INFO] 'customRoute.sh' Add new route for VPN network : ip route add $(echo $4 | sed 's/\(.*\)\..*/\1/').0/24 via $5 dev tun0"
/sbin/ip route add $(echo $4 | sed 's/\(.*\)\..*/\1/').0/24 via $5 dev tun0