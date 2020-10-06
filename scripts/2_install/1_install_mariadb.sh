#!/bin/sh

[ -f '/etc/profile.d/utils.sh' ] && source /etc/profile.d/utils.sh

lRC=0
VERSION=10.5

banner "BEGIN SCRIPT: $_NAME"

cmd 'rm -f /etc/yum.repos.d/mariadb_*.repo'

info "SETUP mariadb_${VERSION}.repo FILE"
echo "# MariaDB $VERSION CentOS repository list - created $(date)
# http://downloads.mariadb.org/mariadb/repositories/
[mariadb]
name = MariaDB_$VERSION
baseurl = http://yum.mariadb.org/$VERSION/centos8-amd64
module_hotfixes=1
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1" > /etc/yum.repos.d/mariadb_${VERSION}.repo

cmd "cat /etc/yum.repos.d/mariadb_${VERSION}.repo"

cmd "yum -y update"
lRC=$(($lRC + $?))

cmd "yum -y remove mysql-server mariadb-server"
lRC=$(($lRC + $?))

cmd "yum -y install python3 MariaDB-backup MariaDB-client MariaDB-compat socat jemalloc rsync nmap lsof perl-DBI nc mariadb-server-utils pigz perl-DBD-MySQL perl-DBI git"
lRC=$(($lRC + $?))

cmd "yum -y install https://repo.percona.com/yum/release/8/RPMS/x86_64/percona-toolkit-3.2.1-1.el8.x86_64.rpm"
lRC=$(($lRC + $?))

cmd "pip3 install mycli"
lRC=$(($lRC + $?))

cmd "yum -y install https://rpmfind.net/linux/fedora-secondary/development/rawhide/Everything/s390x/os/Packages/m/mysqlreport-3.5-23.fc33.noarch.rpm"
lRC=$(($lRC + $?))

[ -d "/opt/local" ] || cmd "mkdir -p /opt/local"

[ -d "/opt/local/MySQLTuner-perl" ] && cmd "rm -rf /opt/local/MySQLTuner-perl"

cd /opt/local
cmd "git clone https://github.com/major/MySQLTuner-perl.git"
lRC=$(($lRC + $?))

cmd "chmod 755 /opt/local/MySQLTuner-perl/mysqltuner.pl"

echo 'export PATH=$PATH:/opt/local/MySQLTuner-perl' > /etc/profile.d/mysqltuner.sh
chmod 755 /etc/profile.d/mysqltuner.sh

footer "END SCRIPT: $NAME"
exit $lRC