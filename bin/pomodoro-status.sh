#!/usr/bin/env bash
# NOTE: requires gnome-pomodoro

output=$(gdbus call --session \
	--dest org.gnome.Pomodoro \
	--object-path /org/gnome/Pomodoro \
	--method org.freedesktop.DBus.Properties.GetAll \
	org.gnome.Pomodoro 2>/dev/null)

# If Pomodoro isn't running at all
if [[ -z "$output" ]]; then
	printf ""
	exit 0
fi

# Extract values safely - FIXED: removed spaces in the IsPaused pattern
[[ $output =~ \'Elapsed\':\ \<([0-9.]+) ]] && elapsed=${BASH_REMATCH[1]:-0}
[[ $output =~ \'State\':\ \<\'([^\']+) ]] && state=${BASH_REMATCH[1]:-}
[[ $output =~ \'StateDuration\':\ \<([0-9.]+) ]] && duration=${BASH_REMATCH[1]:-0}
[[ $output =~ \'IsPaused\':\ \<(true|false) ]] && paused=${BASH_REMATCH[1]:-false} # ← FIXED

# If state is empty → stopped
if [[ -z "$state" ]]; then
	printf ""
	exit 0
fi

# Integer math
elapsed=${elapsed%.*}
duration=${duration%.*}
remaining=$((duration - elapsed))
((remaining < 0)) && remaining=0
minutes=$((remaining / 60))
seconds=$((remaining % 60))

# Icon logic
if [[ "$paused" == "true" ]]; then
	icon="" # paused
elif [[ "$state" == "pomodoro" ]]; then
	icon="" # running focus
elif [[ "$state" == "short-break" || "$state" == "long-break" ]]; then
	icon=" " # break
else
	icon="" # unknown / stopped
fi

printf "%s %02d:%02d" "$icon" "$minutes" "$seconds"
