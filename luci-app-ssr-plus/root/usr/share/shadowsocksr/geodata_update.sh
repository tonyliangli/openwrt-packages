#!/bin/sh

rm -rf /tmp/geo*

#wget --no-check-certificate -q -O /tmp/geoip.dat https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat
wget --no-check-certificate -q -O /tmp/geosite.dat https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat

if [ -f "/tmp/geosite.dat" ]; then
    #v2dat unpack geoip -o /tmp/ -f cn /tmp/geoip.dat >/dev/null 2>&1 &
    #mv /tmp/geoip_cn.txt /etc/ssrplus/mosdns-chinadns/geoip_cn.txt
    v2dat unpack geosite -o /tmp/ -f cn -f geolocation-!cn /tmp/geosite.dat
    mv /tmp/geosite_cn.txt /etc/ssrplus/mosdns-chinadns/geosite_cn.txt
    mv /tmp/geosite_geolocation-!cn.txt /etc/ssrplus/mosdns-chinadns/geosite_geolocation_not_cn.txt
    echo 111
else
    echo 000
fi