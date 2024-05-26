#!/bin/bash

# You need a working WireGuard server with server keys generated for instance from:
# https://engineerworkshop.com/blog/how-to-set-up-wireguard-on-a-raspberry-pi/
#
# RUN AS ROOT
# Usage: ./wggen new_file client_ip

# Do not change
FILENAME="$1"
CLIENT_IP="$2/32"

# WireGuard Configuration - change these to your configuration
SERVER_ADDR="adres ip lub domena"
PORT="51900"
DNS="dns w lan"

# Key Generation
systemctl stop wg-quick@wg0
umask 077
wg genkey | tee "$FILENAME"_private_key | wg pubkey > "$FILENAME"_public_key

# Server .conf generation
FILENAME1="wg0.conf"
echo " " >> $FILENAME1
echo "#Peer $FILENAME configuration" >> $FILENAME1
echo "[Peer]" >> $FILENAME1
echo "PublicKey = $(cat "$FILENAME"_public_key)" >> $FILENAME1
echo "AllowedIPs = $CLIENT_IP" >> $FILENAME1

# Client .conf generation
FILENAME2="$FILENAME.client.conf"
touch $FILENAME2
echo "[Interface]" >> $FILENAME2
echo "PrivateKey = $(cat "$FILENAME"_private_key)" >> $FILENAME2
echo "Address = $CLIENT_IP" >> $FILENAME2
echo "DNS = $DNS" >> $FILENAME2
echo " " >> $FILENAME2
echo "[Peer]" >> $FILENAME2
echo "PublicKey = $(cat server_public_key)" >> $FILENAME2
echo "AllowedIPs = 0.0.0.0/0, ::/0" >> $FILENAME2
echo "Endpoint = $SERVER_ADDR:$PORT" >> $FILENAME2

# Removing temporary files
rm "$FILENAME"_p*
systemctl start wg-quick@wg0
