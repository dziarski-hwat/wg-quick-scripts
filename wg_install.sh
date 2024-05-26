#!/bin/bash

#RUN AS ROOT

apt install wireguard
cd /etc/wireguard
umask 077
wg genkey | tee server_private_key | wg pubkey > server_public_key
echo "net.ipv4.ip_forward=1" >> /etc/sysctl.conf
