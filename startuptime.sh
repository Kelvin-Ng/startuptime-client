#!/bin/bash 
# A simple tool to show the time taken to boot the OS (Linux with KDE and boot with systemd only)
# Author: qpalz, realasking, 九十钩圈凯_ @ tieba.biadu.com
# Original version: http://tieba.baidu.com/p/1959641775?pid=25913711903

outputtime()
{
	t_tmp=`echo $stmp` && let tmin=t_tmp/60 && let tsec=t_tmp%60
	if [ $tmin -gt 0 ]; then
		outpara="$tmin 分 $tsec 秒"
	else
		outpara="$t_tmp 秒"
	fi
}

outDS()
{
	DSession=`echo ${DESKTOP_SESSION}`
	if [ $DSession == "kde-plasma" ]; then
		dtmp=`kded4 -v|tail -n +2|head -n +1|cut -d"：" -f2`
		DSession=$DSession" 运行版本："$dtmp 
	fi
}

getmac()
{
	echo ifconfig | grep -o -E '([[:xdigit:]]{1,2}:){5}[[:xdigit:]]{1,2}'
}

getpos()
{
	wget -qO- "http://94.249.172.128/startuptime/getpos.php?time=$stt&mac=$(getmac)"
}

getnum()
{
	wget -qO- "http://94.249.172.128/startuptime/getnum.php"
}

if [ -z $_UTED ]; then
	stall=`cat /proc/uptime | cut -f1 -d'.'`
	stmp=`echo $stall`
	outputtime 
	outtpara=$outpara 
	#stt_tmp=`systemd-analyze | cut -d' ' -f13 | cut -d'm' -f1`
	stt_tmp=`systemd-analyze | cut -d' ' -f10 | cut -d'm' -f1`
	stt=`echo "$stt_tmp / 1000" | bc`
	stmp=`echo $stt` 
	outputtime
	outspara=$outpara
	stdesk=`echo "$stall - ${stt}" | bc`
	stmp=`echo $stdesk`
	outputtime
	outdpara=$outpara
	pos=$(getpos)
	num=$(getnum)
	percent=$(((num - pos) * 100 / num))
	outDS
	shopt -s nocasematch
	if [ "$LANG" == "zh_CN.utf8" ]; then
		notify-send "欢迎${LOGNAME}登录" "开机时间： ${outspara}
		进入桌面时间： ${outdpara}
		启动总耗时： ${outtpara}
		全球排名：${pos}/${num}
		击败了 ${percent}% 的电脑
		桌面： ${DSession}"
	elif [ "$LANG" == "zh_TW.utf8" ]; then
		notify-send "歡迎${LOGNAME}登錄" "開機時間： ${outspara}
		進入桌面時間： ${outdpara}
		啟動總耗時： ${outtpara}
		全球排名：${pos}/${num}
		擊敗了${percent}% 的電腦
		桌面： ${DSession}"
	else
		notify-send "Welcome ${LOGNAME}" "Time needed: ${outspara}
		Time needed to reach desktop: ${outdpara}
		Overall time needed: ${outtpara}
		Ranking: ${pos}/${num}
		Faster than ${percent}% computers
		Desktop using: ${DSession}"
	fi
	shopt -u nocasematch
fi
export _UTED=0
