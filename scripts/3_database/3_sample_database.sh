#!/bin/sh

[ -f '/etc/profile.d/utils.sh' ] && source /etc/profile.d/utils.sh

banner "BEGIN SCRIPT: $_NAME"

cmd "create_database.sh employees employees employees_rw employees_ro"


cd /opt/local
cmd "git clone https://github.com/datacharmer/test_db.git"

cd /opt/local/test_db

title2 "Inject DATABASE employees"
mysql -v < ./employees.sql

cmd "db_list employees"

cmd "db_count employees"

cmd "list_user.sh"

footer "END SCRIPT: $NAME"

exit $lRC