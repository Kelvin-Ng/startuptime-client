#StartUpTime

A simple tool to show the time taken to boot the OS and compare your time with others (Linux boot with systemd only)

## Configuration BEFORE installation

The method to get the boot time is different for those who use initrd and not. Set whether you use initrd or not by modifying the script. If you use initrd, open startuptime.sh by `vim startuptime.sh` or using other editors, then you will see `use_initrd=` at line 8. Change it to be `use_initrd=yes` and save it. For those who do not use initrd, nothing need to be done.

##Install

You can use it before installation but there will not be i18n.

To install, use this command:

	sudo ./install.sh

Use this command to uninstall:

	sudo ./install.sh -u

