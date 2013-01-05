#!/bin/bash 
#systemd 开机时间测试和显示脚本
#编写：realasking
#根据百度贴吧 九十钩圈凯_ 的看开机时间的脚本改进扩展得到
#他的原帖位置是：http://tieba.baidu.com/p/1959641775?pid=25913711903

outputtime(){
	t_tmp=`echo $stmp` && let tmin=t_tmp/60 && let tsec=t_tmp%60
	if [ $tmin -gt 0 ]; then
		outpara="$tmin 分 $tsec 秒"
	else
		outpara="$t_tmp 秒"
	fi
}

outDS(){
	DSession=`echo ${DESKTOP_SESSION}`
	if [ $DSession == "kde-plasma" ]; then
		dtmp=`kded4 -v|tail -n +2|head -n +1|cut -d"：" -f2`
		DSession=$DSession" 运行版本："$dtmp 
	fi
}

getpos()
{
	wget -qO- "http://94.249.172.128/startuptime/getpos.php?t=$stt"
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
	notify-send "欢迎${LOGNAME}登录" "开机时间： ${outspara}
	进入桌面时间： ${outdpara}
	启动总耗时： ${outtpara}
	全球排名：${pos}/${num}
	击败了 ${percent}% 的电脑
	桌面： ${DSession}"
fi
export _UTED=0
