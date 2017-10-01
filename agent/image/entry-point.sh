#!/bin/sh

# Run CADVISOR in background
cadvisor -logtostderr --allow_dynamic_housekeeping=false --application_metrics_count_limit=2000 --storage_duration=2m0s --global_housekeeping_interval=15s --housekeeping_interval=15s --max_housekeeping_interval=15s &

# Run node_exporter in background
mkdir /etc/node-exporter/
node_exporter -collector.procfs /host/proc \
-collector.sysfs /host/sys \
-collector.filesystem.ignored-mount-points "^/(sys|proc|dev|host|etc)($|/)" \
--collector.textfile.directory /etc/node-exporter/ \
--collectors.enabled="conntrack,diskstats,edac,entropy,filefd,filesystem,hwmon,infiniband,loadavg,mdadm,meminfo,netdev,netstat,stat,sockstat,textfile,time,uname,vmstat,zfs,buddyinfo,drbd,interrupts,ksmd,logind,meminfo_numa,mountstats,nfs,systemd,tcpstat" &

# Fetch the host machine's host name
if [ -z $HOST_NAME ]; then
    export HOST_NAME=$(cat /etc/host_hostname)
fi

# Run shell_script_exporter
/shell_exporter.sh &

# Register the agent to prometheus 
if [ -z $NO_REGISTER ]; then
    curl -k ${REGISTRAR_URL}/v1/register/${SERVICE_LABEL:-$HOST_NAME}/${HOST_NAME}
fi

genssl agent.dockerized.service

exec nginx -g 'daemon off;'