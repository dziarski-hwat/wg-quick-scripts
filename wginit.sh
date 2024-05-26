#!/bin/bash

# reboot after running

SRV_IP="10.253.3.1"
PORT="51900"
IFACE="wlan0"

echo "[Interface]" >> wg0.conf
echo "Address = $SRV_IP/24" >> wg0.conf
echo "SaveConfig = true" >> wg0.conf
echo "PrivateKey = $(cat server_private_key)" >> wg0.conf
echo "ListenPort = $PORT" >> wg0.conf
echo " " >> wg0.conf
echo "PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -A FORWARD -o %i -j ACCEPT; iptables -t nat -A POSTROUTING -o $IFACE -j MASQUERADE" >>wg0.conf
echo "PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -D FORWARD -o %i -j ACCEPT; iptables -t nat -D POSTROUTING -o $IFACE -j MASQUERADE" >> wg0.conf
echo " " >> wg0.conf
systemctl enable wg-quick@wg0
chown -R root:root /etc/wireguard/
chmod -R og-rwx /etc/wireguard/*
