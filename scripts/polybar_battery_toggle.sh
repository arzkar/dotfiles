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
  total_percentage=0
  count=0

  # Loop through each line starting from the first line
  while IFS= read -r line; do
    # Extract percentage for each battery and remove the % sign
    percentage=$(echo "$line" | awk -F ', ' '{print $2}' | tr -d '%')
    if [ -n "$percentage" ]; then
      total_percentage=$((total_percentage + percentage))
      count=$((count + 1))
    fi
  done < <(acpi -b)

  # Calculate average percentage if multiple batteries found
  if [[ $count -gt 0 ]]; then
    average_percentage=$((total_percentage / count))
    echo "$average_percentage%"
  else
    echo "N/A"
  fi
}

get_battery_estimate() {
  estimate_string=""

  # Loop through each line starting from the first line
  while IFS= read -r line; do
    # Extract remaining time for each battery
    estimate=$(echo "$line" | awk -F ', ' '{print $3}' | sed 's/ remaining//')
    if [ -n "$estimate" ]; then
      if [ -n "$estimate_string" ]; then
        estimate_string="$estimate_string, "
      fi
      estimate_string="$estimate_string$estimate"
    fi
  done < <(acpi -b)

  if [ -n "$estimate_string" ]; then
    echo "$estimate_string"
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
  acpi_output=$(acpi -b 2>/dev/null)
  if [ $? -eq 0 ]; then
    get_battery_percentage
  else
    echo "Error: Failed to get battery information"
  fi
else
  get_battery_estimate
fi
