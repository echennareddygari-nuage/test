# The following variables should be explicitly defined in terraform.tfvars
# for each deployment.  They must use appropriate values for the region
# and type of deployment (dev/staging/production).

# DO NOT SET DEFAULTS FOR THESE VALUES IN THIS FILE.

variable "awsAccessKey" {
}

variable "awsSecretKey" {
}

variable "awsRegion" {
}

variable "nuageVersion" {
}

variable "awsAZ1" {
}

variable "awsAZ2" {
}

variable "awsAZ3" {
}

variable "nuage-files-s3bucket" {
}

variable "aws-account" {
}

variable "awsKeyName" {
}

variable "projectName" {
}

variable "internalFQDN" {
}

variable "metalInstanceType" {
}

variable "proxyInstanceType" {
}

variable "eksInstanceType" {
}

variable "jumpInstanceType" {
}

variable "toolsInstanceType" {
}

variable "webfilterInstanceType" {
}

variable "NUHInstanceType" {
}

variable "metalAMI" {
}

variable "proxyAMI" {
}

variable "jumpAMI" {
}

variable "toolsAMI" {
}

variable "eksVersion" {
}

variable "eksWorkerAMI" {
}

variable "webfilterAMI" {
}

variable "NUHAMI" {
}

variable "vsc01EIP" {
}

variable "vsc02EIP" {
}

variable "vsc03EIP" {
}

variable "vsc04EIP" {
}

variable "nokiaProxyCIDR1" {
}

variable "nokiaProxyCIDR2" {
}

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

variable "metalRootDiskSize" {
  default = "300"
}

variable "proxyRootDiskSize" {
  default = "50"
}

variable "toolsRootDiskSize" {
  default = "20"
}

variable "webfilterRootDiskSize" {
  default = "245"
}

## SUBNETS

variable "vpcHostedCIDR" {
  default = "100.70.0.0/16"
}

variable "vpcHosted2CIDR" {
  default = "100.71.0.0/16"
}

variable "vpcHosted3CIDR" {
  default = "100.72.0.0/16"
}

variable "vpcHosted4CIDR" {
  default = "100.73.0.0/16"
}

variable "vpcHosted5CIDR" {
  default = "100.74.0.0/16"
}

variable "vpcHostedCore1a" {
  default = "100.70.1.0/24"
}

variable "vpcHostedCore1b" {
  default = "100.70.2.0/24"
}

variable "vpcHostedCore1c" {
  default = "100.70.3.0/24"
}

variable "vpcHostedOps1a" {
  default = "100.71.1.192/26"
}

variable "vpcHostedOps1b" {
  default = "100.71.2.192/26"
}

variable "vpcHostedOps1c" {
  default = "100.71.3.192/26"
}

variable "vpcHostedPublic1a" {
  default = "100.72.1.0/24"
}

variable "vpcHostedPublic1b" {
  default = "100.72.2.0/24"
}

variable "vpcHostedPublic1c" {
  default = "100.72.3.0/24"
}

variable "vpcHostedMPLS1a" {
  default = "100.73.1.0/28"
}

variable "vpcHostedMPLS1b" {
  default = "100.73.2.0/28"
}

variable "vpcHostedMPLS1c" {
  default = "100.73.3.0/28"
}

variable "vpcHostedMPLS2a" {
  default = "100.73.1.16/28"
}

variable "vpcHostedMPLS2b" {
  default = "100.73.2.16/28"
}

variable "vpcHostedMPLS2c" {
  default = "100.73.3.16/28"
}

variable "mgmtMetalCIDR" {
  default = "100.120.0.0/22"
}

variable "mgmtMetal01" {
  default = "100.120.1.0/24"
}

variable "mgmtMetal02" {
  default = "100.120.2.0/24"
}

variable "mgmtMetal03" {
  default = "100.120.3.0/24"
}

variable "publicMetal01" {
  default = "100.121.1.0/24"
}

variable "publicMetal02" {
  default = "100.121.2.0/24"
}

## ROUTE 53 ARPA

variable "reverseVSDName" {
  default = "70.100.in-addr.arpa"
}

variable "reverseVSD1Name" {
  default = "20.1.70.100.in-addr.arpa"
}

