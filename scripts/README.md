# Nokia-hvns monitoring tools deployment

## Overview
After the terraform script has run to completion the AWS system should have a single EKS kubernetes controller and three EC2 worker nodes.

At any point after the terrform completes you can run a single bash script which does the following things:

- configures the authentication in kubectl to reach the AWS controller service

- checks that the worker nodes are have reached a ready state

- creates all the monitoring tool applications in sequence and provides basic validation that they are deployed correctly

- creates some CNAME records for simpler hostnames for accessing the tool endpoints internally


## Pre-requisites
Before running this script ensure the folowing conditions are met for the deploy VM (the deploy VM refers to the VM inside AWS where the deployment scripts are executed from).

- the kubectl package is installed 

- the AWS CLI tool is installed with the special EKS extensions 

- the AWS CLI tool has been executed once with the configure command to set up the basic environment

- the "jq" linux package is installed on 

- the aws-iam-authenticator tool is installed 

 Refer to the setup notes in this file location:

 ```
 cat ~/setup_notes.txt
 ```
## Deployment procedure

Note: The script relies on the relative directory structure and file locations. Do not move any files or change the directory tree structure.

1. Make sure the name configured in the terraform variable file for the EKS clustername matches the value stored in the script config file.

    In the file **__./terraform/hvns/terraform.tvars__**
    ```
    eksClusterName = "eksOps"
    ```
    ...or if the variable value is not defined there, the default value ins the file **__./terraform/hvns/variables.tf__**
    ```
    variable "eksClusterName" {
        default = "eksOps"
    }
    ```
    The value defined in **__./scripts/k8s-full-deploy.config__** MUST match the value used by terraform...
    ```
    # EKS cluster related vars
    #
    EKS_CLUSTER_NAME="eksOps"
    ```
2. Go to the script directory:
    ```
    cd <base dir>/nokia-hvns/scripts
    ```
3. Make the script executable...
    ```
    chmod 755 k8s-full-deploy.sh
    ```
4. Run the script from the directory it is in...
    ```
    ./k8s-full-deploy.sh
    ```
5. The script will perform some basic checks then it will prompt the user to enter the domain for the deployment from a list of available domains currently in the project...

    e.g.

    ```
    The following hosted zones are available...
    "hvns-test.com."
    "hvns-stage.internal."
    Enter the domain to be used for this deployment and hit ENTER
    (type the domain exactly as it appears above, including quotations marks)
    --->  "hvns-stage.internal."
    ```
6. After this the script will run on its own to completion or will terminate on any unrecoverable error that is detected along the way.

    Notes:
    
    - If the script terminates on an error you can fix the problem and re-run the script again without having to clean up any partial deployment that was successful. Deployment that has already completed sucessfully will be ignored on subsequent runs.
        
    - The script will generate meaningful error smessages and will output the results of other commands (kubectl, aws cli, etc) during its execution to help with troubleshooting errors

## Post Execution
At this stage the monitoring tools should be up and running and you can proceed to other stages of the dployment.

## Resizing Persistent Storage Volumes After Creation

1.  Find the PVC you want to resize...
```
kubectl get pvc

data-es-master-0   Bound     pvc-f08a45c2-4b2a-11e9-897d-0ae67db2be36   300Gi      RWO            elastic-gp2    1h
data-es-master-1   Bound     pvc-fd50eef7-4b2a-11e9-897d-0ae67db2be36   300Gi      RWO            elastic-gp2    1h
data-es-master-2   Bound     pvc-09fe74dc-4b2b-11e9-897d-0ae67db2be36   300Gi      RWO            elastic-gp2    1h
grafana-pvc        Bound     pvc-5324a5b4-4b2a-11e9-897d-0ae67db2be36   5Gi        RWO            grafana-gp2    1h
mongodb-pvc        Bound     pvc-1a6b0cf8-4b2b-11e9-9587-0e86fd254bd6   10Gi       RWO            mongodb-gp2    1h
zabbix-pvc         Bound     pvc-2df1e7d3-4b2b-11e9-9587-0e86fd254bd6   10Gi       RWO            zabbix-gp2     1h
```

2.  Edit it...
```
kubectl edit pvc data-es-master-1
```
...find the section where the PVC size is defined and change the size...
```
spec:
  accessModes:
  - ReadWriteOnce
  resources:
    requests:
      storage: 400Gi
  storageClassName: elastic-gp2
```
(this opens a VI editor...hit ESC then type "wq!" then hit ENTER to save the changes)

3.  Delete the stateful set that controls the pods...(only for elastic search cluster)
```
kubectl delete sts --cascade=false es-master
```

4. Edit the git/nokia-hvns/kubernetes/elasticsearch/elastic-allin1-prod.yaml file to update the volume size config...
```
nano elastic-allin1-prod.yaml

 volumeClaimTemplates:
  - metadata:
      name: data
    spec:
      accessModes:
        - ReadWriteOnce
      storageClassName: elastic-gp2
      # NOTE: You can increase the storage size
      resources:
        requests:
          storage: 400Gi
```
...and save the change.

5.  Re-create the stateful set by rerunning the whole config...(ony for elasticsearch)
```
kubectl create -f  elastic-allin1-prod.yaml
```
Only the stateful set get re-created as all the other objects still exist (i.e. pvc, pv, pod, svc)

6.  Delete each pod (ONE AT A TIME...especially for a cluster) which is bound to a PVC that you resized...
```
kubectl delete po <pod-name>
```
The pod should be deleted and automatically re-created by its stateful-set, deployment or replication controller.  It should be recreated with the new size PVC and PV.



