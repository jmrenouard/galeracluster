#!/bin/bash

[ -f '/etc/profile.d/utils.sh' ] && source /etc/profile.d/utils.sh

lRC=0
banner "BEGIN SCRIPT: $_NAME"

[ "$ID" = "ubuntu" ] && cmd "apt install -y policycoreutils selinux-utils selinux-basics" "INSTALL SELINUX for $ID"

cmd "setenforce 0" "SELINUX IN PERMISSIVE MODE"
#lRC=$(($lRC + $?))

if [ -f "/etc/sysconfig/selinux" ]; then  
	cmd "cat /etc/sysconfig/selinux" "CONTENT OF /etc/sysconfig/selinux"
	title1 "REMOVING ENFORCING mode FROM /etc/sysconfig/selinux"
	perl -i -pe 's/(SELINUX=).*/$1PERMISSIVE/g' /etc/sysconfig/selinux
	grep -q "SELINUX=PERMISSIVE" /etc/sysconfig/selinux
	lRC=$(($lRC + $?))
fi
cmd "cat /etc/selinux/config" "CONTENT OF /etc/selinux/config"
title1 "REMOVING ENFORCING mode FROM /etc/selinux/config"
perl -i -pe 's/(SELINUX=).*/$1PERMISSIVE/g' /etc/selinux/config
grep -q "SELINUX=PERMISSIVE" /etc/selinux/config
lRC=$(($lRC + $?))

cmd "sestatus"

footer "END SCRIPT: $_NAME"
>>>>>>> 7ab0ce90e0b1f0b388bcddef71f2b31e01b1b014
exit $lRC