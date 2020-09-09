#!/bin/bash

## INITIAL SETUP SCRIPT - RUN ONCE AFTER PULLING GIT REPO

## Copies templates to configuration folder.
## Enables +x on all required scripts
## Symlinks configuration files to correct locations.

mkdir config
cp -r templates/* config/
mv config/ansible_all.yml.example config/ansible_all.yml
mv config/terraform.tfvars.example config/terraform.tfvars

chmod +x scripts/*.sh

mkdir ansible/group_vars
ln -s ../../config/ansible_all.yml ansible/group_vars/all.yml
ln -s ../../config/terraform.tfvars terraform/deploy/terraform.tfvars
ln -s ../../config/terraform.tfvars terraform/remotevpc/terraform.tfvars
