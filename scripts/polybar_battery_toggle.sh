#!/bin/bash

toggle_battery_display() {
    current=$(cat /tmp/battery_toggle_state 2>/dev/null)

    if [ "$current" == "percentage" ]; then
        echo "estimate" > /tmp/battery_toggle_state
    else
        echo "percentage" > /tmp/battery_toggle_state
    fi
}

get_battery_percentage() {
    bat_percentage=$(acpi -b | awk '{print $4}' | tr -d ',')
    if [ "$bat_percentage" == "charging" ]; then
        bat_percentage=$(acpi -b | awk '{print $5}' | tr -d ',')
    fi
    echo "$bat_percentage"
}

get_battery_estimate() {
    status=$(acpi -b | awk '{print $3}' | tr -d ',')
    if [ "$status" == "Discharging" ] || [ "$status" == "Charging" ]; then
        estimate=$(acpi -b | awk '{print $5}' | awk -F ':' '{sub(/^0/, "", $1); print $1"h:"$2"m"}')
        echo "$estimate"
    else
        echo "N/A"
    fi
}

# Check if the script was triggered by a left click
if [ "$1" == "toggle" ]; then
    toggle_battery_display
fi

# Display the current state
current=$(cat /tmp/battery_toggle_state 2>/dev/null)
if [ "$current" == "percentage" ]; then
    get_battery_percentage
else
    get_battery_estimate
fi
