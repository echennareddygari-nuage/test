#! /bin/sh

echo "Appending iptables rules, please make sure iptables rules are empty."
iptables -P INPUT ACCEPT
iptables -P FORWARD ACCEPT
iptables -F
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -i lo -m comment --comment "Allow loopback connections" -j ACCEPT
iptables -A INPUT -p icmp -m comment --comment "Allow Ping to work as expected" -j ACCEPT
iptables -A INPUT -p tcp -m multiport --destination-ports 22,179,893,5201,6633,7407,11443,12443,39090,48179 -j ACCEPT
iptables -A INPUT -p udp -m multiport --destination-ports 53,123,500,4500,4789,50000,50001,50002,50003 -j ACCEPT
iptables -P INPUT DROP
iptables -P FORWARD DROP
