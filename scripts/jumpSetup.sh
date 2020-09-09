#!/bin/bash

keyfile=~/.ssh/prodHostedWL-APAC01.pem
jumpip=3.80.138.165

scp -i $keyfile -r ../ansible/ centos@$jumpip:
scp -i $keyfile -r ../scripts/ centos@$jumpip:
scp -i $keyfile -r ../config/metro centos@$jumpip:
scp -i $keyfile -r $keyfile centos@$jumpip:.ssh/
