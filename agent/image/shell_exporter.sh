#!/bin/sh

# Fetching shell rules
while true
do
    curl -sS ${REGISTRAR_URL}/v1/shell_rules/${SERVICE_LABEL:-$HOST_NAME} | base64 -d | sh > /etc/node-exporter/shell_rules.prom
    sleep 60
done