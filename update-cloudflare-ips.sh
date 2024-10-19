#!/bin/bash

### exit immediately if a command exits with a non-zero status
set -e

echo "Updating Cloudflare IPs and UFW rules..."

### URLs for Cloudflare IP lists
IPV4_URL="https://www.cloudflare.com/ips-v4"
IPV6_URL="https://www.cloudflare.com/ips-v6"

### temporary files to store IP lists
IPV4_FILE="/tmp/cloudflare-ips-v4.txt"
IPV6_FILE="/tmp/cloudflare-ips-v6.txt"

### get IP lists
curl -s $IPV4_URL -o $IPV4_FILE
curl -s $IPV6_URL -o $IPV6_FILE

### delete existing Cloudflare rules
sudo ufw status numbered | grep 'Cloudflare' | awk '{print $1}' | tr -d '[]' | sort -nr | while read -r line; do
  sudo ufw delete "$line"
done

### allow traffic from Cloudflare IPs to ports 80 and 443
while read -r ip; do
  sudo ufw allow proto tcp from "$ip" to any port 80,443 comment 'Cloudflare IPv4'
done < $IPV4_FILE

while read -r ip; do
  sudo ufw allow proto tcp from "$ip" to any port 80,443 comment 'Cloudflare IPv6'
done < $IPV6_FILE

echo "Cloudflare IPs updated and UFW rules configured."
