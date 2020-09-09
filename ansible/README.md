# Monitoring agent deployment

## Overview
This ansible script can be executed at anytime after the AWS infrastructure and VNS deployments are complete.
The ansible script does the following things:
- deploys the Zabbix agent and configures it for active and passive checks to the Zabbix data load balancer host name
- deploys the Graylog agent and configures it with the category tags and log forwarding to the Graylog data load balancer hostname

## Prerequisites
Before running this ansible playbook ensure the folowing conditions are met for the deploy VM (the deploy VM refers to the VM inside AWS where the deployment scripts are executed from).
- ansible is installed

## Deployment
1. Move to to the ansible base directory...
    ```
    cd <base dir>/nkia-hvns/ansible
    ```
2.  Check the hosts file and ensure that the internal domain name for the hosts matches the expected deployment.
    ```
    [vsd]
    vsd01.hvns-prod-na1.internal
    vsd02.hvns-prod-na1.internal
    vsd03.hvns-prod-na1.internal
    ```
    Change the domain part of the FQDN for each host as necessary (i.e. "hvns-prod-na1.internal")
3.  Run the ansible playbook with corect options for SSH key and inventory (hosts) file location...
    ```
    ansible-playbook -i ./hosts ./deploy-agents.yaml --key-file=~/.ssh/dnovosel_hvns_test.privkey
    ```
    > -i </path/filename of the inventory>

    > --key-file </path/filename of the SSH key>

4. Deployment of agents is complete.  You can now proceed to configuring the Zabbix and Graylog applications.