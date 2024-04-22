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
    percentage=$(acpi -b | head -n 1 | awk -F ', ' '{print $2}')
    echo "$percentage"
}

get_battery_estimate() {
    estimate=$(acpi -b | head -n 1 | awk -F ', ' '{print $3}' | sed 's/ remaining//')
    if [ -n "$estimate" ]; then
        hours=$(echo $estimate | awk -F ':' '{print $1}')
        minutes=$(echo $estimate | awk -F ':' '{print $2}')
        echo "${hours}h:${minutes}m"
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
