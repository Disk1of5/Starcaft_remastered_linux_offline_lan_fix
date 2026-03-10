# Linux Starctraft Remastered Offline Lan Fix

Note: I survived a weekend of UDP MDNS headaches so you don't have to — read this, save time, and get to gaming.

## Table of Contents

- Overview
- Requirements
- Quick install
- Networking & Avahi debugging
- Disclaimer

---

## Overview

StarCraft: Remastered is great — until LAN refuses to play nice on Linux. The game's LAN discovery doesn't work out of the box under Wine because the small Windows helper that advertises lobbies isn't active in most prefixes. This repo is a short, practical guide that shows how to use Lutris with the `ge-proton` runner, place and run the included `lan_launcher.bat` / `ClientSdkMDNSHost.exe`, and use Avahi so your matches show up on the local network. It's concise, tested-ish, and get any LAN Party's back on track..

## Requirements

- Lutris
- Install StarCraft: Remastered via Lutris: https://lutris.net/games/starcraft-remastered/

- Construct Additional Pylons 😉

## Quick install
After you install the Battle.net dependency and StarCraft: Remastered via Lutris:

1. Duplicate the Lutris game entry and name the copy something like `StarCraft: Remastered Offline LAN` so the original entry remains unchanged.

2. Don't blindly run scripts you find on the internet — open and inspect `lan_launcher.bat` first. Yes, even this one. It’s short and harmless, and does exactly three things:

- Launches `StarCraft.exe -launch` (boots directly into the game without Battle.net)
- Waits ~4 seconds for the game/prefix to initialize
- Launches `ClientSdkMDNSHost.exe` (the mDNS helper that advertises the lobby)

3. Copy `lan_launcher.bat` into your Wine prefix where `StarCraft.exe` is located — typically inside `drive_c/Program Files (x86)/StarCraft/x86_64/` of your Lutris prefix. Use your file manager or terminal to place the file in that folder.

4. In Lutris, open the duplicated game's configuration:

- Set the runner to `GE-Proton Latest` in `Runner options`.
- In `Game options`, change the `Executable` (command) to the batch file inside the prefix, for example:

```
.../drive_c/Program Files (x86)\StarCraft\x86_64\lan_launcher.bat
```

Right-click the game's entry in Lutris, open the Wine runner menu and click "Winetricks". Select the default wine prefix, choose "Install a Windows DLL or component", then install Microsoft's "vcrun2015".

5. Save and run the entry to test. The batch file should start the game, then the mDNS host helper to advertise the lobby.


## Networking & Avahi debugging

Use Avahi to verify the game is advertising its lobby via mDNS. On a Linux machine on the same LAN run:

```bash
avahi-browse -a
```

You should see your machine/username listed and an entry for a Blizzard/StarCraft service such as `_blizzard._udp`. That indicates the `ClientSdkMDNSHost.exe` (or an equivalent service) is successfully broadcasting the game on the local network.

Quick checks:

- Check Avahi is running:

```bash
avahi-browse -a    # look for a _blizzard._udp entry from the host
systemctl status avahi-daemon
```

- If Avahi or MDNS support is missing (Debian/Ubuntu example):

```bash
sudo apt update
sudo apt install avahi-daemon libnss-mdns
sudo systemctl enable --now avahi-daemon
```

- Quick home fixes: ensure both machines use the same Wi‑Fi SSID or are on the same router (Ethernet), disable any "guest" or "AP isolation" options, and try restarting the router if discovery seems stuck.

- Advanced: if players must be on different subnets/VLANs, you'll need to enable mDNS/multicast forwarding or an mDNS reflector between networks — that's a more advanced network change and usually unnecessary for common home setups.

If `avahi-browse -a` shows `_blizzard._udp` on the host but other clients don't see it, collect logs and continue to the Troubleshooting checklist.


## Disclaimer

This was a weekend of troubleshooting and a labour of love to teach my family StarCraft. Use this as-is — I take no responsibility for your system. Follow the steps at your own risk and feel free to open an issue if something breaks.

Also: I take absolutely no responsibility if you lose to your friends' 4-pool zerg rushes — learn to micro and build a defense. 😂


