#!/bin/bash
# install or uninstall startuptime-client

if [ "$1 " == "-u " ]; then
	rm /etc/startuptime.conf
	rm /usr/bin/startuptime.sh
	rm /usr/bin/uptime-record.sh

	rm /usr/share/locale/zh_TW/LC_MESSAGES/startuptime.mo
	rm /usr/share/locale/zh_CN/LC_MESSAGES/startuptime.mo
else
	install -D -m744 startuptime.conf /etc
	install -D -m755 startuptime.sh /usr/bin
	install -D -m755 uptime-record.sh /usr/bin

	msgfmt -o /usr/share/locale/zh_TW/LC_MESSAGES/startuptime.mo LC_MESSAGES/zh_TW/startuptime.po
	msgfmt -o /usr/share/locale/zh_CN/LC_MESSAGES/startuptime.mo LC_MESSAGES/zh_CN/startuptime.po
fi

