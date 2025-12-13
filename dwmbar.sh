get_battery() {
	capacity=$( cat /sys/class/power_supply/BAT*/capacity 2>/dev/null)
	status=$( cat /sys/class/power_supply/BAT*/status 2>/dev/null)
	echo "BAT: ${capacity}% (${status:-?})"
}

get_volume(){
	sink=$( pactl get-default-sink )
	vol=$( pactl get-sink-volume "$sink" | awk '{print $5}' | head -n1 )
	mute=$( pactl get-sink-mute "$sink" | awk '{print $2}' )
	if [ "$mute" = "yes" ]; then
		echo "Muted"
	else
		echo "VOL: $vol"
	fi
}
get_ip(){
	ip_wifi=$( ip a | grep -ie wlan0 | grep inet | awk '{print $2}' )
	ip_lan=$( ip a | grep -ie enp7s0 | grep inet | awk '{print $2}' )
	if [ -n "$ip_wifi" ]; then
		echo "IP: $ip_wifi"
	elif [ -n "$ip_lan" ]; then
		echo "IP: $ip_lan"
	else
		echo "IP:"
	fi
}
get_date(){
	date +"%F %R"
}

while true; do
	xsetroot -name "$(get_volume) | $(get_battery) | $(get_ip) | $(get_date)"
	sleep 1
done
