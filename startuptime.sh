#!/bin/bash 
# A simple tool to show the time taken to boot the OS (Linux with KDE and boot with systemd only)
# Author: qpalz, realasking, 九十钩圈凯_ @ tieba.biadu.com
# Original version: http://tieba.baidu.com/p/1959641775?pid=25913711903

TEXTDOMAIN=startuptime

ver=5

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
	wget -qO- "http://startuptime.qpalz.tk/getpos.php?time=$bootTime&mac=$(getmac)"
}

getnum()
{
	wget -qO- "http://startuptime.qpalz.tk/getnum.php"
}

checkUpdate()
{
	latest_ver=`wget -qO- "http://startuptime.qpalz.tk/client_ver.html"`
	if [ $latest_ver -gt $ver ]; then
		notify-send $"StartUpTime Update" \
			$"Please update to v""$latest_ver""
""<a href=\"https://github.com/Kelvin-Ng/startuptime-client/archive/v${latest_ver}.tar.gz\">"$"Download""</a>"
	fi
}

checkUpdate

uptime=`cat /proc/uptime | cut -f1 -d'.'`
outUptime=$(formatTime $uptime)
bootTime_tmp=`systemd-analyze | cut -d' ' -f13`
if [ -z "$bootTime_tmp" ]; then
	bootTime_tmp=`systemd-analyze | cut -d' ' -f10`
fi
bootTime_tmp=`echo $bootTime_tmp | cut -d'm' -f1`
bootTime=$((bootTime_tmp / 1000))
outBootTime=$(formatTime $bootTime)
desktopTime=$(($uptime - $bootTime))
outDesktopTime=$(formatTime desktopTime)
pos=$(getpos)
num=$(getnum)
if [ $pos -gt $num ]; then
	pos=$num
fi
percent=$(((num - pos) * 100 / num))
outDS
notify-send $"Welcome""${LOGNAME}" $"Time needed: ""${outBootTime}\n"\
$"Time needed to reach desktop: ""${outDesktopTime}\n"\
$"Overall time needed: ""${outUptime}\n"\
$"Ranking: ""${pos}/${num}\n"\
$"Faster than"" ${percent}"$"% computers""\n"\
$"Desktop using: ""${DSession}\n"
