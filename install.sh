#!/bin/sh
# install or uninstall startuptime-client

if [ "$1" == "-u" ]; then
	rm /usr/bin/startuptime.sh

	rm /usr/share/locale/zh_TW/LC_MESSAGES/startuptime.mo
	rm /usr/share/locale/zh_CN/LC_MESSAGES/startuptime.mo
else
	cp startuptime.sh /usr/bin

	msgfmt -o /usr/share/locale/zh_TW/LC_MESSAGES/startuptime.mo zh_TW/startuptime.po
	msgfmt -o /usr/share/locale/zh_CN/LC_MESSAGES/startuptime.mo zh_CN/startuptime.po
fi

