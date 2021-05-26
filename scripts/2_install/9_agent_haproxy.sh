#!/bin/bash

[ -f '/etc/profile.d/utils.sh' ] && source /etc/profile.d/utils.sh

lRC=0
galera_user=galera
galera_password=ohGh7boh7eeg6shuph

[ -f '/etc/bootstrap.conf' ] && source /etc/bootstrap.conf
[ -n "$sst_password" ] && galera_password="$sst_password"

banner "BEGIN SCRIPT: $_NAME"

cmd 'yum -y install xinetd'

echo "MYSQL_USERNAME='${galera_user}'
MYSQL_PASSWORD='${galera_password}'
AVAILABLE_WHEN_DONOR=1" > /etc/sysconfig/clustercheck

sed -i  "/mysqlchk/d" /etc/services
echo "mysqlchk 9200/tcp" >> /etc/services

dos2unix /opt/local/bin/clustercheck

echo "
# default: on
# description: mysqlchk
service mysqlchk
{
	disable = no
	flags = REUSE
	socket_type = stream
	port = 9200
	wait = no
	user = mysql
	server = /opt/local/bin/clustercheck
	log_on_failure += USERID
	only_from = 0.0.0.0/0
	bind = 0.0.0.0
	per_source = UNLIMITED
}" > /etc/xinetd.d/mysqlchk


cmd "systemctl enable xinetd"
cmd "systemctl restart xinetd"


firewall-cmd --add-port=9200/tcp --permanent
firewall-cmd --reload

footer "END SCRIPT: $NAME"
exit $lRC