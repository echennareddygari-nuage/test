resource "aws_vpc" "vpcHosted" {
	cidr_block = "${var.vpcHostedCIDR}"
	enable_dns_support = true
	enable_dns_hostnames = true
	tags = "${
		map(
    		"Name", "vpcHosted",
			"Project", "${var.projectName}",
			"kubernetes.io/cluster/${var.eksClusterName}", "shared",
		)	
  	}"
}

resource "aws_vpc_ipv4_cidr_block_association" "vpcHosted2CIDR" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "${var.vpcHosted2CIDR}"
}

resource "aws_vpc_ipv4_cidr_block_association" "vpcHosted3CIDR" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "${var.vpcHosted3CIDR}"
}

resource "aws_vpc_ipv4_cidr_block_association" "vpcHoste43CIDR" {
        vpc_id = "${aws_vpc.vpcHosted.id}"
        cidr_block = "${var.vpcHosted4CIDR}"
}

resource "aws_vpc_ipv4_cidr_block_association" "vpcHosted5CIDR" {
        vpc_id = "${aws_vpc.vpcHosted.id}"
        cidr_block = "${var.vpcHosted5CIDR}"
}

resource "aws_internet_gateway" "IGW" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	tags {
    	Name = "IGW"
		Project = "${var.projectName}"
  	}
}

resource "aws_subnet" "vpcHostedCore1a" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "${var.vpcHostedCore1a}"
	availability_zone = "${var.awsAZ1}"
	tags {
    	Name = "vpcHostedCore1a"
		Project = "${var.projectName}"
  	}
}

resource "aws_subnet" "vpcHostedCore1b" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "${var.vpcHostedCore1b}"
	availability_zone = "${var.awsAZ2}"
	tags {
    	Name = "vpcHostedCore1b"
		Project = "${var.projectName}"
  	}
}

resource "aws_subnet" "vpcHostedCore1c" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "${var.vpcHostedCore1c}"
	availability_zone = "${var.awsAZ3}"
	tags {
    	Name = "vpcHostedCore1c"
		Project = "${var.projectName}"
  	}
}

resource "aws_subnet" "vpcHostedOps1a" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "${var.vpcHostedOps1a}"
	availability_zone = "${var.awsAZ1}"
	tags = "${
		map(
			"Name", "vpcHostedOps1a",
			"Project", "${var.projectName}",
			"kubernetes.io/cluster/${var.eksClusterName}", "shared",
			"kubernetes.io/role/internal-elb", "1",
		)
	}"
	
	depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHosted2CIDR"]
}

resource "aws_subnet" "vpcHostedOps1b" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "${var.vpcHostedOps1b}"
	availability_zone = "${var.awsAZ2}"
	tags = "${
		map(
			"Name", "vpcHostedOps1b",
			"Project", "${var.projectName}",
			"kubernetes.io/cluster/${var.eksClusterName}", "shared",
			"kubernetes.io/role/internal-elb", "1",
		)
	}"
	
	depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHosted2CIDR"]
}

resource "aws_subnet" "vpcHostedOps1c" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "${var.vpcHostedOps1c}"
	availability_zone = "${var.awsAZ3}"
	tags = "${
		map(
			"Name", "vpcHostedOps1c",
			"Project", "${var.projectName}",
			"kubernetes.io/cluster/${var.eksClusterName}", "shared",
			"kubernetes.io/role/internal-elb", "1",
		)
	}"

	depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHosted2CIDR"]
}

resource "aws_subnet" "vpcHostedPublic1a" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "${var.vpcHostedPublic1a}"
	availability_zone = "${var.awsAZ1}"
	tags {
    	Name = "vpcHostedPublic1a"
		Project = "${var.projectName}"
  	}

	depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHosted3CIDR"]
}

resource "aws_subnet" "vpcHostedPublic1b" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "${var.vpcHostedPublic1b}"
	availability_zone = "${var.awsAZ2}"
	tags {
    	Name = "vpcHostedPublic1b"
		Project = "${var.projectName}"
  	}

	depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHosted3CIDR"]
}

resource "aws_subnet" "vpcHostedPublic1c" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "${var.vpcHostedPublic1c}"
	availability_zone = "${var.awsAZ3}"
	tags {
    	Name = "vpcHostedPublic1c"
		Project = "${var.projectName}"
  	}

	depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHosted3CIDR"]
}


resource "aws_subnet" "vpcHostedMPLS1a" {
        vpc_id = "${aws_vpc.vpcHosted.id}"
        cidr_block = "${var.vpcHostedMPLS1a}"
        availability_zone = "${var.awsAZ1}"
        tags {
        Name = "vpcHostedMPLS1a"
                Project = "${var.projectName}"
        }

        depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHoste43CIDR"]
}

