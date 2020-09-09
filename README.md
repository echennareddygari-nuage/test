# Nokia-hvns deployment

# Rough Steps - Will be cleaned up

- clone git repo to deployment host.
- chmod +x setup.sh
- Execute ./setup.sh
- Go into config folder and edit all example files for your deployment.
- cd terraform/deploy
- Execute terraform init
- Execute terraform plan
- Ensure details are correct
- Execute terraform apply
- Answer yes and wait for deployment to complete (around 10 minutes)
- Edit scripts/jumpSetup.sh and fill in SSH key and Jump Host IP
- Edit scripts/unpackInstaller.sh and setup source file (ie: packages/5_4_1U4.sh)
- Execute scripts/jumpSetup.sh
- SSH to jump host (run all remaining commands from jump host)
- Check that cloud init has finished running (/var/log/cloudinit.log - SUCCESS: running modules for final) (around 5 minutes)
- Execute scripts/unpackInstaller.sh (around 5 minutes)
- Build .ssh/config with metal/proxy hosts (and chmod 06400)
- Execute ssh-keygen (using default options)
- ## NOTE: Metro 3.3.2 WL is a modified form of metro.  The SDWAN Portal deployment task docker.yml is modified to remove the proxy/environmental components from the docker-compose action.  See WHITELABEL.md in nuage-metro folder.
- mv ~/metro ~/nuage-metro-3.3.2-wl/deployments/metro
- vi ~/nuage-metro-3.3.2-wl/deployments/metro/common.yml and set vstat_fqdn_global variable. (#TODO this should be fixed).
- cd ~/nuage-metro-3.3.2-wl
- Execute sudo ./metro-setup.sh
- cd ~/ansible
- Execute ansible-playbook preMetro/master.yml -i hosts (around 5 minutes)
- cd ~/nuage-metro-3.3.2-wl
- Execute ./metroae install_everything metro (around 45 minutes)
- Execute ./metroae install_sdwan_portal metro (around 10 minutes)
- Manually Add PrivateProxySG rule to allow TCP 80 egress (0.0.0.0/0)
- cd ~/ansible
- Execute ansible-playbook postMetro/master.yml -i hosts (around 5 minutes)

## OLD INSTRUCTIONS

## Terraform deployment
Terrafrom deploys all AWS assets including:
- baremetal servers
- networks, routing, security, EC2 instances, etc
- EKS (kubernetes) infrastructure

To see instructions on how to execute the terraform deployment click [**__here__**.](https://gitlab.com/dnovosel/nokia-hvns/blob/master/terraform/hvns/README.md)

## Monitoring tools deployment
The monitoring tools deployment script creates:
- Zabbix server, web front end and mySQL backend dB
- Graylog server, mongoDb config dB and elastic search cluster backend
- Grafana web front end and mySQL backend dB

To see instructions on how to execute the monitoring tools deployment click [**__here__**.](https://gitlab.com/dnovosel/nokia-hvns/blob/master/scripts/README.md)

## Monitoring agents deployment
The monitoring agents ansible script does:
- Zabbix agent install and configuration on baremetal and all VMs (except VSC)
- Graylog agent on baremetal and all VMs (except VSC)
- Syslog configuration on VSCs

To see instructions on how to execute the ansible monitoring agents deployment click [**__here__**.](https://gitlab.com/dnovosel/nokia-hvns/blob/master/ansible/README.md)
