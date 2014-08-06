#!/bin/bash 
# A simple tool to show the time taken to boot the OS (Linux boot with systemd only)
# Author: qpalz, realasking, 九十钩圈凯_ @ tieba.biadu.com
# Original version: http://tieba.baidu.com/p/1959641775?pid=25913711903

TEXTDOMAIN=startuptime

SERVER_URL="http://startuptime.poker-lee.tk" # do not need the trailing '/'
ver=7

formatTime()
{
	min=$(bc <<< "$1 / 60")
	sec=$(bc <<< "$1 % 60")
	if [ $min -gt 0 ]; then
		echo "$min "$"mins"" $sec "$"secs"
	else
		echo "$sec "$"secs"
	fi
}

getmac()
{
	ifconfig | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'
}

getpos()
{
	wget -qO- "${SERVER_URL}/getpos.php?time=$bootTime&mac=$(getmac)"
}

checkUpdate()
{
	latest_ver=`wget -qO- "${SERVER_URL}/client_ver.html"`
	if [ $latest_ver -gt $ver ]; then
		notify-send $"StartUpTime Update" \
			$"Please update to v""$latest_ver""
""<a href=\"https://github.com/Kelvin-Ng/startuptime-client/archive/v${latest_ver}.tar.gz\">"$"Download""</a>"
	fi
}

checkUpdate

uptime=`cat /proc/uptime | cut -d' ' -f1`
outUptime=$(formatTime $uptime)

bootTime_str=`systemd-analyze | grep -o '= .*$'`
bootTime_min=`echo $bootTime_str | grep -o '[0-9,\.]*min'`
if [ -z "$bootTime_min" ]; then
	bootTime_min=0
else
	bootTime_min=`echo $bootTime_min | grep -o '[0-9,\.]*'`
fi
bootTime_sec=`echo $bootTime_str | grep -o '[0-9,\.]*s'`
bootTime_sec=`echo $bootTime_sec | grep -o '[0-9,\.]*'`
bootTime=$(bc <<< "scale=3; $bootTime_min * 60 + $bootTime_sec")

outBootTime=$(formatTime $bootTime)
desktopTime=$(bc <<< "scale=3; $uptime - $bootTime")
outDesktopTime=$(formatTime $desktopTime)

outPos=$(getpos)
pos=`echo $outPos | cut -d'/' -f1`
num=`echo $outPos | cut -d'/' -f2`
percent=$(bc <<< "($num - $pos) * 100 / $num")

notify-send $"Welcome ""${LOGNAME}" $"Time needed: ""${outBootTime}\n"\
$"Time needed to reach desktop: ""${outDesktopTime}\n"\
$"Overall time needed: ""${outUptime}\n"\
$"Ranking: ""${outPos}\n"\
$"Faster than"" ${percent}"$"% computers""\n"
