# calendar-bar

Your next Google Calendar meeting in the top bar, with a one-click **Join** button. Works with **polybar** (for example on i3).

```
 󰃭 10:30AM Sprint planning        next meeting today (yellow icon)
 󰤙 Standup 09:15AM                starts within 10 minutes: green, and it has a meeting link
 󰤙 Standup now                    happening now
 󰃭                                no more meetings today
 󰃭 (red)                          couldn't read the calendar (offline and no saved copy)
```

- **Left-click** opens a small popup in the top-right corner: the day's meetings, `←` / `→` to change day, a month view to jump to any date, and **Join** links.
- **Right-click** joins the meeting that's on now, or starts within 10 minutes (Google Meet, Zoom or Teams).

It reads your calendar through Google's private **iCal address**: no Google login, no API keys, no browser extension.

## Contents

- [Before you start](#before-you-start)
- [Install](#install)
- [Get your calendar address](#get-your-calendar-address)
- [Add it to polybar](#add-it-to-polybar)
- [Everyday use](#everyday-use)
- [Setting it up on another computer / for someone else](#setting-it-up-on-another-computer--for-someone-else)
- [Update](#update) · [Uninstall](#uninstall) · [Troubleshooting](#troubleshooting) · [How it works](#how-it-works)

## Before you start

You need:

- **Linux with polybar.** The popup uses **rofi**.
- **Python 3** and the **`recurring-ical-events`** library (handles repeating meetings).
- A **Nerd Font** for the icons (`󰃭`, `󰤙`).
- **`~/.local/bin` on your `PATH`**: the installer puts the `calendar-bar` command there. Check with `echo $PATH`. If it's missing, add `export PATH="$HOME/.local/bin:$PATH"` to `~/.profile` (or `~/.zshrc` / `~/.bashrc`) and open a new terminal.

**About paths in this guide:** `~` means your home folder (for example `/home/yourname`). The commands assume you clone the repo to `~/Projects/calendar-bar`. If you clone it somewhere else, use your own path wherever you see `~/Projects/calendar-bar`.

## Install

**1. Install the packages.**

Arch Linux:

```bash
sudo pacman -S --needed git python python-recurring-ical-events rofi libnotify xdg-utils polybar ttf-nerd-fonts-symbols
```

| Package | Why |
|---|---|
| `python-recurring-ical-events` | reads the calendar, including repeating meetings |
| `rofi` | the popup |
| `libnotify` | the "No meeting to join right now" notification |
| `xdg-utils` | opens meeting links and Google Calendar in your browser |
| `ttf-nerd-fonts-symbols` | the icons |

Other distros (not tested by the maintainers):

| Distro | Command |
|---|---|
| Debian / Ubuntu | `sudo apt install git python3 python3-recurring-ical-events rofi libnotify-bin xdg-utils polybar` |
| Fedora | `sudo dnf install git python3 rofi libnotify xdg-utils polybar`, then `pip install --user recurring-ical-events` |

If your distro has no package for `recurring-ical-events`, `pip install --user recurring-ical-events` works anywhere.

**2. Get the code and run the installer:**

```bash
git clone <repo-url> ~/Projects/calendar-bar
cd ~/Projects/calendar-bar
./install.sh
```

Replace `<repo-url>` with this repository's address, which you'll find on its page under **Code → Clone**.

The installer:
- checks that everything from step 1 is installed, and runs a quick self-test;
- links the `calendar-bar` command into `~/.local/bin`;
- asks for your calendar address (see the next section). If you used the older `meetings.py` script, it copies the address from `~/.config/meetings/ics_url` for you.

It doesn't touch your polybar config. You add the module yourself in [Add it to polybar](#add-it-to-polybar).

## Get your calendar address

The installer asks for this. You can also run `calendar-bar set-url` at any time.

1. Open [Google Calendar](https://calendar.google.com/) in your browser.
2. Click **⚙ Settings** (top right) → **Settings**.
3. In the left sidebar, under **Settings for my calendars**, click your calendar (usually your name or email).
4. Click **Integrate calendar**.
5. Copy **Secret address in iCal format**. It starts with `https://calendar.google.com/calendar/ical/` and ends with `basic.ics`.
6. Paste it when `calendar-bar set-url` asks. The text is hidden while you paste.

It's saved to `~/.config/calendar-bar/ics_url`, which only you can read.

> ⚠ **The secret address lets anyone read your whole calendar.** Never commit it, paste it in chat, or share it. If it leaks, go back to **Integrate calendar** and click **Reset** next to it, then run `calendar-bar set-url` with the new one.

> Some work accounts have this address turned off by the admin. If you can't see **Secret address in iCal format**, ask your Google Workspace admin.

## Add it to polybar

1. Add the module to the end of your polybar config. The usual file is `~/.config/polybar/config.ini`. Use your own path if your config lives somewhere else.
   ```bash
   command cat ~/Projects/calendar-bar/polybar/calendar.ini >> ~/.config/polybar/config.ini
   ```
   Use `command cat`, not plain `cat`. If your shell aliases `cat` to something like `bat`, plain `cat` can freeze and write whatever you type next into your config.
2. In your `[bar/…]` section, add `calendar` to a modules list, for example next to the date:
   ```ini
   modules-right = … calendar date
   ```
3. Make sure one of the bar's fonts is a Nerd Font, so the icons show. If none is, add a font line using the next free number, for example:
   ```ini
   font-2 = "Symbols Nerd Font:size=11"
   ```
4. Restart polybar: `polybar-msg cmd restart`, or your usual launch script.

**Check it works:** `calendar-bar` in a terminal prints the same text as the bar, and left-clicking the module opens the popup.

## Everyday use

| To… | Do |
|---|---|
| See your next meeting | look at the bar (updates every minute) |
| See the whole day | left-click |
| Go to the previous / next day | `←` / `→` in the popup, or click `‹` / `›` |
| Jump to another date | *Pick a date* → month view (`←` `→` `↑` `↓` to move, `Page Up` / `Page Down` to change month, `Enter` to open the day). Underlined days have meetings |
| Join a meeting | click its **Join** row in the popup, or right-click the module when it's about to start |
| Open the day in Google Calendar | *Open in Google Calendar* in the popup, or click a meeting with no link |
| Close the popup | `Esc` |

Not shown: all-day events (holidays, out-of-office), cancelled meetings, and meetings you've declined.

## Setting it up on another computer / for someone else

Each person installs calendar-bar on their own computer and uses **their own** calendar address. Nothing is shared between people or computers.

1. Follow [Install](#install) on that computer.
2. When asked, paste the secret address from **that person's** Google Calendar ([Get your calendar address](#get-your-calendar-address)).
3. Follow [Add it to polybar](#add-it-to-polybar).

On a second computer of your own, you can paste the same address again. Run `calendar-bar set-url` there; don't copy files around.

**Not using polybar?** Any bar that can run a command and show its output can use it. Run `calendar-bar` every 60 seconds for the text, `calendar-bar menu` on click, and `calendar-bar join` to join. The colour codes (`%{F#…}`) are polybar's format, so other bars will show them as plain text.

## Update

```bash
cd ~/Projects/calendar-bar && git pull
./install.sh        # safe to run again
```

If `polybar/calendar.ini` changed, replace the `[module/calendar]` section in your polybar config with the new one.

## Uninstall

Run it from wherever you cloned the repo:

```bash
~/Projects/calendar-bar/uninstall.sh            # keeps your saved calendar address
~/Projects/calendar-bar/uninstall.sh --purge    # also deletes the address and cached calendar
```

It removes the `calendar-bar` link from `~/.local/bin`. Remove the `[module/calendar]` section and `calendar` from your polybar config yourself.

## Troubleshooting

| What you see | What to do |
|---|---|
| `󰃭 run: calendar-bar set-url` | No calendar address saved yet. Run `calendar-bar set-url` |
| Red `󰃭` | It couldn't download the calendar and has no saved copy. Check your internet, then run `calendar-bar refresh` to see the error |
| `calendar-bar: command not found` | `~/.local/bin` isn't on your `PATH` (see [Before you start](#before-you-start)) |
| `ModuleNotFoundError: recurring_ical_events` | Install `python-recurring-ical-events` (or `pip install --user recurring-ical-events`) |
| A meeting you just added isn't shown | Google updates the iCal feed with a delay (sometimes several minutes or more). Run `calendar-bar refresh` later |
| A meeting has no **Join** | Only Google Meet, Zoom and Teams links are detected, from the meeting's video call, location or description |
| Popup is too high, too low, or the text looks wrong | Set `CALENDAR_BAR_OFFSET` (pixels from the top, default `34`) or `CALENDAR_BAR_FONT` (default `CaskaydiaCove Nerd Font 10`) in `~/.profile`, then log out and back in |
| Icons show as boxes | Install a Nerd Font and add it to polybar (see [Add it to polybar](#add-it-to-polybar)) |
| Running `cat … >> config.ini` freezes | `cat` is aliased in your shell. Press `Ctrl+C`, remove any stray lines it added to the end of the file, and use `command cat` |

## How it works

```
Google Calendar (secret iCal address)
   │  downloaded at most every 2 minutes, when polybar runs `calendar-bar` (every 60 s)
   ▼
~/.cache/calendar-bar/calendar.ics  ──parsed──▶  ~/.cache/calendar-bar/events.json (60 days back, ~6 months ahead)
   ▼
bar text  ·  rofi popup  ·  join
```

If you're offline, it keeps using the last downloaded copy.

| File | What's in it |
|---|---|
| `bin/calendar-bar` | the whole thing: one Python script |
| `polybar/calendar.ini` | the polybar module to copy into your config |
| `~/.config/calendar-bar/ics_url` | your secret calendar address (private, `chmod 600`) |
| `~/.cache/calendar-bar/` | the downloaded calendar and parsed events |

### Commands

```bash
calendar-bar             # bar text
calendar-bar menu        # open the popup
calendar-bar join        # join the current / next meeting
calendar-bar set-url     # save or change your calendar address
calendar-bar refresh     # download the calendar now
calendar-bar selftest    # check the calendar parsing still works (prints "ok")
```

Optional settings (put them in `~/.profile`):

| Variable | Default | Effect |
|---|---|---|
| `CALENDAR_BAR_FONT` | `CaskaydiaCove Nerd Font 10` | popup font |
| `CALENDAR_BAR_OFFSET` | `34` | pixels from the top of the screen to the popup |
# calendar-bar
