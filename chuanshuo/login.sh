#!/bin/sh
user=$username
rp=$password
NOW=`date +%s`
iphost="localhost"
nm="bydbnm"
mm="bydbmm"
mysql -h$iphost -u$nm -p$mm -e "use ov;SELECT pass FROM openvpn WHERE iuser='$user' && fwqid='0';">>/data/vpn-log/log.txt
mysql -h$iphost -u$nm -p$mm -e "use ov;SELECT irecv FROM openvpn WHERE iuser='$user' && fwqid='0';">>/data/vpn-log/log.txt
mysql -h$iphost -u$nm -p$mm -e "use ov;SELECT isent FROM openvpn WHERE iuser='$user' && fwqid='0';">>/data/vpn-log/log.txt
mysql -h$iphost -u$nm -p$mm -e "use ov;SELECT maxll FROM openvpn WHERE iuser='$user' && fwqid='0';">>/data/vpn-log/log.txt
mysql -h$iphost -u$nm -p$mm -e "use ov;SELECT i FROM openvpn WHERE iuser='$user' && fwqid='0';">>/data/vpn-log/log.txt
mysql -h$iphost -u$nm -p$mm -e "use ov;SELECT endtime FROM openvpn WHERE iuser='$user' && fwqid='0';">>/data/vpn-log/log.txt
mysql -h$iphost -u$nm -p$mm -e "use ov;SELECT tian FROM openvpn WHERE iuser='$user' && fwqid='0';">>/data/vpn-log/log.txt
mysql -h$iphost -u$nm -p$mm -e "use ov;SELECT k FROM openvpn WHERE iuser='$user' && fwqid='0';">>/data/vpn-log/log.txt
pass=$(sed -n 2p /data/vpn-log/log.txt)
recv=$(sed -n 4p /data/vpn-log/log.txt)
sent=$(sed -n 6p /data/vpn-log/log.txt)
all=$(sed -n 8p /data/vpn-log/log.txt)
i=$(sed -n 10p /data/vpn-log/log.txt)
endtime=$(sed -n 12p /data/vpn-log/log.txt)
tian=$(sed -n 14p /data/vpn-log/log.txt)
k=$(sed -n 16p /data/vpn-log/log.txt)
rm -rf /data/vpn-log/log.txt
vl=$(($NOW+$tian*24*60*60));
if [ "$rp" == "$pass" ] && [ "$k" == "0" ] && [ "$i" == "1" ] && [ "$[$recv+$sent]" -lt "$all" ] ;
then {
mysql -h$iphost -u$nm -p$mm -e "use ov;UPDATE openvpn SET endtime="$vl" where iuser='$user' && fwqid='0';"
mysql -h$iphost -u$nm -p$mm -e "use ov;UPDATE openvpn SET k="1" where iuser='$user' && fwqid='0';";
echo $(date +%Y��%m��%d��%kʱ%M��) "�û�����ɹ�" "�˺�:"${username} "����:"${password}>>/data/www/default/restxt/login.log;
exit 0;
};
else 
if [ "$rp" == "$pass" ] && [ "$i" == "1" ] && [ "$[$recv+$sent]" -lt "$all" ] && [ "$endtime" -ge "$NOW" ];
then
echo $(date +%Y��%m��%d��%kʱ%M��) "�û���¼�ɹ�" "�˺�:"${username} "����:"${password}>>/data/www/default/restxt/login.log
exit 0;
else
echo $(date +%Y��%m��%d��%kʱ%M��) "�û���¼ʧ��" "�˺�:"${username} "����:"${password}>>/data/www/default/restxt/login.log;
exit 1;
fi;
fi;