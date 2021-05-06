#!/bin/sh

[ -f '/etc/profile.d/utils.sh' ] && source /etc/profile.d/utils.sh

lRC=0
DATADIR="/var/lib/mysql"

banner "BEGIN SCRIPT: $_NAME"

cmd "journalctl --rotate -u mariadb"
cmd "journalctl --vacuum-time=1s -u mariadb"

cmd "systemctl stop mariadb"

sleep 2s

cmd "rm -rf $DATADIR"
cmd "mysql_install_db --user mysql --skip-name-resolve --datadir=$DATADIR"

cmd "systemctl enable mariadb"
cmd "systemctl daemon-reload"
cmd "systemctl restart mariadb"

sleep 3s

cmd "netstat -ltnp"

ps -edf |grep [m]ysqld

cmd "ls -ls /var/lib/mysql"

cmd "journalctl -xe -o cat -u mariadb"

cmd "tail -n 30 /var/lib/mysql/mysqld.log"


cd /opt/local
cmd "git clone https://github.com/FromDual/mariadb-sys.git"
lRC=$(($lRC + $?))
cd /opt/local/mariadb-sys
mysql -f < sys_10.sql

footer "END SCRIPT: $NAME"
exit $lRC