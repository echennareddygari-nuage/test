#!/bin/bash

### Execution instructions

# 1 - Update the config file variable in the file called k8s-full-deploy.config
#     which must be in the same directory as this executable.

# 2 - Run the script from the directory where the script file resides 
#     (all path names in code are relative)

### FUNCTIONS

function get_hosted_zone_id {

    local zone_domain

    echo "The following hosted zones are available..."

    aws route53 list-hosted-zones | jq  '.HostedZones | .[] | .Name'

    echo "Enter the domain to be used for this deployment and hit ENTER"
    echo "(type the domain exactly as it appears above, including quotations marks)"
    echo -n "--->  "

    read zone_domain
 
    ZONE_DOMAIN=$(sed -e 's/^"//' -e 's/"$//' <<<"$zone_domain")

    local count=$(aws route53 list-hosted-zones | jq -r '.HostedZones | .[] | select(.Name=='$zone_domain') | .Id' | wc -l)

    if (($count > "1")); then
        echo "More than one zone ID found for the domain: $zone_domain"; echo
        
        aws route53 list-hosted-zones | jq -r '.HostedZones | .[] | select(.Name=='$zone_domain') | .Id' | cut -d '/' -f 3
        
        echo "Enter the zone ID to be used for this deployment and hit ENTER"
        echo -n "--->  "

        read HOSTED_ZONE_ID

    elif (($count == "1")); then
        HOSTED_ZONE_ID=$(aws route53 list-hosted-zones | jq -r '.HostedZones | .[] | select(.Name=='$zone_domain') | .Id' | cut -d '/' -f 3)
    else
        echo "No available hosted zone ID was found."
        echo "Terminating script.  Please ensure that your expected hosted zone ID exists."
        exit 1
    fi

    echo "Using hosted zone ID: $HOSTED_ZONE_ID"

}

function check_hosted_zone_id {

    local zone_id=$1
    local count="$(aws route53 list-hosted-zones | grep $zone_id | wc -l)"

    echo "Checking for existence of zone ID for route 53 record creation..."

    if (($count >= "1")); then
        echo "Zone id $zone_id: FOUND"
        return 0
    else
        echo "Zone id $zone_id: NOT FOUND."
        echo "Terminating script.  Please ensure the expected hosted zone ID exists."
        exit 1
    fi

}


function check_file_exists {

    local file=$1

    if [ -f $file ]; then
        echo "Looking for file $file: FOUND"
        return 0
    else
        echo "Looking for file $file: NOT FOUND"
        echo "Terminating script.  Please make sure the file $file exists and the path is correct."
        exit 1
    fi

}


function make_file {

    local filename=$1
    local easy_hostname=$2
    local lb_hostname=$3

    echo "Creating temporary config file for CNAME record..."

    # begin json block
    cat > $filename <<EOL
    {
        "Comment": "Add friendly hostname for dynamic load balancer",
        "Changes": [
            {
                "Action": "UPSERT",
                "ResourceRecordSet": {
                    "Name": "$easy_hostname",
                    "Type": "CNAME",
                    "TTL": 300,
                    "ResourceRecords": [
                        {
                            "Value": "$lb_hostname"
                        }
                    ]
                }
            }
        ]
    }
EOL
    # end json block

}


function create_cname {

    local easy_hostname=$1
    local lb_hostname=$2
    local hosted_zone_id=$3
    local filename="./cname.json"

    make_file "$filename" "$easy_hostname" "$lb_hostname"

    echo "Updating route53 record: $easy_hostname --> $lb_hostname"

    echo; echo "---begin aws cli output block---"
    aws route53 change-resource-record-sets --hosted-zone-id $hosted_zone_id --change-batch file://$filename
    echo "---end aws cli output block---"; echo

    echo "Deleting temporary CNAME config file..."
    rm -f $filename

}

function update_dns {

    local svc_name=$1
    local easy_hostname=$2

    local lb_hostname="$(kubectl get svc -o=custom-columns=NAME:.metadata.name,EXT_IP_OR_HOST:.status.loadBalancer.ingress[*].hostname | grep $svc_name | awk '{print $2}')"

    create_cname "$easy_hostname" "$lb_hostname" "$HOSTED_ZONE_ID"

}


function deploy_app {

    #debug section
    #echo $1 $2 $3 $4 $5 $6 $7

    # Deploy each application one at a time
    # Function expects following arguments in order:
    # 1 - <application_name> - friendly name for logging
    # 2 - <yaml_path_file>  - full path and file name to k8s yaml config file
    # 3 - <#_of_expected_svcs> - integer, expcted count of svcs with name that mtch #6
    # 4 - <#_of_expected_pods> - integer, expected count of pods with name that match #7
    # 5 - <#_of_expected_lbs> - integer, expectec count of internal lb svcs
    # 6 - <match_string_for_svc_name>
    # 7 - <match_string_for_pod_name>

    echo; echo "Creating $1 application..."
    echo; echo "---begin kubectl output block---"
    kubectl create -f $2
    echo "----end kubectl output block----"; echo

    local timer="0"
    local svc_count="0"
    local pod_count="0"
    local lb_count="0"

    while [[ ("$svc_count" -lt "$3" || "$pod_count" -lt "$4" || "$lb_count" -lt "$5") && "$timer" -lt "600" ]]
    do
        timer=$((timer + 5))
        sleep 5
        svc_count=$(kubectl get svc -o wide | grep $6 | wc -l)
        pod_count=$(kubectl get pod -o wide | grep $7 | grep Running | wc -l)
        lb_count=$(kubectl get svc -o wide | grep $7 | grep internal | wc -l)
        echo "Waiting for $1 svcs/pods/lbs. Expecting $3/$4/$5, current count: $svc_count/$pod_count/$lb_count"
        echo "Waited $timer seconds (aborting after 600s)..."
    done

    if (($timer >= "600")); then
        echo "$1 application status: FAILED - svc/pod/lb ready timeout"
        return 1
    else
        echo "$1 application status: SUCCESS - all svcs/pods/lbs ready."
        return 0
    fi

}