variable "reverseVSD2Name" {
  default = "20.2.70.100.in-addr.arpa"
}

variable "reverseVSD3Name" {
  default = "20.3.70.100.in-addr.arpa"
}

## INSTANCE IP

variable "providerNTP" {
  default = "168.254.169.123"
}

variable "metal1PrivateIP" {
  default = "100.70.1.10"
}

variable "metal1PublicIP" {
  default = "100.72.1.10"
}

variable "metal1MPLS1IP" {
  default = "100.73.1.10"
}

variable "metal1MPLS2IP" {
  default = "100.73.1.20"
}

variable "metal2PrivateIP" {
  default = "100.70.2.10"
}

variable "metal2PublicIP" {
  default = "100.72.2.10"
}

variable "metal2MPLS1IP" {
  default = "100.73.2.10"
}

variable "metal2MPLS2IP" {
  default = "100.73.2.20"
}

variable "metal3PrivateIP" {
  default = "100.70.3.10"
}

variable "metal3PublicIP" {
  default = "100.72.3.10"
}

variable "metal3MPLS1IP" {
  default = "100.73.3.10"
}

variable "metal3MPLS2IP" {
  default = "100.73.3.20"
}

variable "webfilter1IP" {
  default = "100.70.1.30"
}

variable "webfilter2IP" {
  default = "100.70.2.30"
}

variable "vsd1IP" {
  default = "100.120.1.20"
}

variable "vsd2IP" {
  default = "100.120.2.20"
}

variable "vsd3IP" {
  default = "100.120.3.20"
}

variable "es1IP" {
  default = "100.120.1.21"
}

variable "es2IP" {
  default = "100.120.2.21"
}

variable "es3IP" {
  default = "100.120.3.21"
}

variable "portal1IP" {
  default = "100.120.1.22"
}

variable "portal2IP" {
  default = "100.120.2.22"
}

variable "portal3IP" {
  default = "100.120.3.22"
}

variable "proxy1PrivateIP" {
  default = "100.70.1.191"
}

variable "proxy1PublicIP" {
  default = "100.72.1.191"
}

variable "proxy2PrivateIP" {
  default = "100.70.2.192"
}

variable "proxy2PublicIP" {
  default = "100.72.2.192"
}

variable "proxy3PrivateIP" {
  default = "100.70.1.193"
}

variable "proxy3InternalIP" {
  default = "100.70.1.183"
}

variable "proxy3MPLS1IP" {
  default = "100.73.1.13"
}

variable "proxy3MPLS2IP" {
  default = "100.73.1.23"
}

variable "proxy4PrivateIP" {
  default = "100.70.2.194"
}

variable "proxy4InternalIP" {
  default = "100.70.2.184"
}

variable "proxy4MPLS1IP" {
  default = "100.73.2.14"
}

variable "proxy4MPLS2IP" {
  default = "100.73.2.24"
}

variable "jump_metroPrivateIP" {
  default = "100.72.1.100"
}

variable "vsc1PublicIP" {
  default = "100.72.1.101"
}

variable "vsc2PublicIP" {
  default = "100.72.2.102"
}

variable "vsc3PublicIP" {
  default = "100.72.1.103"
}

variable "vsc4PublicIP" {
  default = "100.72.2.104"
}

variable "vsc5MPLS1IP" {
  default = "100.73.1.5"
}

variable "vsc6MPLS1IP" {
  default = "100.73.3.6"
}

variable "vsc7MPLS2IP" {
  default = "100.73.2.27"
}

variable "vsc8MPLS2IP" {
  default = "100.73.3.28"
}

variable "vsc1PrivateIP" {
  default = "100.120.1.101"
}

variable "vsc2PrivateIP" {
  default = "100.120.2.102"
}

variable "vsc3PrivateIP" {
  default = "100.120.1.103"
}

variable "vsc4PrivateIP" {
  default = "100.120.2.104"
}

variable "vsc5PrivateIP" {
  default = "100.120.1.105"
}

variable "vsc6PrivateIP" {
  default = "100.120.3.106"
}

variable "vsc7PrivateIP" {
  default = "100.120.2.107"
}

variable "vsc8PrivateIP" {
  default = "100.120.3.108"
}

