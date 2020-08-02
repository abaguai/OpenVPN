#!/bin/bash
clear
echo -e "请选择协议类型（本程序仅适用于fas系统）："
echo -e "1. TCP 代理端口"
echo -e "2. UDP 直连端口（将转发至53端口）"
read install_type

echo -n "请输入端口号(0-65535):"
read port


if [ $install_type == 1 ];then
	/root/res/proxy.bin -l $port -d
	read has < <(cat /etc/sysconfig/iptables | grep "tcp \-\-dport $port \-j ACCEPT" )
	if [ -z "$has" ];then
		iptables -A INPUT -p tcp -m tcp --dport $port -j ACCEPT
		service iptables save
		echo -e "[添加tcp $port 至防火墙白名单]"
	fi
	read has2 < <(cat /root/res/portlist.conf | grep "port $port tcp" )
	if [ -z "$has2" ];then
		echo -e "port $port tcp">>/root/res/portlist.conf
	fi
	echo -e "[已经成功添加代理端口]"
else
	read has < <(cat /etc/sysconfig/iptables | grep "udp \-\-dport $port \-j ACCEPT" )
	if [ -z "$has" ];then
		iptables -A INPUT -p udp -m udp --dport $port -j ACCEPT
		service iptables save
		echo -e "[添加tcp $port 至防火墙白名单]"
	fi
	iptables -t nat -A PREROUTING -p udp --dport $port -j REDIRECT --to-ports 53 && service iptables save
	echo -e "[已将此端口转发至53 UDP端口]"
fi
echo "感谢使用 再见！"
exit 0