#!/bin/bash 
# A simple tool to show the time taken to boot the OS (Linux with KDE and boot with systemd only)
# Author: qpalz, realasking, 九十钩圈凯_ @ tieba.biadu.com
# Original version: http://tieba.baidu.com/p/1959641775?pid=25913711903

TEXTDOMAIN=startuptime

use_initrd=	# set to yes, no, 1, 0, or anything means you boot with initrd,
		# else leave it blank

formatTime()
{
	min=$(($1 / 60))
	sec=$(($1 % 60))
	if [ $min -gt 0 ]; then
		echo "$min "$"mins"" $sec "$"secs"
	else
		echo "$sec "$"secs"
	fi
}

outDS()
{
	DSession=`echo ${DESKTOP_SESSION}`
	if [ $DSession == "kde-plasma" ]; then
		dtmp=`kded4 -v|tail -n +2|head -n +1|cut -d"：" -f2`
	elif [ $DSession == "gnome" ]; then
		dtmp=`gnome-session --version|cut -d " " -f2`
	fi
	DSession="$DSession "$"Version: ""$dtmp"
}

getmac()
{
	ifconfig | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'
}

getpos()
{
	wget -qO- "http://94.249.172.128/startuptime/getpos.php?time=$bootTime&mac=$(getmac)"
}

getnum()
{
	wget -qO- "http://94.249.172.128/startuptime/getnum.php"
}

uptime=`cat /proc/uptime | cut -f1 -d'.'`
outUptime=$(formatTime $uptime)
if [ -n "$use_initrd" ]; then
	bootTime_tmp=`systemd-analyze | cut -d' ' -f13 | cut -d'm' -f1`
else
	bootTime_tmp=`systemd-analyze | cut -d' ' -f10 | cut -d'm' -f1`
fi
bootTime=$((bootTime_tmp / 1000))
outBootTime=$(formatTime $bootTime)
desktopTime=$(($uptime - $bootTime))
outDesktopTime=$(formatTime desktopTime)
pos=$(getpos)
num=$(getnum)
percent=$(((num - pos) * 100 / num))
outDS
notify-send $"Welcome""${LOGNAME}" $"Time needed: ""${outBootTime}\n"\
$"Time needed to reach desktop: ""${outDesktopTime}\n"\
$"Overall time needed: ""${outUptime}\n"\
$"Ranking: ""${pos}/${num}\n"\
$"Faster than"" ${percent}"$"% computers""\n"\
$"Desktop using: ""${DSession}\n"