resource "aws_subnet" "vpcHostedMPLS1b" {
        vpc_id = "${aws_vpc.vpcHosted.id}"
        cidr_block = "${var.vpcHostedMPLS1b}"
        availability_zone = "${var.awsAZ2}"
        tags {
        Name = "vpcHostedMPLS1b"
                Project = "${var.projectName}"
        }

        depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHoste43CIDR"]
}

resource "aws_subnet" "vpcHostedMPLS1c" {
        vpc_id = "${aws_vpc.vpcHosted.id}"
        cidr_block = "${var.vpcHostedMPLS1c}"
        availability_zone = "${var.awsAZ3}"
        tags {
        Name = "vpcHostedMPLS1c"
                Project = "${var.projectName}"
        }

        depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHoste43CIDR"]
}

resource "aws_subnet" "vpcHostedMPLS2a" {
        vpc_id = "${aws_vpc.vpcHosted.id}"
        cidr_block = "${var.vpcHostedMPLS2a}"
        availability_zone = "${var.awsAZ1}"
        tags {
        Name = "vpcHostedMPLS2a"
                Project = "${var.projectName}"
        }

        depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHoste43CIDR"]
}

resource "aws_subnet" "vpcHostedMPLS2b" {
        vpc_id = "${aws_vpc.vpcHosted.id}"
        cidr_block = "${var.vpcHostedMPLS2b}"
        availability_zone = "${var.awsAZ2}"
        tags {
        Name = "vpcHostedMPLS2b"
                Project = "${var.projectName}"
        }

        depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHoste43CIDR"]
}

resource "aws_subnet" "vpcHostedMPLS2c" {
        vpc_id = "${aws_vpc.vpcHosted.id}"
        cidr_block = "${var.vpcHostedMPLS2c}"
        availability_zone = "${var.awsAZ3}"
        tags {
        Name = "vpcHostedMPLS2c"
                Project = "${var.projectName}"
        }

        depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHoste43CIDR"]
}


resource "aws_eip" "NATGWEIP" {
  vpc = true
}

resource "aws_nat_gateway" "NATGW1a" {
  allocation_id = "${aws_eip.NATGWEIP.id}"
  subnet_id     = "${aws_subnet.vpcHostedPublic1a.id}"

  tags {
    	Name = "NATGW1a"
		Project = "${var.projectName}"
  	}

  depends_on = ["aws_internet_gateway.IGW"]
}
resource "aws_route_table" "managementRT" {
	vpc_id = "${aws_vpc.vpcHosted.id}"

	tags {
		Name = "managementRT"
		Project = "${var.projectName}"
	}
}

resource "aws_route_table" "publicRT" {
	vpc_id = "${aws_vpc.vpcHosted.id}"

	tags {
		Name = "publicRT"
		Project = "${var.projectName}"
	}
}

resource "aws_route_table" "MPLS1RT" {
        vpc_id = "${aws_vpc.vpcHosted.id}"

        tags {
                Name = "MPLS1RT"
                Project = "${var.projectName}"
        }
}

resource "aws_route_table" "MPLS2RT" {
        vpc_id = "${aws_vpc.vpcHosted.id}"

        tags {
                Name = "MPLS2RT"
                Project = "${var.projectName}"
        }
}

resource "aws_main_route_table_association" "vpcHosted-mainRT" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	route_table_id = "${aws_route_table.managementRT.id}"
}

resource "aws_route_table_association" "vpcHostedCore1a" {
	subnet_id = "${aws_subnet.vpcHostedCore1a.id}"
	route_table_id = "${aws_route_table.managementRT.id}"
}

resource "aws_route_table_association" "vpcHostedCore1b" {
	subnet_id = "${aws_subnet.vpcHostedCore1b.id}"
	route_table_id = "${aws_route_table.managementRT.id}"
}

resource "aws_route_table_association" "vpcHostedCore1c" {
	subnet_id = "${aws_subnet.vpcHostedCore1c.id}"
	route_table_id = "${aws_route_table.managementRT.id}"
}

resource "aws_route_table_association" "vpcHostedOps1a" {
	subnet_id = "${aws_subnet.vpcHostedOps1a.id}"
	route_table_id = "${aws_route_table.managementRT.id}"
}

resource "aws_route_table_association" "vpcHostedOps1b" {
	subnet_id = "${aws_subnet.vpcHostedOps1b.id}"
	route_table_id = "${aws_route_table.managementRT.id}"
}

resource "aws_route_table_association" "vpcHostedOps1c" {
	subnet_id = "${aws_subnet.vpcHostedOps1c.id}"
	route_table_id = "${aws_route_table.managementRT.id}"
}

