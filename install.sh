#!/bin/bash
# Install calendar-bar: links the script into ~/.local/bin and saves your calendar address.
# Safe to run again. Adding the polybar module is up to you (see README).
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BIN="$HOME/.local/bin"
URL_FILE="$HOME/.config/calendar-bar/ics_url"
OLD_URL_FILE="$HOME/.config/meetings/ics_url"  # where the original meetings.py kept it

echo "==> Installing calendar-bar from $REPO"
chmod +x "$REPO/bin/calendar-bar"

echo "--> Checking what it needs"
missing=0
python3 -c 'import recurring_ical_events' 2>/dev/null \
  || { echo "    ! missing: python-recurring-ical-events  (sudo pacman -S python-recurring-ical-events)"; missing=1; }
for dep in rofi notify-send xdg-open; do
  command -v "$dep" >/dev/null 2>&1 || { echo "    ! missing: $dep"; missing=1; }
done
(( missing )) && echo "    install the missing packages, then run ./install.sh again" && exit 1
"$REPO/bin/calendar-bar" selftest >/dev/null && echo "    ok"

echo "--> Script"
mkdir -p "$BIN"
if [[ -e $BIN/calendar-bar && ! -L $BIN/calendar-bar ]]; then
  mv "$BIN/calendar-bar" "$BIN/calendar-bar.bak.$(date +%s)" && echo "    backed up existing $BIN/calendar-bar"
fi
ln -sfn "$REPO/bin/calendar-bar" "$BIN/calendar-bar"
echo "    $BIN/calendar-bar -> $REPO/bin/calendar-bar"
case ":$PATH:" in *":$BIN:"*) ;; *) echo "    ! $BIN is not on your PATH — add it (see README)";; esac

echo "--> Calendar address"
if [[ -s $URL_FILE ]]; then
  echo "    already saved in $URL_FILE"
elif [[ -s $OLD_URL_FILE ]]; then
  install -D -m 600 "$OLD_URL_FILE" "$URL_FILE" && echo "    copied from $OLD_URL_FILE"
elif [[ -t 0 ]]; then
  "$REPO/bin/calendar-bar" set-url
else
  echo "    run 'calendar-bar set-url' to add it"
fi

cat <<MSG
==> Done. Now add the bar module:
    command cat $REPO/polybar/calendar.ini >> ~/.config/polybar/config.ini
    then put "calendar" in modules-right and restart polybar.
MSG
