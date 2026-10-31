#!/bin/sh
# Print the clock, prefixed with a [working hours] badge during Mon-Fri 08:30-18:00.
# TMUX_WH_FAKE="<dow> <hhmm> <clock>" overrides the clock for testing.
set -eu

stamp=${TMUX_WH_FAKE:-$(date '+%u %H%M %H:%M')}
dow=${stamp%% *}
rest=${stamp#* }
hhmm=${rest%% *}
clock=${rest#* }

case "$dow" in
1 | 2 | 3 | 4 | 5)
  if [ ! "$hhmm" \< "0830" ] && [ "$hhmm" \< "1800" ]; then
    printf '#[fg=#d3c6aa] workin %s #[default]' "$clock"
    exit 0
  fi
  ;;
esac

printf '#[fg=#859289] caffeinate %s #[default]' "$clock"
