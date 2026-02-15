#!/usr/bin/env bash

# NOTE: requires gnome-pomodoro (install gnome-shell-pomodoro)

output=$(gdbus call --session \
	--dest org.gnome.Pomodoro \
	--object-path /org/gnome/Pomodoro \
	--method org.freedesktop.DBus.Properties.GetAll \
	org.gnome.Pomodoro 2>/dev/null) || {
	printf ""
	exit 0
}

[[ $output =~ \'Elapsed\':\ \<([0-9.]+) ]] && elapsed=${BASH_REMATCH[1]}
[[ $output =~ \'State\':\ \<\'([^\']+) ]] && state=${BASH_REMATCH[1]}
[[ $output =~ \'StateDuration\':\ \<([0-9.]+) ]] && duration=${BASH_REMATCH[1]}

# If not running
if [[ -z "$state" ]]; then
	printf ""
	exit 0
fi

elapsed=${elapsed%.*}
duration=${duration%.*}
remaining=$((duration - elapsed))
((remaining < 0)) && remaining=0

minutes=$((remaining / 60))
seconds=$((remaining % 60))

case "$state" in
pomodoro)
	icon=""
	;;
short-break | long-break)
	icon=""
	;;
*)
	icon=""
	;;
esac

printf "%s %02d:%02d" "$icon" "$minutes" "$seconds"
