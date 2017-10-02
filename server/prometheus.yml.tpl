# {{ ansible_managed }}
global:
  scrape_interval:     40s
  evaluation_interval: 60s

  # Attach these labels to any time series or alerts when communicating with
  # external systems (federation, remote storage, Alertmanager).
  external_labels:
      monitor: 'docker-host-alpha'

# Load and evaluate rules in this file every 'evaluation_interval' seconds.
rule_files:
  - "rules/*.rules"

# A scrape configuration containing exactly one endpoint to scrape.
scrape_configs:

  - job_name: 'overwritten-default'
    scheme: https
    tls_config:
      insecure_skip_verify: true
    basic_auth:
      username: "{{agent_username}}"
      password: "{{agent_password}}"

    file_sd_configs:
      - files: ['/etc/prometheus/tgroups/*.json', '/etc/prometheus/tgroups/*.yml']


