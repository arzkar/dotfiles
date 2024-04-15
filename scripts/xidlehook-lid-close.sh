#!/usr/bin/env bash

# Only exported variables can be used within the timer's command.
export PRIMARY_DISPLAY="$(xrandr | awk '/ primary/{print $1}')"
# Run xidlehook
$HOME/.cargo/bin/xidlehook \
  `# lock after 1 second` \
  --timer 1 \
    'i3lock-fancy' \
    '' \
  `# suspend after it locks` \
  --timer 1 \
    'systemctl suspend' \
    ''