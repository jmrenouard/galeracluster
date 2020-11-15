#!/bin/sh

[ -f '/etc/profile.d/utils.sh' ] && source /etc/profile.d/utils.sh

lRC=0
CONF_FILE="/etc/sysconfig/garb"

cluster_name="opencluster"
server_id=$(hostname -s| perl -pe 's/.+?(\d+)/$1/')
node_name=$(hostname -s)
private_ip=$(ip a| grep '192' |grep inet|awk '{print $2}'| cut -d/ -f1)
node_addresses=192.168.33.161,192.168.33.162,192.168.33.163,192.168.33.164

banner "BEGIN SCRIPT: $_NAME"

cmd "rm -f $CONF_FILE"

info "SETUP $(basename $CONF_FILE) FILE INTO $(dirname $CONF_FILE)"

(
echo "# Minimal Garbd configuration - created $(date)
# Copyright (C) 2012 Codership Oy
# This config file is to be sourced by garb service script.

# A comma-separated list of node addresses (address[:port]) in the cluster
GALERA_NODES='${node_addresses}'

# Galera cluster name, should be the same as on the rest of the nodes.
GALERA_GROUP='${cluster_name}'

# Optional Galera internal options string (e.g. SSL settings)
# see http://galeracluster.com/documentation-webpages/galeraparameters.html
# GALERA_OPTIONS=""

# Log file for garbd. Optional, by default logs to syslog
LOG_FILE='/tmp/garb.log'
"
) | tee -a $CONF_FILE

cmd "chmod 644 $CONF_FILE"

cmd "systemctl restart garb"

footer "END SCRIPT: $NAME"
exit $lRC