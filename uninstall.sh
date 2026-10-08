#!/bin/bash
# Remove what install.sh set up. Keeps your calendar address unless --purge.
set -euo pipefail

REPO="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
link="$HOME/.local/bin/calendar-bar"

echo "==> Uninstalling calendar-bar"
if [[ -L $link && "$(readlink -f "$link")" == "$REPO"* ]]; then
  rm "$link" && echo "    removed $link"
fi
if [[ ${1:-} == --purge ]]; then
  rm -rf "$HOME/.config/calendar-bar" "$HOME/.cache/calendar-bar"
  echo "    removed your calendar address and cache"
else
  echo "    kept ~/.config/calendar-bar (your calendar address) — use --purge to remove it"
fi
echo "==> Done. Remove the [module/calendar] section and \"calendar\" from your polybar config."
