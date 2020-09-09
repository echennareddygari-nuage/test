#The following variables should be explicitly defined in terraform.tfvars
# for each deployment.  They must use appropriate values for the region
# and type of deployment (dev/staging/production).

# DO NOT SET DEFAULTS FOR THESE VALUES IN THIS FILE.

variable "awsAccessKey" {}
variable "awsSecretKey" {}
variable "awsRegion" {}

variable "nuageVersion" {}

variable "awsAZ1" {}
variable "awsAZ2" {}
variable "awsAZ3" {}
variable "nuage-files-s3bucket" {}

variable "aws-account" {}

variable "awsKeyName" {}

variable "projectName" {}
variable "internalFQDN" {}
variable "metalInstanceType" {}
variable "proxyInstanceType" {}
variable "eksInstanceType" {}
variable "jumpInstanceType" {}
variable "toolsInstanceType" {}
variable "webfilterInstanceType" {}
variable "NUHInstanceType" {}
variable "remoteMetalInstanceType" {}


variable "metalAMI" {}
variable "proxyAMI" {}
variable "jumpAMI" {}
variable "toolsAMI" {}
variable "eksVersion" {}
variable "eksWorkerAMI" {}
variable "webfilterAMI" {}
variable "NUHAMI" {}
variable "remoteMetalAMI" {}


# The following are sane defaults for all deployments - only modify in terraform.tfvars if you know
# what you are doing.  Changes will impact other tooling and metro deployments potentially.

# DO NOT MODIFY DEFAULTS FOR THESE VALUES IN THIS FILE.


variable "awsSharedCredentials" {
    default = "~/.aws/credentials"
}
variable proxyRootDiskSize {
    default = "50"
}

variable metalRootDiskSize {
    default = "50"
}

variable "internalDNSTTL" {
    default = "300"
}



## REMOTE SUBNETS

variable remotenumber {
    default = "0"
}

variable remotemetal1 {
    default = "06"
}

variable remotemetal2 {
    default = "07"
}


locals {
    remotevpcHostedCIDR = "100.64.${floor(var.remotenumber)}.0/24"
    remoteMGMTa = "100.64.${floor(var.remotenumber)}.0/26"
    remoteMGMTb = "100.64.${floor(var.remotenumber)}.64/26"
    remoteMPLS1a = "100.64.${floor(var.remotenumber)}.128/28"
    remoteMPLS1b = "100.64.${floor(var.remotenumber)}.144/28"
    remoteMPLS2a = "100.64.${floor(var.remotenumber)}.160/28"
    remoteMPLS2b = "100.64.${floor(var.remotenumber)}.176/28"
    remoteMPLS3a = "100.64.${floor(var.remotenumber)}.192/28"
    remoteMPLS3b = "100.64.${floor(var.remotenumber)}.208/28"
    remoteMPLS4a = "100.64.${floor(var.remotenumber)}.224/28"
    remoteMPLS4b = "100.64.${floor(var.remotenumber)}.240/28"
}


## ROUTE 53 ARPA

## INSTANCE IP

variable providerNTP {
    default = "168.254.169.123"
}

variable vpcHostedCIDR {
    default = "100.70.0.0/16"
}

variable vpcHosted2CIDR {
    default = "100.71.0.0/16"
}

variable vpcHosted3CIDR {
    default = "100.72.0.0/16"
}

variable vpcHosted4CIDR {
    default = "100.73.0.0/16"
}

variable vpcHosted5CIDR {
    default = "100.74.0.0/16"
}

locals {
    
    metal1privateCIDR = "100.120.${floor(var.remotemetal1)}.0/24"
    metal1PrivateIP = "100.64.${floor(var.remotenumber)}.6"
    metal1MPLS1IP =  "100.64.${floor(var.remotenumber)}.136"
    metal1MPLS2IP = "100.64.${floor(var.remotenumber)}.166"
    metal1MPLS3IP = "100.64.${floor(var.remotenumber)}.196"
    metal1MPLS4IP =  "100.64.${floor(var.remotenumber)}.236"

    metal2privateCIDR = "100.120.${floor(var.remotemetal2)}.0/24"
    metal2PrivateIP = "100.64.${floor(var.remotenumber)}.68"
    metal2MPLS1IP = "100.64.${floor(var.remotenumber)}.148"
    metal2MPLS2IP = "100.64.${floor(var.remotenumber)}.188"
    metal2MPLS3IP = "100.64.${floor(var.remotenumber)}.218"
    metal2MPLS4IP = "100.64.${floor(var.remotenumber)}.248"
    

    nuh1PrivateIP = "100.64.${floor(var.remotenumber)}.7"
    nuh1internalIP = "100.64.${floor(var.remotenumber)}.8"
    nuh1MPLS1IP = "100.64.${floor(var.remotenumber)}.137"
    nuh1MPLS2IP = "100.64.${floor(var.remotenumber)}.167"
    nuh1MPLS3IP = "100.64.${floor(var.remotenumber)}.197"
    nuh1MPLS4IP = "100.64.${floor(var.remotenumber)}.237"


    nuh2PrivateIP = "100.64.${floor(var.remotenumber)}.69"
    nuh2internalIP = "100.64.${floor(var.remotenumber)}.70"
    nuh2MPLS1IP = "100.64.${floor(var.remotenumber)}.149"
    nuh2MPLS2IP = "100.64.${floor(var.remotenumber)}.189"
    nuh2MPLS3IP = "100.64.${floor(var.remotenumber)}.219"
    nuh2MPLS4IP = "100.64.${floor(var.remotenumber)}.249"


    remotevsc1privateIP = "100.120.${floor(var.remotemetal1)}.101"
    remotevsc1MPLS1IP = "100.64.${floor(var.remotenumber)}.138"

    remotevsc2privateIP = "100.120.${floor(var.remotemetal2)}.102"
    remotevsc2MPLS1IP = "100.64.${floor(var.remotenumber)}.150"

    remotevsc3privateIP = "100.120.${floor(var.remotemetal1)}.103"
    remotevsc3MPLS2IP = "100.64.${floor(var.remotenumber)}.168"

    remotevsc4privateIP = "100.120.${floor(var.remotemetal2)}.104"
    remotevsc4MPLS2IP = "100.64.${floor(var.remotenumber)}.190"

    remotevsc5privateIP = "100.120.${floor(var.remotemetal1)}.105"
    remotevsc5MPLS3IP = "100.64.${floor(var.remotenumber)}.198"

    remotevsc6privateIP = "100.120.${floor(var.remotemetal2)}.104"
    remotevsc6MPLS3IP = "100.64.${floor(var.remotenumber)}.220"

    remotevsc7privateIP = "100.120.${floor(var.remotemetal1)}.107"
    remotevsc7MPLS4IP = "100.64.${floor(var.remotenumber)}.228"

    remotevsc8privateIP = "100.120.${floor(var.remotemetal2)}.108"
    remotevsc8MPLS4IP = "100.64.${floor(var.remotenumber)}.250"
}
