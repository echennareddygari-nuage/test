# Terraform Notes

All tf files are collapsed during execution to a single planned file.  Variables are available to all files.

**ONLY terraform.tfvars should need to be modified.  If additional hard-coded values are discovered that need to be adapted, a variable should be added to variables.tf and defined in terraform.tfvars**

General workflow:

* Copy terraform.tfvars.example to terraform.tfvars
* Customize terraform.tfvars to include specific deployment information.

In general the terraform sequence is:

* terraform init # first run
* terraform import aws_iam_role.eksClusterRole service_eks_cluster
* terraform import aws_iam_role.eksWorkerRole service_ec2_eksnode
* terraform import aws_iam_instance_profile.eksWorkerProfile service_ec2_eksnode
* terraform plan
* terraform apply

Future changes would result in an approximate workflow of:

* git pull
* check terraform.tfvars.example for new variables
* add new defintions to local terraform.tfvars
* terraform plan
* terraform apply

*Notes:*

variables.tf containes values at the top that MUST be defined in terraform.tfvars.  It also includes a large number of variables that are defined but with defaults.  The default values should only be overriden in terraform.tfvars if a good reason exists.