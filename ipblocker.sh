#!/bin/bash

BLOCKLIST="/opt/ipblocker/blocked_ips.txt"

if [ ! -f "$BLOCKLIST" ]; then
  echo "File blocked_ips.txt tidak ditemukan!"
  exit 1
fi

echo "🔒 Memblokir IP dari $BLOCKLIST ..."
while IFS= read -r ip; do
  if [ -n "$ip" ]; then
    sudo iptables -C INPUT -s "$ip" -j DROP 2>/dev/null || sudo iptables -A INPUT -s "$ip" -j DROP
    sudo iptables -C OUTPUT -d "$ip" -j DROP 2>/dev/null || sudo iptables -A OUTPUT -d "$ip" -j DROP
    echo "  ✅ $ip diblokir"
  fi
done < "$BLOCKLIST"

# Simpan aturan agar bertahan setelah reboot
sudo netfilter-persistent save

echo "✅ Semua IP telah diblokir dan aturan disimpan permanen."
