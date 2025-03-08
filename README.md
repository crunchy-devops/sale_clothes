# Docker Installation Playbook

This repository contains an Ansible playbook for automated Docker installation on Ubuntu 24.04 systems, designed to work with Jenkins and AWX integration.

## Prerequisites

- Ubuntu 24.04 target hosts
- Ansible 2.9 or higher
- AWX/Tower setup (for automated deployments)
- Jenkins with AWX integration

## Playbook Features

- Installs latest Docker CE version
- Configures Docker Compose plugin
- Sets up system users for Docker access
- Integrates with existing CI/CD pipeline

## Usage with AWX/Jenkins

The playbook is designed to work with the existing Jenkins pipeline that uses AWX API integration. It expects:

- AWX Bearer token authentication (credential ID: 'awx-token')
- Job template parameters:
  - target_hosts: production
  - docker_users: [jenkins]

## Local Testing

1. Install Ansible:
```bash
sudo apt update
sudo apt install ansible
```

2. Run playbook in check mode:
```bash
ansible-playbook docker_install.yml --check
```

3. Run playbook for real deployment:
```bash
ansible-playbook docker_install.yml
```

## Variables

- `target_hosts`: Target inventory hosts (default: all)
- `docker_users`: List of users to add to Docker group

## Integration

This playbook is part of the automated deployment pipeline that:
1. Uses AWX API for deployment
2. Builds Docker images with Git commit hash tags
3. Pushes images to Nexus registry
4. Manages secure credentials via Jenkins