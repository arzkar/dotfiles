#!/usr/bin/env bash

# Only exported variables can be used within the timer's command.
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"

  # `# Don't lock when there's audio playing` \
  # --not-when-audio \
# Run xidlehook
xidlehook \
  `# Don't lock when there's a fullscreen application` \
  --not-when-fullscreen \
  `# Dim the screen after 60 seconds, undim if user becomes active` \
  --timer 60 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness .1' \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1' \
  `# Undim & lock after 10 more seconds` \
  --timer 120 \
    'xrandr --output "$PRIMARY_DISPLAY" --brightness 1; i3lock-fancy' \
    '' \
  `# Finally, suspePnd an hour after it locks` \
  --timer 3600 \
    'systemctl suspend' \
    ''