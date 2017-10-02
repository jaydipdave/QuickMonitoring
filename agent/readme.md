# Monitoring Service 

## Agent

### Agent Deployment (Prepare the machines you want to monitor)

    git clone https://github.com/jaydipdave/QuickMonitoring.git
    cd QuickMonitoring/agent/
    vi target_servers # Update the target servers and SERVICE_LABEL variable
    ansible-playbook -i target_servers deploy.yml

**Warning:** The setup script will install jq, docker-compose and apache2-utils packages on the server. It should not break anything, already tried on multiple machines.

**Information:** The `image` folder contains the files needed to build the agent docker image.