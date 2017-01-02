#!/bin/bash
sh -c "echo 0 > /proc/sys/net/ipv4/ip_forward"
iptables -F