function check_node_status {

    # This script checks the status of the k8s worked nodes in eks and
    # does not return success until all nodes report UP.
    # If this takes more than 2 minutes the script retuens a failed status

    echo "Wait for k8s nodes to reach operational state (timeout after 2 min)..."

    local timer="0"
    local count=`kubectl get nodes | grep Ready | wc -l`

    while [ $count -lt "3" -a  $timer -lt 120 ]; do
        echo "Total count of worker nodes in READY state: $count"
        echo "Waiting 10 seconds before next node check..."
        timer=$((timer + 10))
        sleep 10
        count=`kubectl get nodes | grep Ready | wc -l`
    done

    if (($timer >= "120")); then
        echo "Worker node status check: FAILED on timeout"
        return 1
    else
        echo "Total count of worker nodes in READY state: $count"
        echo "Worker node status check: SUCCESS"
        return 0
    fi
}

function check_cluster_status {

    echo "Checking the satus of the ops-eks cluster..."

    local timer="0"
    local count=`aws eks describe-cluster --name ops-eks | grep '"status": "ACTIVE"' | wc -l`

    while [ $count -lt "1" -a $timer -lt 120 ]; do
        echo "Total count of active clusters: $count"
        echo "Waiting 10 seconds before next node check..."
        timer=$((timer + 10))
        sleep 10
        count=`aws eks describe-cluster --name ops-eks | grep '"status": "ACTIVE"' | wc -l`
    done

    if (($timer >= "120")); then
        echo "Cluster check: FAILED on timeout"
        echo "Terminating script.  Please check why worked nodes did not deploy or reach ready state."
        exit 1
    else
        echo "Cluster check: SUCCESS"
        return 0
    fi
}



function config_aws_auth {


    echo "Configure authentication for AWS/k8s..."

    # Update kubectl with the new eks service config
    echo "Updating kubectl with new eks..."
    aws eks update-kubeconfig --name $EKS_CLUSTER_NAME

    # copy the auth config to file
    echo "Copying the terraform config map to file..."
    #cd ../terraform/hvns
    terraform output -state=../terraform/hvns/terraform.tfstate config_map_aws_auth > ./config_map_aws_auth.yaml

    # Apply the auth config to kubectl
    echo "Applying the config map auth to kubectl..."

    local timer="0"

    until kubectl apply -f ./config_map_aws_auth.yaml
    do
        echo "Could not apply AWS auth to kubectl. Wait 10 seconds and try again..."
        timer=$((timer + 10))

        if (($timer >= "120")); then
            echo "Apply AWS auth to kubectl: FAILED on timeout"
            return 1
        else
            sleep 10
        fi

    done

    echo "Apply AWS auth to kubectl: SUCCESS"
    return 0

}


### MAIN LOOP

# Source the config file to pull in all required config options
. ./k8s-full-deploy.config

# Ask user for the domain t get hosted zone id
get_hosted_zone_id

# Check that all expected files exist
check_file_exists "$F_GRAYLOG"
check_file_exists "$F_ZABBIX"
check_file_exists "$F_MONGODB"
check_file_exists "$F_GRAFANA"
check_file_exists "$F_ELASTIC"

# Configure auth for kubectl access to AWS EKS
config_aws_auth

# Check that all worked nodes are in ready state
check_node_status

# Deploy all applications
deploy_app "Grafana" "$F_GRAFANA" "2" "2" "1" "grafana" "grafana"
deploy_app "Elastic" "$F_ELASTIC" "2" "3" "0" "elasticsearch" "es-master"
deploy_app "Mongodb" "$F_MONGODB" "1" "1" "0" "mongodb" "mongo"
deploy_app "Graylog" "$F_GRAYLOG" "2" "2" "2" "graylog" "graylog"
deploy_app "Zabbix" "$F_ZABBIX" "3" "3" "2" "zabbix" "zabbix"

# Check that hosted zone id exists
#check_hosted_zone_id "$HOSTED_ZONE_ID"

# Update route53 DNS with easy application hostnames
update_dns "grafana-svc" "grafana.$ZONE_DOMAIN"
update_dns "graylog-web" "graylog.$ZONE_DOMAIN"
update_dns "graylog-ingest" "graylog-data.$ZONE_DOMAIN"
update_dns "zabbix-web" "zabbix.$ZONE_DOMAIN"
update_dns "zabbix-server" "zabbix-data.$ZONE_DOMAIN"

# Terminate with success
exit 0
