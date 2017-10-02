#!/bin/bash

 cd /opt/monitoring/agent

# Setting up this script as startup process 
 ln -s /opt/monitoring/agent/run.sh  /etc/rc.d/

if [ ! -f .htpasswd ]; then
        echo ".htpasswd file is missing, something went wrong during the setup."
fi

source ~/.bashrc

docker-compose down
docker-compose pull
docker-compose up -d