#!/bin/bash

# Get the battery status
status=$(acpi -b | awk '{print $3}' | tr -d ',')
# If the battery is discharging or charging, show the estimated time
if [ "$status" == "Discharging" ] || [ "$status" == "Charging" ]; then
    estimate=$(acpi -b | awk '{print $5}' | awk -F ':' '{print $1":"$2}')
    echo "$estimate"
else
    echo "N/A"
fi
