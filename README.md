# StartUpTime

A simple tool to show the time taken to boot the OS and compare your time with others

## Screenshot

<img src="screenshot.png">

## Install

Dependencies: bash bc

### Arch Linux

Download the package at [AUR](https://aur.archlinux.org/packages/startuptime)

### Other distributions

You can use it before installation without i18n support.

To install, use this command:

	sudo bash ./install.sh

Use this command to uninstall:

	sudo bash ./install.sh -u

## Configuration

### Systemd

- Add <code>startuptime.sh</code> to your autostart configuration file.

### Sysvinit

- Add <code>startuptime.sh</code> to your autostart configuration file.

- Add <code>uptime-record.sh</code> to <code>/etc/rc.local</code> or <code>~/.xprofile</code>

- Enable sysvinit at <code>/etc/startuptime.conf</code>