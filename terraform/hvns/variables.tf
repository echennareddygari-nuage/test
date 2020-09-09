# The following variables should be explicitly defined in terraform.tfvars
# for each deployment.  They must use appropriate values for the region
# and type of deployment (dev/staging/production).

# DO NOT SET DEFAULTS FOR THESE VALUES IN THIS FILE.

variable "awsAccessKey" {}
variable "awsSecretKey" {}
variable "awsRegion" {}


variable "awsAZ1" {}
variable "awsAZ2" {}
variable "awsAZ3" {}

variable "awsKeyName" {}


variable "projectName" {}
variable "internalFQDN" {}
variable "metalInstanceType" {}
variable "proxyInstanceType" {}
variable "eksInstanceType" {}
variable "jumpInstanceType" {}
variable "toolsInstanceType" {}

variable "metalAMI" {}
variable "proxyAMI" {}
variable "jumpAMI" {}
variable "toolsAMI" {}

# The following are sane defaults for all deployments - only modify in terraform.tfvars if you know
# what you are doing.  Changes will impact other tooling and metro deployments potentially.

# DO NOT MODIFY DEFAULTS FOR THESE VALUES IN THIS FILE.


variable "awsSharedCredentials" {
    default = "~/.aws/credentials"
}
variable "internalDNSTTL" {
    default = "300"
}
variable "eksClusterName" {
    default = "eksOps"
}

variable "eksCluster2Name" {
    default = "eksOps2"
}
variable metalRootDiskSize {
    default = "300"
}
variable proxyRootDiskSize {
    default = "30"
}

variable toolsRootDiskSize {
    default = "20"
}

variable metal1PrivateIP {
    default = "10.0.1.10"
}
variable metal1PublicIP {
    default = "10.100.1.10"
}
variable metal2PrivateIP {
    default = "10.0.2.10"
}
variable metal2PublicIP {
    default = "10.100.2.10"
}
variable metal3PrivateIP {
    default = "10.0.3.10"
}
variable metal3PublicIP {
    default = "10.100.3.10"
}
variable vsd1IP {
    default = "192.168.1.20"
}
variable vsd2IP {
    default = "192.168.2.20"
}
variable vsd3IP {
    default = "192.168.3.20"
}
variable es1IP {
    default = "192.168.1.21"
}
variable es2IP {
    default = "192.168.2.21"
}
variable es3IP {
    default = "192.168.3.21"
}
variable portal1IP {
    default = "192.168.1.22"
}
variable portal2IP {
    default = "192.168.2.22"
}
variable portal3IP {
    default = "192.168.3.22"
}
variable proxy1PrivateIP {
    default = "10.0.1.191"
}
variable proxy1PublicIP {
    default = "10.100.1.191"
}
variable proxy2PrivateIP {
    default = "10.0.2.192"
}
variable proxy2PublicIP {
    default = "10.100.2.192"
}
variable jump_metroPrivateIP {
    default = "10.100.1.100"
}