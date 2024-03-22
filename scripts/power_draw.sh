#!/bin/bash

# Get power draw in Watts
power_draw=$(cat /sys/class/power_supply/BAT0/power_now)
power_draw=$(echo "scale=2; $power_draw / 1000000" | bc)

echo "$power_draw W"