resource "aws_route_table_association" "vpcHostedPublic1a" {
	subnet_id = "${aws_subnet.vpcHostedPublic1a.id}"
	route_table_id = "${aws_route_table.publicRT.id}"
}

resource "aws_route_table_association" "vpcHostedPublic1b" {
	subnet_id = "${aws_subnet.vpcHostedPublic1b.id}"
	route_table_id = "${aws_route_table.publicRT.id}"
}

resource "aws_route_table_association" "vpcHostedPublic1c" {
	subnet_id = "${aws_subnet.vpcHostedPublic1c.id}"
	route_table_id = "${aws_route_table.publicRT.id}"
}

resource "aws_route_table_association" "vpcHostedMPLS1a" {
        subnet_id = "${aws_subnet.vpcHostedMPLS1a.id}"
        route_table_id = "${aws_route_table.MPLS1RT.id}"
}

resource "aws_route_table_association" "vpcHostedMPLS1b" {
        subnet_id = "${aws_subnet.vpcHostedMPLS1b.id}"
        route_table_id = "${aws_route_table.MPLS1RT.id}"
}

resource "aws_route_table_association" "vpcHostedMPLS1c" {
        subnet_id = "${aws_subnet.vpcHostedMPLS1c.id}"
        route_table_id = "${aws_route_table.MPLS1RT.id}"
}

resource "aws_route_table_association" "vpcHostedMPLS2a" {
        subnet_id = "${aws_subnet.vpcHostedMPLS2a.id}"
        route_table_id = "${aws_route_table.MPLS2RT.id}"
}

resource "aws_route_table_association" "vpcHostedMPLS2b" {
        subnet_id = "${aws_subnet.vpcHostedMPLS2b.id}"
        route_table_id = "${aws_route_table.MPLS2RT.id}"
}

resource "aws_route_table_association" "vpcHostedMPLS2c" {
        subnet_id = "${aws_subnet.vpcHostedMPLS2c.id}"
        route_table_id = "${aws_route_table.MPLS2RT.id}"
}


resource "aws_route" "route_internal_natgw" {
    route_table_id = "${aws_route_table.managementRT.id}"
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = "${aws_nat_gateway.NATGW1a.id}"
}

resource "aws_route" "route_internal_igw" {
    route_table_id = "${aws_route_table.publicRT.id}"
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.IGW.id}"
}

resource "aws_route" "route_internal_metal1" {
    route_table_id = "${aws_route_table.managementRT.id}"
    destination_cidr_block = "${var.mgmtMetal01}"
    network_interface_id = "${aws_network_interface.metal1Private.id}"
}

resource "aws_route" "route_internal_metal2" {
    route_table_id = "${aws_route_table.managementRT.id}"
    destination_cidr_block = "${var.mgmtMetal02}"
    network_interface_id = "${aws_network_interface.metal2Private.id}"
}
resource "aws_route" "route_internal_metal3" {
    route_table_id = "${aws_route_table.managementRT.id}"
    destination_cidr_block = "${var.mgmtMetal03}"
    network_interface_id = "${aws_network_interface.metal3Private.id}"
}

resource "aws_route" "route_jump_metal1" {
    route_table_id = "${aws_route_table.publicRT.id}"
    destination_cidr_block = "${var.mgmtMetal01}"
    network_interface_id = "${aws_network_interface.metal1Private.id}"
}
resource "aws_route" "route_jump_metal2" {
    route_table_id = "${aws_route_table.publicRT.id}"
    destination_cidr_block = "${var.mgmtMetal02}"
    network_interface_id = "${aws_network_interface.metal2Private.id}"
}
resource "aws_route" "route_jump_metal3" {
    route_table_id = "${aws_route_table.publicRT.id}"
    destination_cidr_block = "${var.mgmtMetal03}"
    network_interface_id = "${aws_network_interface.metal3Private.id}"
}

resource "aws_route" "route_pub_metal1" {
    route_table_id = "${aws_route_table.publicRT.id}"
    destination_cidr_block = "${var.publicMetal01}"
    network_interface_id = "${aws_network_interface.metal1Public.id}"
}
resource "aws_route" "route_pub_metal2" {
    route_table_id = "${aws_route_table.publicRT.id}"
    destination_cidr_block = "${var.publicMetal02}"
    network_interface_id = "${aws_network_interface.metal2Public.id}"
}

resource "aws_vpc_dhcp_options" "dhcpOptions" {
	domain_name = "${var.internalFQDN}"
	domain_name_servers = ["AmazonProvidedDNS"]
	ntp_servers = ["${var.providerNTP}"] 

	tags {
		Name = "dhcpOptions"
		Project = "${var.projectName}"
	}
}
resource "aws_vpc_dhcp_options_association" "vpcHosted-dhcpOptions" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	dhcp_options_id = "${aws_vpc_dhcp_options.dhcpOptions.id}"
}
