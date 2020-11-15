#!/bin/sh

[ -f '/etc/profile.d/utils.sh' ] && source /etc/profile.d/utils.sh

lRC=0
galera_user=galera
galera_password=ohGh7boh7eeg6shuph

banner "BEGIN SCRIPT: $_NAME"

cmd 'yum -y install xinetd'

echo "MYSQL_USERNAME='${galera_user}''
MYSQL_PASSWORD='${galera_password}'
AVAILABLE_WHEN_DONOR=0" > /etc/sysconfig/clustercheck

sed -i  "/mysqlchk/d" /etc/services
echo "mysqlchk 9200/tcp" >> /etc/services

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

cmd "service xinetd restart"

footer "END SCRIPT: $NAME"
exit $lRC