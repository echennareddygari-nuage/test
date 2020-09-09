# mongodb
The MongoDb k8s application serves as configuration storage for the Graylog application (single or cluster). 
The Graylog application has a single dB in mongo using the default "graylog" db name.

This k8s file deploys MongoDb version 3

* k8s files that end with "...ext.yaml" deploy publicly exposed loadbalancer 
IPs which should be used for testing only

* production deployments should used the k8s files that end in "...prod.yaml" only. 

The following objects are created with this file...

## Services
#### mongodb
A service for the master node only (only one master node in a cluster) which 
allows both read and write operations.  Since Graylog's requirements for mongodB are minimal
only a single node is deployed as a master with read/write cpability.  

Note: Since MongoDb only supports a single master (write node) the current config 
only deploys a single container since we have no current use for high volume load balanced read only operations.

## Sorage class
#### mongodb-gp2
We have a defined an EBS storage class using gp2 for MongoDb.  Even though this is the default 
we define it in case we ever need to change it to cheaper or a faster type storage class.

We choose a "retain" reclaimPolicy so that if the volume claim is ever deleted 
by accident the data is retained and can be manually recovered.

## Persistent volume claim
#### mongodb-pvc
We define a single persistent volume claim which dynamically spawns the EBS 
persistent volume using the mngodb-gp2 storage class previously defined.

## Deployment
#### mongo
The deployment createa a single container (cluster is not necessary for this use case) that 
is used to store the configuration for the Graylog application.