# grafana
The Grafana k8s application is deployed as a single instance by default but can be scaled up as necessary by adding replicas
of the grafana deployment.

All Grafana nodes use the same dedicated grafana dB (mysql) application deployed in the allin1 configuration 
for persistent configuration acros all nodes.

This k8s file dpeloys Grafana version 5.4.2. 

* k8s files that end with "...ext.yaml" deploy publicly exposed loadbalancer 
IPs which should be used for testing only.  
* Production deployment should used 
the k8s files that end in "...prod.yaml" only. 

The following objects are created with this file...

## Storage classes
#### grafana-gp2
We have a defined an EBS storage class using gp2 for the Grafana mysql container.  
Even though this is the default we define it in case we ever need to change it to cheaper or a faster type storage class.

We choose a "retain" reclaimPolicy so that is the volume claim is ever deleted 
by accident the data is retained and can be manually recovered.

## Persisten volume claims
#### grafana-pvc
WE define a persistent colume claim which causes the dynamic creation of of persisten volume
in EBS using the garafan-gp2 storage class previosuly defined.

This only requires a small size volume as Grafana confgiuration storage requirments are low. (e.g. 5 GB)


## Services
#### grafana 
A service for the Grafana node(s) load balances equally among all nodes in the cluster. 
All nodes are equivalent (no master/slave concept) therefore any connection is 
indistiguishamble from any other regardless of the node serving the session.

Session state is persisted in the mysql dB so that a user request can be directed to any
available grafana node without requiring a new login.  It also means new Grafana 
nodes can be added dynamically with no interruption to ongoing sessions.

#### grafana-db
A service to expose the grafana mysql DB backend to the main grafana appllication.
Only standard mysql port 3306 is exposed and forwarded and reachjable at the 
"grafana-db" hostname.


## Deployment
#### grafana
The deployment creates a single grafana node which can be scaled up if necesary to mutlitple
replicas.  The Grafana persistent configuration for all nodes point to a single backend dB provided by 
the grafana mysql container.  No persistenct storage is required within the Grafana container.

Grafana plugins and data source modules are dynamiacaly loaded at container 
creation time and can be modified by adding/removing module names in the GF_INSTALL_PLUGINS
environment variable.  They are stored in a temporary on-disk volume which is recreated every
time a new node is added to the cluster.

#### grafana-db
This deployment created a single node mysql container that serves as the persisten 
configuration storage for one of more Grafana application.  Session state is also preserved 
in this dB so that new front end containers can be deployed live without
causing any session state errors.

This is a single node depoyment with read/write access.  This confgiuration does not
support more than one replica (no multi-node mysql clusters).

A dedicated dB within called (grafana) must be manually created in order for Grafan application to use it.

After the mysql container has started you can run this command to create the dB...

```kubectl run mysql-client --image=mysql:5.7 -i --rm --restart=Never -- mysql -pAlcateldc -h mysql <<EOF
create database if not exists grafana;
grant all privileges on grafana.* to grafana@'%' identified by "grafana";
flush privileges;
exit
EOF
```
