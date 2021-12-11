#!/bin/sh

wifi_setup_radio()
{
	local radio=$1

	uci get wireless.${radio} >/dev/null 2>&1 && {
		#FIXME hack
		local path htmode
		if [ "${radio}" = "radio0" ] || [ "${radio}" = "radio1" ]; then
		if test -e /sys/kernel/debug/ieee80211/phy0/mt76 &&
		   [ "$(readlink /sys/class/ieee80211/phy0/device)" = "$(readlink /sys/class/ieee80211/phy1/device)" ]; then
			htmode="$(uci get wireless.${radio}.htmode)"
			path="$(uci get wireless.${radio}.path)"
			if test -z "${htmode##HE*}"; then
				htmode=HE
			else
				htmode=
			fi
			if test -z "${path#*+1}"; then
				uci set wireless.${radio}.phy='phy1'
				uci set wireless.${radio}.htmode="${htmode:-VHT}80"
				uci set wireless.${radio}.hwmode='11a'
				uci set wireless.${radio}.band='5g'
			else
				uci set wireless.${radio}.phy='phy0'
				uci set wireless.${radio}.htmode="${htmode:-HT}20"
				uci set wireless.${radio}.hwmode='11g'
				uci set wireless.${radio}.band='2g'
			fi
			uci delete wireless.${radio}.path
		fi
		fi # radio0/radio1

		uci -q batch <<-EOT
			set wireless.${radio}.disabled='0'
			set wireless.${radio}.country='CN'
			set wireless.${radio}.channel='auto'
		EOT

		if [ x`uci get wireless.${radio}.hwmode 2>/dev/null` = "x11a" ]; then
			uci set wireless.${radio}.txpower='23'
		else
			uci set wireless.${radio}.txpower='20'
		fi

		obj=`uci add wireless wifi-iface`
		test -n "$obj" && {
			uci set wireless.$obj.device="${radio}"
			uci set wireless.$obj.network='lan'
			if [ x`uci get wireless.${radio}.hwmode 2>/dev/null` = "x11a" ]; then
				uci set wireless.$obj.ssid="${SSID}_5G"
			else
				uci set wireless.$obj.ssid="${SSID}_2.4G"
			fi
			if [ "${SSID_PASSWD}" ]; then
			uci set wireless.$obj.encryption='psk2'
			uci set wireless.$obj.skip_inactivity_poll='1'
			uci set wireless.$obj.wpa_group_rekey='0'
			uci set wireless.$obj.wpa_pair_rekey='0'
			uci set wireless.$obj.wpa_master_rekey='0'
			uci set wireless.$obj.disassoc_low_ack='0'
			uci set wireless.$obj.key="${SSID_PASSWD}"
			fi
		}
	}
}

wifi_first_init()
{
	SSID="$(uci get base_config.@status[0].SSID 2>/dev/null || echo OpenWrt)"
	SSID_PASSWD="$(uci get base_config.@status[0].SSID_PASSWD 2>/dev/null)"

	while uci delete wireless.@wifi-iface[0] >/dev/null 2>&1; do :; done
	for radio in radio0 radio1 radio2 radio3 wifi0 wifi1 wifi2 wifi3; do
		wifi_setup_radio ${radio}
	done
	uci commit wireless

	# wireless migration
	local widx=0
	local change=0
	while uci rename wireless.@wifi-iface[$widx]=wifinet$widx >/dev/null 2>&1; do widx=$((widx+1)); done
	uci changes wireless | tr ".='" "   " | while read _ a b; do
		if [ "x$a" != "x$b" ]; then
			uci commit wireless
			change=1
			break
		fi
	done
	[ "x$change" = "x0" ] && uci revert wireless
}
