# elasticsearch
The ElasticSearch k8s application serves as data storage for the Graylog application. 

Graylog uses a deafult index called "graylog" to store all log files it receives.

This k8s file deploys ElasticSearch version 5.6.4 from the "quay.io/pires" repo.

* k8s files that end with "...ext.yaml" deploy publicly exposed loadbalancer 
IPs which should be used for testing only

* production deployments should used the k8s files that end in "...prod.yaml" only. 

The following objects are created with this file...

## Services
#### elasticsearch-discovery
A service for the ElasticSearch nodes to automatically discover each other and form a cluster.

#### elastic-master
A service for Graylog to perform read/write requests to the ElasticSearch db.

## Sorage class
#### elastic-gp2
We have a defined an EBS storage class using gp2 for EalsticSearch.  Even though this is the default 
we define it in case we ever need to change it to cheaper or a faster type storage class.

We choose a "retain" reclaimPolicy so that is the volume claim is ever deleted 
by accident the data is retained and can be manually recovered.

## Stateful set
#### es-master
The stateful set deploys ElasticSearch containers in a 3 node cluster all running as master, read and write nodes for simplicity. 
Each node gets deployed with a sequential naming scheme starting at 0 and up (i.e. es-master-0, es-master-1, ...) for well defined host addressing purposes.
Any new nodes cna be added by increasing the replica count and will also be master, read and write nodes.

We define a single persistent volume claim as a template within the statefyul set
which dynamically spawns the EBS persistent volume using the elastic-gp2 storage class previously defined.
