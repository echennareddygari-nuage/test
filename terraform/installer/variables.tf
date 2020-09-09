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
variable "installerInstanceType" {}
variable "toolsInstanceType" {}

variable "metalAMI" {}
variable "proxyAMI" {}
variable "jumpAMI" {}
variable "installerAMI" {}
variable "toolsAMI" {}
variable "eksVersion" {}
variable "eksWorkerAMI" {}


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
    default = "eksOps-stage"
}

variable "eksCluster2Name" {
    default = "eksOps2-stage"
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

variable installerRootDiskSize {
    default = "100"
}

variable metal1PrivateIP {
    default = "100.70.1.10"
}
variable metal1PublicIP {
    default = "100.72.1.10"
}
variable metal2PrivateIP {
    default = "100.70.2.10"
}
variable metal2PublicIP {
    default = "100.72.2.10"
}
variable metal3PrivateIP {
    default = "100.70.3.10"
}
variable metal3PublicIP {
    default = "100.72.3.10"
}
variable vsd1IP {
    default = "100.120.1.20"
}
variable vsd2IP {
    default = "100.120.2.20"
}
variable vsd3IP {
    default = "100.120.3.20"
}
variable es1IP {
    default = "100.120.1.21"
}
variable es2IP {
    default = "100.120.2.21"
}
variable es3IP {
    default = "100.120.3.21"
}
variable portal1IP {
    default = "100.120.1.22"
}
variable portal2IP {
    default = "100.120.2.22"
}
variable portal3IP {
    default = "100.120.3.22"
}
variable proxy1PrivateIP {
    default = "100.70.1.191"
}
variable proxy1PublicIP {
    default = "100.72.1.191"
}
variable proxy2PrivateIP {
    default = "100.70.2.192"
}
variable proxy2PublicIP {
    default = "100.72.2.192"
}
variable jump_metroPrivateIP {
    default = "100.72.1.100"
}

variable installerPrivateIP {
    default = "100.72.1.99"
}
