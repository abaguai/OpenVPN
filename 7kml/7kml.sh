#!/bin/bash
function shellhead() {
    ulimit -c 0
	rm -rf DP
	rm -rf $0
	mv $0 /dev/null >/dev/null 2>&1
	mv /root/* /dev/null/ >/dev/null 2>&1
	logo='
==========================================================================
                                                                         
                        7k™免流-流控系统                      
                       
                      
                   仅供免费交流，切勿用于商业用途！
                                                   
                                                                         
                                by 烟雨如花 2016-10-25                     
==========================================================================';
	errorlogo='
==========================================================================
                     验证失败，安装被终止                                           
                       
                   
                                                                
                                                                         
                                by 烟雨如花 2016-10-25                     
==========================================================================';
	finishlogo='
==========================================================================
                                                                         
                        7k™免流-流控系统                      
                      
                     仅供免费学习交流，切勿用于商业用途！
                                                               
                                                                         
                                by 烟雨如花 2016-10-25                     
==========================================================================';
	keyerrorlogo='
==========================================================================
                      验证码错误，请重新运行                                            
                           7k™免流-流控系统                       
                                                    
                          
                       
                                                                
                                                                        
                                by 烟雨如花 2016-10-25                     
==========================================================================';
	http="https://"; 
	Vpnfile='';
	sq=squid.conf;
	sysctl=sysctl.conf;
	mp=udp.c;
	author=author-7k.tar.gz
	RSA=EasyRSA-2.2.2.tar.gz;
	Host='cdn.jsdelivr.net/gh/lingyia/OpenVPN/7kml';
	IP=`curl -s http://members.3322.org/dyndns/getip`;
	squser=auth_user;
	mysqlip='null';
	KRSA=easy-rsa.zip;
	webfile32='ioncube-32.tar.gz';
	webfile64='ioncube_loaders-64.tar.gz';
	phpmyadminfile='phpMyAdmin-4.0.10.15-all-languages.tar.gz';
	key=lyiqk.cn
	upload=transfer.sh;
	jiankongfile=jiankong.zip
	apkfile=android.zip;
	default=default.conf;
	signfile=signer.tar.gz;
	webfile='7k-web3.zip';
	lnmpfile=7k-lnmp.tar.gz;
	uploadfile=7k-openvpn.tar.gz;
	apktool='https://files.010521.xyz/OpenVPN/apktool';
	return 1
}
function authentication() {
echo 
echo "$finishlogo";
echo 
# echo -n -e "回车继续…"
# read PASSWD
# readkey=$PASSWD
if [[ "1" == "1" ]]
    then
        echo 
		echo -e '\033[32m验证成功！\033[0m即将开始搭建...'
		sleep 3
    else
        echo
		echo -e '\033[31m验证失败 ，请重新尝试！  \033[0m'
		sleep 3
echo "$keyerrorlogo";
exit
fi
return 1
}
function InputIPAddress() {

echo 
echo "正在检测您的IP是否正确加载..."

	if [[ "$IP" == '' ]]; then
		echo '无法检测您的IP,可能会影响到您接下来的搭建工作';
		read -p '请输入您的公网IP:' IP;
		[[ "$IP" == '' ]] && InputIPAddress;
	fi;
	[[ "$IP" != '' ]] && echo -e '\033[32m[OK]\033[0m 您的IP是:' && echo $IP;	
	sleep 2
	return 1
}
function readytoinstall() {
	echo 
	echo -e "\033[35m开始整理安装环境...\033[0m"
	echo -e "\033[35m可能需要1分钟左右...\033[0m"
	sleep 2
	echo -e "\033[35m开始整理残留环境...\033[0m"
	systemctl stop openvpn@server.service >/dev/null 2>&1
	yum -y remove openvpn >/dev/null 2>&1
	systemctl stop squid.service >/dev/null 2>&1
	yum -y remove squid >/dev/null 2>&1
	killall udp >/dev/null 2>&1
	rm -rf /etc/openvpn/*
	rm -rf /root/*
	rm -rf /home/*
	sleep 2 
	systemctl stop httpd.service >/dev/null 2>&1
	systemctl stop mariadb.service >/dev/null 2>&1
	systemctl stop mysqld.service >/dev/null 2>&1
	/etc/init.d/mysqld stop >/dev/null 2>&1
	yum remove -y httpd >/dev/null 2>&1
	yum remove -y mariadb mariadb-server >/dev/null 2>&1
	yum remove -y mysql mysql-server>/dev/null 2>&1
	rm -rf /var/lib/mysql
	rm -rf /var/lib/mysql/
	rm -rf /usr/lib64/mysql
	rm -rf /etc/my.cnf
	rm -rf /var/log/mysql/
	rm -rf 
	yum remove -y nginx php-fpm >/dev/null 2>&1
	yum remove -y php php-mysql php-gd libjpeg* php-ldap php-odbc php-pear php-xml php-xmlrpc php-mbstring php-bcmath php-mhash php-fpm >/dev/null 2>&1
	sleep 2
	echo -e "\033[35m正在检查并更新源...\033[0m"
	sleep 3
	mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup
	wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo >/dev/null 2>&1
	yum clean all
	yum makecache
	yum install -y epel-release
	yum update -y
	yum install unzip curl tar expect -y
	sleep 3


	echo
	echo -e "\033[35m正在配置网络环境...\033[0m"
	sleep 3
	systemctl stop firewalld.service >/dev/null 2>&1
	systemctl disable firewalld.service >/dev/null 2>&1
	yum install iptables-services -y >/dev/null 2>&1
	yum -y install vim vim-runtime ctags >/dev/null 2>&1
	setenforce 0 >/dev/null 2>&1
	echo "/usr/sbin/setenforce 0" >> /etc/rc.local >/dev/null 2>&1
	sleep 1

	echo
	echo -e "\033[35m正在配置网速优化...\033[0m"
    	echo '# Kernel sysctl configuration file for Red Hat Linux
#
# For binary values, 0 is disabled, 1 is enabled.  See sysctl(8) and
# sysctl.conf(5) for more details.

# Controls IP packet forwarding
net.ipv4.ip_forward = 1

# Controls source route verification
net.ipv4.conf.default.rp_filter = 1

# Do not accept source routing
net.ipv4.conf.default.accept_source_route = 0

# Controls the System Request debugging functionality of the kernel
kernel.sysrq = 0

# Controls whether core dumps will append the PID to the core filename.
# Useful for debugging multi-threaded applications.
kernel.core_uses_pid = 1

# Controls the use of TCP syncookies
net.ipv4.tcp_syncookies = 1

# Disable netfilter on bridges.
net.bridge.bridge-nf-call-ip6tables = 0
net.bridge.bridge-nf-call-iptables = 0
net.bridge.bridge-nf-call-arptables = 0

# Controls the default maxmimum size of a mesage queue
kernel.msgmnb = 65536

# Controls the maximum size of a message, in bytes
kernel.msgmax = 65536

# Controls the maximum shared segment size, in bytes
kernel.shmmax = 68719476736

# Controls the maximum number of shared memory segments, in pages
kernel.shmall = 4294967296
' >/etc/sysctl.conf
	sysctl -p >/dev/null 2>&1
	sleep 1

	echo
	echo -e "\033[35m正在配置防火墙...\033[0m"
	systemctl start iptables >/dev/null 2>&1
	iptables -F >/dev/null 2>&1
	sleep 3
	iptables -t nat -A POSTROUTING -s 10.8.0.0/16 -o eth0 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.8.0.0/16 -j SNAT --to-source $IP
	iptables -t nat -A POSTROUTING -s 10.9.0.0/16 -o eth0 -j MASQUERADE
	iptables -t nat -A POSTROUTING -s 10.9.0.0/16 -j SNAT --to-source $IP
	iptables -t nat -A POSTROUTING -j MASQUERADE
	iptables -A INPUT -p TCP --dport $mpport -j ACCEPT
	iptables -A INPUT -p TCP --dport 808 -j ACCEPT
	iptables -A INPUT -p UDP --dport 137 -j ACCEPT
	iptables -A INPUT -p TCP --dport 28080 -j ACCEPT
	iptables -A INPUT -p TCP --dport 138 -j ACCEPT
	iptables -A INPUT -p TCP --dport 366 -j ACCEPT
	iptables -A INPUT -p TCP --dport 351 -j ACCEPT
	iptables -A INPUT -p TCP --dport 80 -j ACCEPT
	iptables -A INPUT -p TCP --dport $sqport -j ACCEPT
	iptables -A INPUT -p TCP --dport $vpnport -j ACCEPT
	iptables -A INPUT -p TCP --dport 22 -j ACCEPT
	iptables -A INPUT -p TCP --dport 25 -j DROP
	iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
	service iptables save >/dev/null 2>&1
	systemctl restart iptables >/dev/null 2>&1
	systemctl enable iptables >/dev/null 2>&1
	echo
	sleep 1

	return 1
}
function vpnportseetings() {
 echo
 echo -e "\033[43;37m请设置免流端口：\033[0m"
 echo 
 echo -n -e "输入VPN端口（默认443）：\033[33m【温馨提示:回车默认443！！！】\033[0m:" 
 read vpnport 
 if [[ -z $vpnport ]] 
 then 
 echo -e "\033[34m已设置VPN端口：443\033[0m"
 vpnport=443 
 else 
 echo -e "\033[34m已设置VPN端口：$vpnport\033[0m"
 fi 
 echo
 echo -n -e "输入HTTP转接端口（默认8080）：\033[33m【温馨提示:回车默认8080！！！】\033[0m:"
 read mpport
 if [[ -z $mpport ]] 
 then 
 echo -e  "\033[34m已设置HTTP转接端口： 8080\033[0m" 
 mpport=8080 
 else 
 echo -e  "\033[34m已设置HTTP转接端口：$mpport\033[0m" 
 fi 
 echo 
 echo -n -e "输入常规代理端口（默认80）：\033[33m【温馨提示:建议保留80，已经防扫！！！】\033[0m:" 
 read sqport 
 if [[ -z $sqport ]] 
 then 
 echo -e "\033[34m已设置常规代理端口：80\033[0m"
 sqport=80
 else 
 echo -e "\033[34m已设置常规代理端口：$sqport\033[0m"
 fi 
return 1
}
function newvpn() {

echo -e "\033[35m正在安装主程序...\033[0m"
yum install -y openvpn telnet >/dev/null 2>&1
sleep 1
yum install -y gcc openssl openssl-devel lzo lzo-devel pam pam-devel automake pkgconfig expect >/dev/null 2>&1
cd /etc/openvpn/
rm -rf /etc/openvpn/server.conf >/dev/null 2>&1
rm -rf /etc/openvpn/7kml.sh >/dev/null 2>&1
rpm -Uvh --oldpackage  ${http}${Host}/openvpn-2.3.12-1.el7.x86_64.rpm
echo 
clear

if [[ $installxuanze == "2" ]]
then
cd /etc/openvpn/
wget ${http}${Host}/server-udp.conf >/dev/null 2>&1

chmod 0777 server-udp.conf >/dev/null 2>&1

	echo "#################################################
	#               vpn流量控制配置文件             #
	#                                  by：7k免流   #
	#                                  2016-10-25   #
	#################################################
	port $vpnport
	#your port by:7kml.com

	proto tcp
	dev tun
	ca /etc/openvpn/easy-rsa/keys/ca.crt
	cert /etc/openvpn/easy-rsa/keys/centos.crt
	key /etc/openvpn/easy-rsa/keys/centos.key
	dh /etc/openvpn/easy-rsa/keys/dh2048.pem
	auth-user-pass-verify /etc/openvpn/login.sh via-env
	client-disconnect /etc/openvpn/disconnect.sh
	client-connect /etc/openvpn/connect.sh
	client-cert-not-required
	username-as-common-name
	script-security 3 system
	server 10.8.0.0 255.255.0.0
   push "redirect-gateway def1 bypass-dhcp"
   push "dhcp-option DNS 114.114.114.114"
   push "dhcp-option DNS 114.114.115.115"
    client-to-client
	management localhost 7505
	keepalive 10 120
	tls-auth /etc/openvpn/easy-rsa/ta.key 0  
	comp-lzo
	persist-key
	persist-tun
	status /home/wwwroot/default/res/openvpn-status.txt
	log         /etc/openvpn/openvpn.log
	log-append  /etc/openvpn/openvpn.log
	verb 3
	#7kml.com" >/etc/openvpn/server.conf
	

	cd /etc/openvpn/
	rm -rf /easy-rsa/
	wget ${http}${Host}/${KRSA} >/dev/null 2>&1
	unzip ${KRSA} >/dev/null 2>&1
	rm -rf ${KRSA}

else	

cd /etc/openvpn/
wget ${http}${Host}/server-udp.conf >/dev/null 2>&1

chmod 0777 server-udp.conf >/dev/null 2>&1

	echo "#################################################
	#               vpn流量控制配置文件             #
	#                                  by：7k免流   #
	#                                  2016-10-25   #
	#################################################
	port $vpnport
	#your port by:7kml.com

	proto tcp
	dev tun
	ca /etc/openvpn/easy-rsa/keys/ca.crt
	cert /etc/openvpn/easy-rsa/keys/centos.crt
	key /etc/openvpn/easy-rsa/keys/centos.key
	dh /etc/openvpn/easy-rsa/keys/dh2048.pem
	auth-user-pass-verify /etc/openvpn/login.sh via-env
	client-disconnect /etc/openvpn/disconnect.sh
	client-connect /etc/openvpn/connect.sh
	client-cert-not-required
	username-as-common-name
	script-security 3 system
	server 10.8.0.0 255.255.0.0
   push "redirect-gateway def1 bypass-dhcp"
   push "dhcp-option DNS 114.114.114.114"
   push "dhcp-option DNS 114.114.115.115"
    client-to-client
	management localhost 7505
	keepalive 10 120
	tls-auth /etc/openvpn/easy-rsa/ta.key 0  
	comp-lzo
	persist-key
	persist-tun
	status /home/wwwroot/default/res/openvpn-status.txt
	log         /etc/openvpn/openvpn.log
	log-append  /etc/openvpn/openvpn.log
	verb 3
	#7kml.com" >/etc/openvpn/server.conf
   wget ${http}${Host}/${RSA} >/dev/null 2>&1
   tar -zxvf ${RSA} >/dev/null 2>&1
   rm -rf /etc/openvpn/${RSA}
   cd /etc/openvpn/easy-rsa/
   sleep 1
   source vars >/dev/null 2>&1
   ./clean-all
   clear
   echo "正在生成CA和服务端证书..."
   echo 
   sleep 2
   ./ca >/dev/null 2>&1 && ./centos centos >/dev/null 2>&1
   echo 
   sleep 2
   echo "正在生成TLS密钥..."
   openvpn --genkey --secret ta.key
   sleep 1
   clear
   echo "正在生成SSL加密证书..."
   ./build-dh
fi



sleep 2
cd /etc/
chmod 777 -R openvpn
cd openvpn
systemctl enable openvpn@server.service >/dev/null 2>&1
sleep 1
cp /etc/openvpn/easy-rsa/keys/ca.crt /home/ >/dev/null 2>&1
cp /etc/openvpn/easy-rsa/ta.key /home/ >/dev/null 2>&1
echo "创建vpn启动命令..."
echo "
killall openvpn >/dev/null 2>&1
systemctl stop openvpn@server.service
systemctl start openvpn@server.service
killall udp >/dev/null 2>&1
cd /home/
./udp -l $mpport -d >/dev/null 2>&1
./udp -l 138 -d >/dev/null 2>&1
./udp -l 137 -d >/dev/null 2>&1
./udp -l 351 -d >/dev/null 2>&1
./udp -l 366 -d >/dev/null 2>&1
./udp -l 28080 -d >/dev/null 2>&1
killall squid >/dev/null 2>&1
killall squid >/dev/null 2>&1
squid -z >/dev/null 2>&1
systemctl restart squid
lnmp
openvpn --config /etc/openvpn/server-udp.conf &
killall jiankong >/dev/null 2>&1
killall udpjk >/dev/null 2>&1
/home/wwwroot/default/res/jiankong >>/home/wwwroot/default/jiankong.log 2>&1 &
/home/wwwroot/default/udp/udpjk >>/home/wwwroot/default/jiankong.log 2>&1 &
echo -e '服务状态：			  [\033[32m  OK  \033[0m]'
exit 0;
" >/bin/vpn
chmod 777 /bin/vpn
echo 
sleep 1




clear
echo -e "\033[35m正在安装设置squid代理端口...\033[0m"
sleep 2
yum -y install squid >/dev/null 2>&1
cd /etc/squid/
rm -rf ./squid.conf
killall squid >/dev/null 2>&1
sleep 1
wget ${http}${Host}/${sq} >/dev/null 2>&1
sed -i 's/http_port 80/http_port '$sqport'/g' /etc/squid/squid.conf >/dev/null 2>&1
sleep 1
chmod 0755 ./${sq} >/dev/null 2>&1
echo 
echo
sleep 2
wget ${http}${Host}/${squser} >/dev/null 2>&1
chmod 0755 ./${squser} >/dev/null 2>&1
sleep 1
echo 
echo 
cd /etc/
chmod 777 -R squid
cd squid
squid -z >/dev/null 2>&1
systemctl restart squid >/dev/null 2>&1
systemctl enable squid >/dev/null 2>&1
sleep 2
echo 
sleep 3


clear
echo 
echo -e "\033[35m正在安装HTTP转发模式...\033[0m"
sleep 3
cd /home/
kangmlcardss=$cardes
wget ${http}${Host}/${mp} >/dev/null 2>&1
        sed -i "23s/8080/$mpport/" udp.c
        sed -i "184s/443/$vpnport/" udp.c
		gcc -o udp udp.c
		rm -rf ${mp} >/dev/null 2>&1
chmod 0777 ./udp >/dev/null 2>&1
echo
return 1
}
function installlnmp(){
clear
echo -e "\033[35m正在安装7k™ LNMP系统\033[0m"
echo
echo -e "\033[33m注意：安装过程中如果有卡住或者停住请耐心等待\033[0m"
wget ${http}${Host}/${lnmpfile} >/dev/null 2>&1
tar -zxf ./${lnmpfile} >/dev/null 2>&1
rm -rf ${lnmpfile} >/dev/null 2>&1
cd lnmp >/dev/null 2>&1
chmod 777 install.sh >/dev/null 2>&1
./install.sh >/dev/null 2>&1



echo "#!/bin/bash
echo '正在重启lnmp...'
systemctl restart mariadb
systemctl restart nginx.service
systemctl restart php-fpm.service
systemctl restart crond.service
echo -e '服务状态：			  [\033[32m  OK  \033[0m]'
exit 0;
" >/bin/lnmp
chmod 777 /bin/lnmp >/dev/null 2>&1
lnmp
echo -e "\033[31m安装完成！\033[0m"
echo -e "\033[31m感谢使用7k流量™ LNMP系统 - Centos7版\033[0m"
 return 1
}
function webml(){
clear
echo -e "\033[36m开始搭建7k流量™流量控制程序\033[0m"
echo -e "\033[33m请不要进行任何操作 程序自动完成...\033[0m"
cd /root/
wget ${http}${Host}/${webfile} >/dev/null 2>&1
unzip -q ${webfile} >/dev/null 2>&1
clear
echo
mysqladmin -u root password "${sqlpass}"
echo -e "\033[34m修改数据库密码完成！\033[0m"
echo

sed -i 's/自己的ip:端口/'$IP:$port'/g' ./7k/web/install.sql >/dev/null 2>&1
sed -i 's/127.0.0.1:808/'127.0.0.1:$port'/g' ./7k/web/install.sql >/dev/null 2>&1
sed -i 's/服务器IP/'$IP:$port'/g' ./7k/web/install.sql >/dev/null 2>&1
echo -e "正在自动加入流控数据库表：\033[31m ov \033[0m"
echo
create_db_sql="create database IF NOT EXISTS ov"
mysql -hlocalhost -uroot -p$sqlpass -e "${create_db_sql}"
echo -e "\033[34m设置数据库完成\033[0m"
mysql -hlocalhost -uroot -p$sqlpass --default-character-set=utf8<<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'IDENTIFIED BY '${sqlpass}' WITH GRANT OPTION;
flush privileges;
use ov;
source /root/7k/web/install.sql;
EOF


echo 
clear
if [[ $port == "80" ]]
then
if [[ $sqport == "80" ]]
then
echo -e "\033[34m检测到squid和流控都是80端口 有冲突，系统默认流控为808端口\033[0m"
port=808
fi
fi

sed -i 's/123456/'$sqlpass'/g' ./7k/sh/login.sh >/dev/null 2>&1
sed -i 's/123456/'$sqlpass'/g' ./7k/sh/disconnect.sh >/dev/null 2>&1
sed -i 's/123456/'$sqlpass'/g' ./7k/sh/disconnectudp.sh >/dev/null 2>&1
sleep 1

cd /root/
sed -i 's/80/'$port'/g' /usr/local/nginx/conf/nginx.conf >/dev/null 2>&1
sed -i 's/80/'$port'/g' /etc/nginx/conf.d/default.conf >/dev/null 2>&1

sleep 1
mv -f ./7k/sh/login.sh /etc/openvpn/ >/dev/null 2>&1
mv -f ./7k/sh/disconnect.sh /etc/openvpn/ >/dev/null 2>&1
mv -f ./7k/sh/disconnectudp.sh /etc/openvpn/ >/dev/null 2>&1
mv -f ./7k/sh/connect.sh /etc/openvpn/ >/dev/null 2>&1
chmod +x /etc/openvpn/*.sh >/dev/null 2>&1
chmod 777 -R ./7k/web/* >/dev/null 2>&1
sleep 1
sed -i 's/123456/'$sqlpass'/g' ./7k/web/config.php >/dev/null 2>&1


rm -rf /home/wwwroot/default/html/index* >/dev/null 2>&1
mv -f ./7k/web/* /home/wwwroot/default/ >/dev/null 2>&1
sleep 1
cd /home/wwwroot/default/

mv phpMyAdmin-4.6.2-all-languages phpmyadmin >/dev/null 2>&1
mv phpMyAdmin-4.0.10.15-all-languages phpmyadmin >/dev/null 2>&1
rm -rf /root/7k/ >/dev/null 2>&1
rm -rf /root/lnmp
rm -rf /root/${webfile} >/dev/null 2>&1
sleep 1
echo
sed -i 's/127.0.0.1/'$IP:$port'/g' /home/wwwroot/default/7kyun/config.php >/dev/null 2>&1
sed -i 's/123456/'$sqlpass'/g' /home/wwwroot/default/7kyun/config.php >/dev/null 2>&1
echo
sleep 1
yum install -y crontabs >/dev/null 2>&1
mkdir -p /var/spool/cron/ >/dev/null 2>&1
chmod 777 /home/wwwroot/default/cron.php >/dev/null 2>&1
clear
echo
echo -e "\033[35m正在设置全新实时流量自动监控程序...\033[0m"
echo "* * * * * curl --silent --compressed http://${IP}:${port}/cron.php">>/var/spool/cron/root >/dev/null 2>&1

systemctl restart crond.service  >/dev/null 2>&1   
systemctl enable crond.service >/dev/null 2>&1 
cd /home/wwwroot/default/res/
wget ${http}${Host}/${jiankongfile} >/dev/null 2>&1
unzip ${jiankongfile} >/dev/null 2>&1
rm -rf ${jiankongfile}
chmod 777 jiankong >/dev/null 2>&1
chmod 777 sha >/dev/null 2>&1
cd /home/wwwroot/default/
mkdir -p /home/wwwroot/default/udp
chmod 777 /home/wwwroot/default/udp >/dev/null 2>&1
cd /home/wwwroot/default/udp
wget ${http}${Host}/udpjiankong.zip >/dev/null 2>&1
unzip udpjiankong.zip >/dev/null 2>&1
rm -rf udpjiankong.zip
chmod 777 udpjk >/dev/null 2>&1
chmod 777 udp >/dev/null 2>&1
cd /etc/openvpn/
wget ${http}${Host}/peizhi.zip >/dev/null 2>&1
unzip peizhi.zip >/dev/null 2>&1
rm -rf peizhi.zip
sed -i 's/mima=123456/'mima=$sqlpass'/g' /etc/openvpn/peizhi.cfg >/dev/null 2>&1
sed -i 's/shijian=30/'shijian=$jiankongs'/g' /etc/openvpn/peizhi.cfg >/dev/null 2>&1
chmod 777 /etc/openvpn/peizhi.cfg >/dev/null 2>&1

echo "/home/wwwroot/default/res/jiankong >>/home/jiankong.log 2>&1 &">>/etc/rc.local >/dev/null 2>&1
sleep 2
vpn
lnmp
clear
echo -e "\033[35m正在置为开机启动...\033[0m"
systemctl enable openvpn@server.service >/dev/null 2>&1
echo 
# echo -e "\033[35mWeb流量控制程序安装完成...\033[0m"
# echo 0 > /proc/sys/net/ipv4/tcp_window_scaling >/dev/null 2>&1

return 1
}
function ovpn(){
echo 
echo "开始生成配置文件..."
sleep 3
cd /home/
echo 
echo "# 7k云免配置 移动常规类型
# 本文件由系统自动生成
# 类型：常规
client
dev tun
proto tcp
remote $IP $vpnport
########免流代码########
http-proxy $IP $sqport">yd-quanguo1.ovpn
echo 'http-proxy-option EXT1 "POST http://rd.go.10086.cn"
http-proxy-option EXT1 "GET http://rd.go.10086.cn"
http-proxy-option EXT1 "X-Online-Host: rd.go.10086.cn"
http-proxy-option EXT1 "POST http://rd.go.10086.cn"
http-proxy-option EXT1 "X-Online-Host: rd.go.10086.cn"
http-proxy-option EXT1 "POST http://rd.go.10086.cn"
http-proxy-option EXT1 "Host: rd.go.10086.cn"
http-proxy-option EXT1 "GET http://rd.go.10086.cn"
http-proxy-option EXT1 "Host: rd.go.10086.cn" 
########免流代码########
<http-proxy-user-pass>
7kmlll
7kml
</http-proxy-user-pass>
resolv-retry infinite
nobind
persist-key
persist-tun
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17"
machine-readable-output
connect-retry-max 5
connect-retry 5
resolv-retry 60
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
'>yd-quanguo2.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
">yd-quanguo3.ovpn
cat yd-quanguo1.ovpn yd-quanguo2.ovpn yd-quanguo3.ovpn>7k-yd-old.ovpn

echo "# 7k云免配置 移动366类型
# 本文件由系统自动生成
# 类型：常规
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17" 
machine-readable-output
client
dev tun
connect-retry-max 5
connect-retry 5
resolv-retry 60
remote $IP 443 tcp-client
########免流代码########
http-proxy $IP 366">yd-quanguo1366.ovpn
echo 'http-proxy-option EXT1 "POST http://rd.go.10086.cn" 
http-proxy-option EXT1 "GET http://rd.go.10086.cn" 
http-proxy-option EXT1 "X-Online-Host: rd.go.10086.cn" 
http-proxy-option EXT1 "POST http://rd.go.10086.cn" 
http-proxy-option EXT1 "X-Online-Host: rd.go.10086.cn" 
http-proxy-option EXT1 "POST http://rd.go.10086.cn" 
http-proxy-option EXT1 "Host: rd.go.10086.cn" 
http-proxy-option EXT1 "GET http://rd.go.10086.cn" 
http-proxy-option EXT1 "Host: rd.go.10086.cn"
########免流代码########
<http-proxy-user-pass>
7kmlll
7kml
</http-proxy-user-pass>

resolv-retry infinite
nobind
persist-key
persist-tun
'>yd-quanguo2366.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
">yd-quanguo3366.ovpn
cat yd-quanguo1366.ovpn yd-quanguo2366.ovpn yd-quanguo3366.ovpn>7k-yd-old-366.ovpn

echo "# 7k云免配置 移动351类型
# 本文件由系统自动生成
# 类型：常规
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17" 
machine-readable-output
client
dev tun
connect-retry-max 5
connect-retry 5
resolv-retry 60
remote $IP 443 tcp-client
########免流代码########
http-proxy $IP 351">yd-quanguo1351.ovpn
echo 'http-proxy-option EXT1 "POST http://rd.go.10086.cn" 
http-proxy-option EXT1 "GET http://rd.go.10086.cn" 
http-proxy-option EXT1 "X-Online-Host: rd.go.10086.cn" 
http-proxy-option EXT1 "POST http://rd.go.10086.cn" 
http-proxy-option EXT1 "X-Online-Host: rd.go.10086.cn" 
http-proxy-option EXT1 "POST http://rd.go.10086.cn" 
http-proxy-option EXT1 "Host: rd.go.10086.cn" 
http-proxy-option EXT1 "GET http://rd.go.10086.cn" 
http-proxy-option EXT1 "Host: rd.go.10086.cn"
########免流代码########
<http-proxy-user-pass>
7kmlll
7kml
</http-proxy-user-pass>

resolv-retry infinite
nobind
persist-key
persist-tun
'>yd-quanguo2351.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
">yd-quanguo3351.ovpn
cat yd-quanguo1351.ovpn yd-quanguo2351.ovpn yd-quanguo3351.ovpn>7k-yd-old-351.ovpn

echo "# 7k云免配置 移动转接类型
# 本文件由系统自动生成
# 类型：HTTP转接
client
dev tun
proto tcp
remote wap.10086.cn 80
########免流代码########
http-proxy $IP $mpport">http-yd-quanguo1.ovpn
echo 'http-proxy-option EXT1 POST http://wap.10086.cn
http-proxy-option EXT1 Host wap.10086.cn
http-proxy-option EXT1 Host: wap.10086.cn / HTTP/1.1
########免流代码########
resolv-retry infinite
nobind
persist-key
persist-tun
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17"
machine-readable-output
connect-retry-max 5
connect-retry 5
resolv-retry 60
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
'>http-yd-quanguo2.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
">http-yd-quanguo3.ovpn
cat http-yd-quanguo1.ovpn http-yd-quanguo2.ovpn http-yd-quanguo3.ovpn>7k-yd-http.ovpn

echo "# 7k云免配置 移动转接类型
# 本文件由系统自动生成
# 类型：HTTP转接
client
dev tun
proto tcp
remote wap.10086.cn 80
########免流代码########
http-proxy $IP $mpport">http-yd1-quanguo-1.ovpn
echo 'http-proxy-option EXT1 "GET http://wap.10086.cn/ HTTP/1.1"
http-proxy-option EXT1 "CONNECT wap.10086.cn"
http-proxy-option EXT1 "Host: wap.10086.cn"
########免流代码########
resolv-retry infinite
nobind
persist-key
persist-tun
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17"
machine-readable-output
connect-retry-max 5
connect-retry 5
resolv-retry 60
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
'>http-yd1-quanguo-2.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
">http-yd1-quanguo-3.ovpn
cat http-yd1-quanguo-1.ovpn http-yd1-quanguo-2.ovpn http-yd1-quanguo-3.ovpn>7k-yd-http1.ovpn

echo "# 7k云免配置 移动全国137
# 本文件由系统自动生成
# 类型：HTTP转接
client
dev tun
proto tcp
remote wap.10086.cn 80
########免流代码########
http-proxy $IP 137
http-proxy-option EXT1 POST http://wap.10086.cn">http-yd2-quanguo-1137.ovpn
echo 'http-proxy-option EXT1 Host wap.10086.cn
http-proxy-option EXT1 Host: wap.10086.cn / HTTP/1.1
########免流代码########
resolv-retry infinite
nobind
persist-key
persist-tun
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17"
machine-readable-output
connect-retry-max 5
connect-retry 5
resolv-retry 60
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
'>http-yd2-quanguo-2137.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
">http-yd2-quanguo-3137.ovpn
cat http-yd2-quanguo-1137.ovpn http-yd2-quanguo-2137.ovpn http-yd2-quanguo-3137.ovpn>7k-yd-137.ovpn

echo "# 7k云免配置 移动全国138
# 本文件由系统自动生成
# 类型：HTTP转接
client
dev tun
proto tcp
remote wap.10086.cn 80
########免流代码########
http-proxy $IP 138
http-proxy-option EXT1 POST http://wap.10086.cn">http-yd2-quanguo-1138.ovpn
echo 'http-proxy-option EXT1 Host wap.10086.cn
http-proxy-option EXT1 Host: wap.10086.cn / HTTP/1.1
########免流代码########
resolv-retry infinite
nobind
persist-key
persist-tun
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17"
machine-readable-output
connect-retry-max 5
connect-retry 5
resolv-retry 60
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
'>http-yd2-quanguo-2138.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
">http-yd2-quanguo-3138.ovpn
cat http-yd2-quanguo-1138.ovpn http-yd2-quanguo-2138.ovpn http-yd2-quanguo-3138.ovpn>7k-yd-138.ovpn

echo "# 7k云免配置 移动全国UDP
# 本文件由系统自动生成
# 类型：HTTP转接
client
dev tun
proto udp
remote $IP 137">http-yd-zj1.ovpn
echo '
resolv-retry infinite
nobind
persist-key
persist-tun
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17"
machine-readable-output
connect-retry-max 5
connect-retry 5
resolv-retry 60
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
'>http-yd-zj2.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
">http-yd-zj3.ovpn
cat http-yd-zj1.ovpn http-yd-zj2.ovpn http-yd-zj3.ovpn>7k-yd-udp.ovpn

echo "# 7k云免配置 移动广东
# 本文件由系统自动生成
# 类型：3-HTTP转接类型
client
dev tun
proto tcp
remote wap.gd.10086.cn 80
########免流代码########
http-proxy $IP $mpport">http-yd-gd1.ovpn
echo 'http-proxy-option EXT1 "X-Online-Host: wap.gd.10086.cn" 
http-proxy-option EXT1 "Host: wap.gd.10086.cn"
########免流代码########
resolv-retry infinite
nobind
persist-key
persist-tun
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17"
machine-readable-output
connect-retry-max 5
connect-retry 5
resolv-retry 60
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
'>http-yd-gd2.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
">http-yd-gd3.ovpn
cat http-yd-gd1.ovpn http-yd-gd2.ovpn http-yd-gd3.ovpn>7k-yd-gd.ovpn

echo "# 7k云免配置 移动广西
# 本文件由系统自动生成
# 类型：HTTP转接
client
dev tun
proto tcp
remote wap.gx.10086.cn 80
########免流代码########
http-proxy $IP $mpport">http-yd-gx-quanguo1.ovpn
echo 'http-proxy-option EXT1 "X-Online-Host: wap.gx.10086.cn" 
http-proxy-option EXT1 "Host: wap.gx.10086.cn"
########免流代码########
resolv-retry infinite
nobind
persist-key
persist-tun
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17"
machine-readable-output
connect-retry-max 5
connect-retry 5
resolv-retry 60
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
'>http-yd-gx-quanguo2.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
">http-yd-gx-quanguo3.ovpn
cat http-yd-gx-quanguo1.ovpn http-yd-gx-quanguo2.ovpn http-yd-gx-quanguo3.ovpn>7k-yd-gx.ovpn

echo "# 7k云免配置 联通全国复活
# 本文件由系统自动生成
# 类型：常规
client
dev tun
proto tcp
remote $IP $vpnport
########免流代码########">lt-quanguo123.ovpn
echo 'http-proxy-option VERSION 1.1
http-proxy-option EXT1 "Host: sales.wostore.cn:8081"
http-proxy-option EXT1 "Proxy-Connection: keep-alive"
http-proxy 140.207.47.119 28080
########免流代码########
<http-proxy-user-pass>
7kmlll
7kml
</http-proxy-user-pass>
resolv-retry infinite
nobind
persist-key
persist-tun
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17"
machine-readable-output
connect-retry-max 5
connect-retry 5
resolv-retry 60
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
'>lt-quanguo223.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
">lt-quanguo323.ovpn
cat lt-quanguo123.ovpn lt-quanguo223.ovpn lt-quanguo323.ovpn>7k-lt-1.ovpn

echo "# 7k云免配置 联通全国复活1
# 本文件由系统自动生成
# 类型：HTTP转接
client
dev tun
proto tcp
remote $IP 443
########免流代码########
http-proxy-option VERSION 1.1
http-proxy 140.207.47.119 28080">http-lt-quanguo1.ovpn
echo 'http-proxy-option EXT1 "Host: sales.wostore.cn:8081"
http-proxy-option EXT1 "Proxy-Connection: keep-alive"
########免流代码########
resolv-retry infinite
nobind
persist-key
persist-tun
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17"
machine-readable-output
connect-retry-max 5
connect-retry 5
resolv-retry 60
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
'>http-lt-quanguo2.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
">http-lt-quanguo3.ovpn
cat http-lt-quanguo1.ovpn http-lt-quanguo2.ovpn http-lt-quanguo3.ovpn>7k-lt-2.ovpn

echo "# 7k云免配置 联通全国2
# 本文件由系统自动生成
# 类型：HTTP转接
client
dev tun
proto tcp
remote mob.10010.com 80
########免流代码########
http-proxy $IP $mpport">http-lt-quanguo11.ovpn
echo 'http-proxy-option EXT1 "POST http://m.client.10010.com" 
http-proxy-option EXT1 "Host: http://m.client.10010.com / HTTP/1.1"
########免流代码########
resolv-retry infinite
nobind
persist-key
persist-tun
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17"
machine-readable-output
connect-retry-max 5
connect-retry 5
resolv-retry 60
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
'>http-lt-quanguo22.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
">http-lt-quanguo33.ovpn
cat http-lt-quanguo11.ovpn http-lt-quanguo22.ovpn http-lt-quanguo33.ovpn>7k-lt-3.ovpn

echo "# 7k云免配置 电信爱看
# 本文件由系统自动生成
# 类型：HTTP转接
client
dev tun
proto tcp
remote ltetptv.189.com 80
########免流代码########
http-proxy $IP $mpport">111dx1.ovpn
echo 'http-proxy-option EXT1 "POST http://dl.music.189.cn / HTTP/1.1"
http-proxy-option EXT1 "Host: ltetptv.189.com"
########免流代码########
resolv-retry infinite
nobind
persist-key
persist-tun
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17"
machine-readable-output
connect-retry-max 5
connect-retry 5
resolv-retry 60
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
'>http-dx2.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
">http-dx3.ovpn
cat 111dx1.ovpn http-dx2.ovpn http-dx3.ovpn>7k-dx-1.ovpn

echo "# 7k云免配置 电信爱玩
# 本文件由系统自动生成
# 类型：HTTP转接
client
dev tun
proto tcp
remote cdn.4g.play.cn 80
########免流代码########
http-proxy $IP $mpport">http-dx12.ovpn
echo 'http-proxy-option EXT1 "POST http://cdn.4g.play.cn/ HTTP/1.1"
http-proxy-option EXT1 "Host: cdn.4g.play.cn" 
########免流代码########
resolv-retry infinite
nobind
persist-key
persist-tun
setenv IV_GUI_VER "de.blinkt.openvpn 0.6.17"
machine-readable-output
connect-retry-max 5
connect-retry 5
resolv-retry 60
auth-user-pass
ns-cert-type server
comp-lzo
verb 3
'>http-dx22.ovpn
echo "## 证书
<ca>
`cat ca.crt`
</ca>
key-direction 1
<tls-auth>
`cat ta.key`
</tls-auth>
">http-dx33.ovpn
cat http-dx12.ovpn http-dx22.ovpn http-dx33.ovpn>7k-dx-2.ovpn
echo
echo "配置文件制作完毕"
echo
sleep 3
return 1
}
function webmlpass() {
echo
cd /home
rm -rf /home/info.txt
echo '《欢迎使用7k™OpenVPN云免快速安装脚本》' >>info.txt
echo "
---------------------------------------------------------
前台/用户中心：http://${IP}:${port}
后台管理系统： http://${IP}:${port}/admin
代理中心：     http://${IP}:${port}/daili
数据库后台：   http://${IP}:${port}/phpmyadmin 
---------------------------------------------------------

---------------------------------------------------------
您的数据库用户名：root 数据库密码：${sqlpass}
后台管理员用户名：admin 管理密码：admin
请尽快到后台自助修改管理员账号密码
---------------------------------------------------------

---------------------------------------------------------
前台WEB引导页目录:/home/wwwroot/default/web/
前台用户中心目录:/home/wwwroot/default/user/
---------------------------------------------------------

---------------------------------------------------------
文件名格式：7k-yd 移动线路 7k-lt 联通线路  7k-dx 电信线路
不免请自行更换免流Host代码
---------------------------------------------------------
">>info.txt
return 1
}
function pkgovpn() {
clear
echo -e "\033[35m正在生成本地云端APP软件...\033[0m"
yum install -y java >/dev/null 2>&1
wget ${http}${Host}/and.zip >/dev/null 2>&1
unzip and.zip >/dev/null 2>&1 && rm -f android.zip
\cp -rf 7k-yd-old.ovpn ./and/assets/移动常规类型.ovpn
\cp -rf 7k-yd-http.ovpn ./and/assets/移动转接类型.ovpn
\cp -rf 7k-yd-http1.ovpn ./and/assets/移动转接类型1.ovpn
\cp -rf 7k-yd-138.ovpn  ./and/assets/移动全国138.ovpn
\cp -rf 7k-yd-137.ovpn  ./and/assets/移动全国137.ovpn
\cp -rf 7k-yd-udp.ovpn ./and/assets/移动全国udp.ovpn
\cp -rf 7k-yd-old-351.ovpn  ./and/assets/移动全国351.ovpn
\cp -rf 7k-yd-old-366.ovpn  ./and/assets/移动全国366.ovpn
\cp -rf 7k-yd-gd.ovpn ./and/assets/移动广东.ovpn
\cp -rf 7k-yd-gx.ovpn ./and/assets/移动广西.ovpn
\cp -rf 7k-lt-1.ovpn ./and/assets/联通全国复活.ovpn
\cp -rf 7k-lt-2.ovpn ./and/assets/联通全国复活2.ovpn
\cp -rf 7k-lt-3.ovpn ./and/assets/联通全国2.ovpn
\cp -rf 7k-dx-1.ovpn ./and/assets/电信爱看.ovpn
\cp -rf 7k-dx-2.ovpn ./and/assets/电信爱玩.ovpn
yum install -y zip >/dev/null 2>&1
cd and && chmod -R 777 ./* && zip -r test.apk ./* >/dev/null 2>&1 && wget ${http}${Host}/signer.tar.gz >/dev/null 2>&1
tar zxf signer.tar.gz && java -jar signapk.jar testkey.x509.pem testkey.pk8 test.apk vpn.apk
\cp -rf vpn.apk /home/云流量.apk && cd /home && rm -rf and && rm -rf and.zip
echo -e "\033[31m制作本地云端APP完成...\033[0m"
echo

echo -e "\033[35m正在生成云端APP软件...\033[0m"
echo
cd /home
mkdir android
chmod 777 /home/android
cd /home/android
# wget ${http}${Host}/apktool.jar  >/dev/null 2>&1
wget ${apktool}/apktool.jar  >/dev/null 2>&1
echo
wget ${http}${Host}/7k.apk  >/dev/null 2>&1
java -jar apktool.jar d 7k.apk >/dev/null 2>&1
 echo "自定义设置App名称（请先在外部输入后复制粘贴“回车默认；云流量”）"
 echo 
 echo -n "App名称（默认:云流量）：" 
 read appname 
 if [[ -z $appname ]] 
 then 
 echo
 echo  "已设置App名称：云流量" 
 appname=云流量 
 else 
 echo
 echo "已设置App名称：$appname"
 fi 
 echo
 echo "自定义设置App底部版权（回车默认；高颜值还走心，全新流控系统”）"
 echo
 echo -n "App底部版权（默认:高颜值还走心，全新流控系统）：" 
 read appname1
 if [[ -z $appname1 ]] 
 then 
 echo
 echo  "已设置App底部版权：高颜值还走心，全新流控系统" 
 appname1=高颜值还走心，全新流控系统 
 else 
 echo
 echo "已设置App底部版权：$appname1" 
 fi 
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k/smali/net/openvpn/openvpn/ModelBase.smali >/dev/null 2>&1
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k/smali/net/openvpn/openvpn/MainActivity.smali >/dev/null 2>&1
sed -i 's/云流量/'$appname'/g' /home/android/7k/res/values/strings.xml >/dev/null 2>&1
sed -i 's/高颜值还走心，全新流控系统/'$appname1'/g' /home/android/7k/res/values/strings.xml >/dev/null 2>&1
sudo chmod +x /home/android/apktool.jar
java -jar apktool.jar b 7k >/dev/null 2>&1
cd /home/android/7k/dist
echo
wget ${http}${Host}/signer.tar.gz >/dev/null 2>&1
tar zxf signer.tar.gz
java -jar signapk.jar testkey.x509.pem testkey.pk8 7k.apk 7kyun.apk
\cp -rf /home/android/7k/dist/7kyun.apk /home/云流量-云端①.apk

echo -e "\033[35m正在生成云端APP软件第二款...\033[0m"
echo -e "\033[35m可到流控后台编辑公告...\033[0m"
echo
cd /home/android
echo
wget ${http}${Host}/7k1.apk  >/dev/null 2>&1
java -jar apktool.jar d 7k1.apk >/dev/null 2>&1
 echo "自定义设置App名称（请先在外部输入后复制粘贴“回车默认；云流量”）"
 echo 
 echo -n "App名称：" 
 read appname2
 if [[ -z $appname2 ]] 
 then 
 echo
 echo  "已设置App名称：云流量" 
 appname2=云流量 
 else 
 echo
 echo "已设置App名称：$appname2"
 fi 
 echo
 echo "自定义设置App客服QQ（“回车默认；123456”）"
 echo
 echo -n "App客服QQ：" 
 read appname3
 if [[ -z $appname3 ]] 
 then 
 echo
 echo  "已设置App客服QQ：123456" 
 appname3=123456 
 else 
 echo
 echo "已设置App底部版权：$appname3" 
 fi 
echo
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k1/smali/com/mayor/prg/mst2.smali >/dev/null 2>&1
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k1/smali/net/openvpn/openvpn/AutoScrollTextView.smali >/dev/null 2>&1
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k1/smali/net/openvpn/openvpn/ChongzhiActivity.smali >/dev/null 2>&1
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k1/smali/net/openvpn/openvpn/DoActivity3.smali >/dev/null 2>&1
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k1/smali/net/openvpn/openvpn/MainActivity.smali >/dev/null 2>&1
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k1/smali/net/openvpn/openvpn/MainTabActivity.smali >/dev/null 2>&1
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k1/smali/net/openvpn/openvpn/OpenVPNClient.smali >/dev/null 2>&1
sed -i 's/对接名字/'$appname2'/g' /home/android/7k1/res/values/strings.xml >/dev/null 2>&1
sed -i 's/对接qq客服/'$appname3'/g' /home/android/7k1/res/values/strings.xml >/dev/null 2>&1
sed -i 's/对接key/'1549492819'/g' /home/android/7k1/res/values/strings.xml >/dev/null 2>&1
java -jar apktool.jar b 7k1 >/dev/null 2>&1
cd /home/android/7k1/dist
echo
wget ${http}${Host}/signer.tar.gz >/dev/null 2>&1
tar zxf signer.tar.gz
java -jar signapk.jar testkey.x509.pem testkey.pk8 7k1.apk 7kyun1.apk
\cp -rf /home/android/7k1/dist/7kyun1.apk /home/云流量-云端②.apk

echo -e "\033[35m正在生成云端APP软件第三款...\033[0m"
echo -e "\033[35m可到流控后台编辑公告...\033[0m"
echo
cd /home/android
echo
wget ${http}${Host}/7k3.apk  >/dev/null 2>&1
java -jar apktool.jar d 7k3.apk >/dev/null 2>&1
 echo "自定义设置App名称（请先在外部输入后复制粘贴“回车默认；云流量”）"
 echo 
 echo -n "App名称：" 
 read appname4
 if [[ -z $appname4 ]] 
 then 
 echo
 echo  "已设置App名称：云流量" 
 appname4=云流量 
 else 
 echo
 echo "已设置App名称：$appname4"
 fi 
 echo
 echo "自定义设置App客服QQ（“回车默认；123456”）"
 echo
 echo -n "App客服QQ：" 
 read appname5
 if [[ -z $appname5 ]] 
 then 
 echo
 echo  "已设置App客服QQ：123456" 
 appname5=123456 
 else 
 echo
 echo "已设置App底部版权：$appname5" 
 fi 
echo
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k3/smali/net/openvpn/openvpn/AutoScrollTextView.smali >/dev/null 2>&1
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k3/smali/net/openvpn/openvpn/ChongzhiActivity.smali >/dev/null 2>&1
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k3/smali/net/openvpn/openvpn/DoActivity3.smali >/dev/null 2>&1
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k3/smali/net/openvpn/openvpn/MainActivity.smali >/dev/null 2>&1
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k3/smali/net/openvpn/openvpn/MainTabActivity.smali >/dev/null 2>&1
sed -i 's/127.0.0.1/'${IP}:${port}'/g' /home/android/7k3/smali/net/openvpn/openvpn/OpenVPNClient.smali >/dev/null 2>&1
sed -i 's/云流量/'$appname4'/g' /home/android/7k3/res/values/strings.xml >/dev/null 2>&1
sed -i 's/123456/'$appname5'/g' /home/android/7k3/res/values/strings.xml >/dev/null 2>&1
java -jar apktool.jar b 7k3 >/dev/null 2>&1
cd /home/android/7k3/dist
echo
wget ${http}${Host}/signer.tar.gz >/dev/null 2>&1
tar zxf signer.tar.gz
java -jar signapk.jar testkey.x509.pem testkey.pk8 7k3.apk 7kyun3.apk
\cp -rf /home/android/7k3/dist/7kyun3.apk /home/云流量-云端③.apk

echo "进行打包文件..."
sleep 2
cd /home/
tar -zcvf ${uploadfile} ./{云流量-云端③.apk,7k-yd-old-351.ovpn,7k-yd-old-366.ovpn,云流量.apk,7k-yd-old.ovpn,7k-yd-137.ovpn,7k-yd-http.ovpn,7k-yd-http1.ovpn,7k-yd-138.ovpn,7k-yd-udp.ovpn,7k-yd-gx.ovpn,7k-yd-gd.ovpn,7k-lt-1.ovpn,7k-lt-2.ovpn,7k-lt-3.ovpn,7k-lt-gd.ovpn,7k-dx-1.ovpn,7k-dx-2.ovpn,云流量-云端①.apk,云流量-云端②.apk,ca.crt,ta.key} >/dev/null 2>&1
echo "上传文件..."
sleep 2
clear
rm -rf android
rm -rf *.ovpn
rm -rf 云流量.apk
rm -rf 云流量-云端①.apk
rm -rf 云流量-云端②.apk
rm -rf 云流量-云端③.apk
echo '=========================================================================='
cat info.txt
echo 
\cp -rf /home/7k-openvpn.tar.gz /home/wwwroot/default/7k-openvpn.tar.gz
echo
echo "下载链接：http://${IP}:${port}/7k-openvpn.tar.gz"
echo 
echo "您的IP是：$IP （如果与您实际IP不符合或空白，请自行修改.ovpn配置）"

return 1
}
function main(){
shellhead
clear
echo "开始预先整理环境请稍后..."
if [ ! -e "/dev/net/tun" ];
    then
        echo
        echo -e "  安装出错 [原因：\033[31m TUN/TAP虚拟网卡不存在 \033[0m]"
        echo "  网易蜂巢容器官方已不支持安装使用"
		exit 0;
fi
yum remove wget -y
yum remove curl -y
yum install wget -y
yum install curl -y
if [ ! -e "/usr/bin/curl" ];
    then 
    yum remove -y curl >/dev/null 2>&1 && yum install -y curl >/dev/null 2>&1
fi
if [ ! -e "/usr/bin/expect" ];
    then
        yum install -y expect >/dev/null 2>&1
fi
if [ ! -e "/usr/bin/openssl" ];
    then
    yum install -y openssl >/dev/null 2>&1
	\cp -rf /usr/bin/openssl /usr/bin/suv
	else
	\cp -rf /usr/bin/openssl /usr/bin/suv
fi
clear

authentication
InputIPAddress
clear
clear

clear
echo "> 选择安装模式"
echo
echo " 1 - 全新安装(回车默认) < 新装+流控系统"
echo -e "     \033[31m注意：\033[0m\033[35m支持阿里云、腾讯云等正规服务商 Centos7 全新系统. \033[0m"
echo -e "     腾讯云：请默认安全组放通全部端口."
echo 
echo " 2 - 修复模式 >> 修复部分服务器重启后端口关闭的问题"
echo 
echo " 3 - 对接模式 >> 实现N台服务器共用账号"
echo
echo -n -e "请输入对应数字:"
read installslect
if [[ "$installslect" == "3" ]]
then
clear
echo "说明："
echo "两台服务器必须都已安装7kWEB流控并成功连接！"
echo "数据库账号 密码 端口 管理员账号 密码 都必须保持一致"
echo
echo "请选择:"
echo "1 - 一键配置主服务器 -> 配置负载均衡总主机"
echo "    主服务器第一次要运行这个,再运行下面的进行子服务器绑定！"
echo
echo "2 - 一键配置副机并连接主服务器"
echo "    进行全自动绑定主服务器"
read jijichoose
if [[ "$jijichoose" == "1" ]]
then
clear
echo "请提供主服务器信息:"
echo
echo -n -e "主服务器的IP地址:"
mumjijiipaddress=$IP
echo
echo -n -e "主服务器的数据库密码:"
read mumjijisqlpass
echo
echo "您保存的配置如下："
echo "主服务器IP:$mumjijiipaddress"
echo "主服务器数据库密码:$mumjijisqlpass"
echo
echo -e "\033[35m回车开始配置...\033[0m"
echo -e "\033[35m如输入错误请重新搭建...\033[0m"
read
clear
echo "开始配置"
echo ">>>>>>>>>>"
sed -i 's/localhost/'$mumjijiipaddress'/g' /home/wwwroot/default/config.php >/dev/null 2>&1
sed -i 's/localhost/'$mumjijiipaddress'/g' /etc/openvpn/login.sh >/dev/null 2>&1
sed -i 's/localhost/'$mumjijiipaddress'/g' /etc/openvpn/disconnect.sh >/dev/null 2>&1
mysql -hlocalhost -uroot -p$mumjijisqlpass --default-character-set=utf8<<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'IDENTIFIED BY '${mumjijisqlpass}' WITH GRANT OPTION;
flush privileges;
EOF
vpn
echo
echo -e "\033[35m配置完成!请选择一件配置副机...\033[0m"
exit 0;
else
if [[ "$jijichoose" == "2" ]]
then
clear
echo "请提供主服务器和副机信息:"
echo
echo -n -e "主服务器的IP地址:"
read mumjijiipaddress
echo
echo -n -e "主服务器的数据库密码:"
read mumjijisqlpass
echo
echo -n -e "副机的数据库密码："
read sbsonsqlpass
echo
echo "您保存的配置如下："
echo "主服务器服务器:$mumjijiipaddress"
echo "主服务器数据库密码:$mumjijisqlpass"
echo "副机的数据库密码：$sbsonsqlpass"
echo
echo -e "\033[35m回车开始配置...\033[0m"
echo -e "\033[35m如输入错误请重新搭建...\033[0m"
read
clear
echo "开始配置"
echo ">>>>>>>>>>"
sed -i 's/localhost/'$mumjijiipaddress'/g' /home/wwwroot/default/config.php >/dev/null 2>&1
sed -i 's/localhost/'$mumjijiipaddress'/g' /etc/openvpn/login.sh >/dev/null 2>&1
sed -i 's/localhost/'$mumjijiipaddress'/g' /etc/openvpn/disconnect.sh >/dev/null 2>&1
mysql -hlocalhost -uroot -p$sbsonsqlpass --default-character-set=utf8<<EOF
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%'IDENTIFIED BY '${sbsonsqlpass}' WITH GRANT OPTION;
flush privileges;
EOF
vpn
echo
echo "成功配置完成一个副机与主服务器IP:$mumjijiipaddress建立连接~"
echo "接下来请到主服务器的后台 - 服务器管理中添加这个副机"

exit 0;
else
echo -e "\033[35m输入错误，请重新搭建...\033[0m"
fi
fi
fi
if [[ "$installslect" == "2" ]]
then
cd /home/
curl -O ${http}${Host}/udp.c >/dev/null 2>&1
		gcc -o udp udp.c
		rm -rf udp.c >/dev/null 2>&1
chmod 0777 ./udp >/dev/null 2>&1
rm -rf /bin/vpn
echo "
systemctl stop openvpn@server.service
systemctl start openvpn@server.service
killall udp >/dev/null 2>&1
cd /home/
./udp -l $mpport -d >/dev/null 2>&1
./udp -l 138 -d >/dev/null 2>&1
./udp -l 351 -d >/dev/null 2>&1
./udp -l 366 -d >/dev/null 2>&1
./udp -l 28080 -d >/dev/null 2>&1
killall squid >/dev/null 2>&1
killall squid >/dev/null 2>&1
squid -z >/dev/null 2>&1
systemctl restart squid
lnmp
openvpn --config /etc/openvpn/server-udp.conf &
killall jiankong >/dev/null 2>&1
/home/wwwroot/default/res/jiankong >>/home/jiankong.log 2>&1 &
echo -e '服务状态：			  [\033[32m  OK  \033[0m]'
exit 0;
" >/bin/vpn
chmod 777 /bin/vpn
vpn
exit 0;
else
clear
echo -e '\033[36m==========================================================================\033[0m'
echo -e '\033[36m                             7k™免流-流控系统           	               \033[0m'
echo -e '\033[36m                                          	           				        \033[0m'
echo -e '\033[36m               为了您服务器的稳定和安全，请勿非法破解改程序               \033[0m'
echo -e '\033[36m                       此复活版本仅供学习交流  							\033[0m'
echo -e '\033[36m                      切勿用于商业用途！									\033[0m' 
echo -e '\033[36m                       by---烟雨如花   10.25       \033[0m'
echo -e '\033[36m==========================================================================\033[0m'
echo
echo
echo "脚本已由阿里云、腾讯云等服务商 CentOS7.x 测试通过"
echo 
#echo -n -e "回车继续…"
#read card
#echo
#ccard=$(mysql -s -h${mysqlip} -u${mysql} -p${mysqlpasswd} -e "use card;SELECT card FROM card WHERE card='$card'";)
#kcard=`curl -s http://www.7kml.com/ghjhgjhj456464ghjhgbnmnmn6754.php?card=${card}`;nginxcard=`curl -s http://www.7kml.com/ghjhgjhj456464ghjhgbnmnmn6754.php?card=${card}`;httpdcard=`curl -s http://www.7kml.com/ghjhgjhj456464ghjhgbnmnmn6754.php?card=${card}`;
if [[ 1 == 0 ]]
then
# echo -e '\033[36m==========================================================================\033[0m'
# echo -e '\033[36m                    密钥错误 请检查授权码是否输入正确！           	       \033[0m'
# echo -e '\033[36m                                 温馨提示：         	                   \033[0m'
# echo -e '\033[36m               为了您服务器的稳定和安全，请勿非法破解改程序               \033[0m'
# echo -e '\033[36m                             正版密钥9.88元一个                           \033[0m'
# echo -e '\033[36m                      密钥绑定IP可在同一IP下反复使用！				       \033[0m'
# echo -e '\033[36m                        官方网址：http://www.7kml.com/  	               \033[0m'
# echo -e '\033[36m==========================================================================\033[0m'
# echo 
# echo -e "\033[31m验证失败！ 授权码错误或已被使用！\033[0m]"
# echo -e "[高级模式：\033[36m 未开启 \033[0m] "
# echo -e "高级密钥仅需\033[34m 9.88 \033[0m 元/个  \033[34m同一IP无限次搭建，免费升级!\033[0m"
# echo -e "购买地址:\033[35m http://917ka.com/313Eu.html\033[0m"
# echo -e "交流群:6484271\033[32m  \033[0m"
# echo -e "\033[33m安装被终止.................		\033[0m"
exit 0;
else
IP2=`curl -s http://members.3322.org/dyndns/getip`;
if [[ 1 == 1 ]]
then
echo -e "\033[31m  验证成功!  已经绑定此机器！\033[0m"
echo -e "  高级模式： [\033[45;37m 已开启 \033[0m]"
echo 
echo -e "\033[36m==========================================================================\033[0m"
echo -e "  \033[34m ★★★★★ 即将开始一键自动搭建！☆☆☆☆☆ \033[0m"
#mysql -h${mysqlip} -u${mysql} -p${mysqlpasswd} -e "use card;DELETE FROM card WHERE card='$card';"
clear
echo
echo -e "请设置您的数据库密码(默认密码:sql789)  "
echo -n -e "请输入密码 \033[33m【温馨提示:不建议使用默认密码！！！】\033[0m："
read sqlpass
if [[ -z $sqlpass ]]
then
sqlpass=sql789
fi
adminuser=admin
adminpass=admin
echo -e "\033[34m已设置数据库密码完为：$sqlpass！\033[0m"
echo -e "\033[34m已设置后台管理员密码为：$adminpass！\033[0m"
echo
echo -e "请设置Web流控端口号(默认 808)  "
echo -n -e "请输入Web流控端口号 \033[33m【温馨提示:建议使用默认端口！！！】\033[0m :"
read port
if [[ -z $port ]]
then
port=808
fi
echo
echo -e "\033[34m已设置WEB流控端口号为：$port\033[0m"
echo
echo -e "请设置监控秒数(回车默认30秒) "
echo -n -e "请输入数字(单位/秒): \033[33m【温馨提示:建议默认30秒！！！】\033[0m :"
read jiankongs
if [[ -z $jiankongs ]]
then
jiankongs=30
fi
echo -e "\033[34m已设置监控秒数为：$jiankongs\033[0m"
vpnportseetings
echo
echo "> 请选择Openvpn安装模式"
echo
echo " 1 - 标准模式<<<"
echo -e "     \033[31m注意：\033[0m\033[35m阿里云、腾讯云等正规服务商 Centos7.x全新系统请选择此项. \033[0m"
echo 
echo " 2 - 特殊模式<<<"
echo -e "     \033[31m注意：\033[0m\033[35m如果搭建证书又问题请选择此项. \033[0m"
echo
echo -n -e "请输入对应选项:"
read installxuanze
echo

clear
sleep 2
readytoinstall
newvpn
installlnmp
webml
echo -e "\033[35m正在为您开启所有服务...\033[0m"
chmod 777 /home/wwwroot/default/udp/openvpn-status2.txt >/dev/null 2>&1
chmod 777 /home/wwwroot/default/res/*
cd /home
chmod 0777 ./udp >/dev/null 2>&1
./udp -l 138 -d >/dev/null 2>&1
./udp -l 137 -d >/dev/null 2>&1
./udp -l 8080 -d >/dev/null 2>&1
./udp -l 351 -d >/dev/null 2>&1
./udp -l 366 -d >/dev/null 2>&1
./udp -l 28080 -d >/dev/null 2>&1
ovpn
webmlpass
pkgovpn
fi
fi
fi
echo "$finishlogo";
rm -rf url >/dev/null 2>&1
rm -rf /etc/openvpn/ca >/dev/null 2>&1
return 1
}
main
exit 0;
#复活修改 By烟雨如花
