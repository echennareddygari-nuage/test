resource "aws_vpc" "vpcHosted" {
	cidr_block = "10.0.0.0/22"
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
	cidr_block = "10.1.0.0/22"
}

resource "aws_vpc_ipv4_cidr_block_association" "vpcHosted3CIDR" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "10.100.0.0/22"
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
	cidr_block = "10.0.1.0/24"
	availability_zone = "${var.awsAZ1}"
	tags {
    	Name = "vpcHostedCore1a"
		Project = "${var.projectName}"
  	}
}

resource "aws_subnet" "vpcHostedCore1b" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "10.0.2.0/24"
	availability_zone = "${var.awsAZ2}"
	tags {
    	Name = "vpcHostedCore1b"
		Project = "${var.projectName}"
  	}
}

resource "aws_subnet" "vpcHostedCore1c" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "10.0.3.0/24"
	availability_zone = "${var.awsAZ3}"
	tags {
    	Name = "vpcHostedCore1c"
		Project = "${var.projectName}"
  	}
}

resource "aws_subnet" "vpcHostedOps1a" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "10.1.1.192/26"
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
	cidr_block = "10.1.2.192/26"
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
	cidr_block = "10.1.3.192/26"
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
	cidr_block = "10.100.1.0/24"
	availability_zone = "${var.awsAZ1}"
	tags {
    	Name = "vpcHostedPublic1a"
		Project = "${var.projectName}"
  	}

	depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHosted3CIDR"]
}

resource "aws_subnet" "vpcHostedPublic1b" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "10.100.2.0/24"
	availability_zone = "${var.awsAZ2}"
	tags {
    	Name = "vpcHostedPublic1b"
		Project = "${var.projectName}"
  	}

	depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHosted3CIDR"]
}

resource "aws_subnet" "vpcHostedPublic1c" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "10.100.3.0/24"
	availability_zone = "${var.awsAZ3}"
	tags {
    	Name = "vpcHostedPublic1c"
		Project = "${var.projectName}"
  	}

	depends_on = ["aws_vpc_ipv4_cidr_block_association.vpcHosted3CIDR"]
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
    destination_cidr_block = "192.168.1.0/24"
    network_interface_id = "${aws_network_interface.metal1Private.id}"
}

resource "aws_route" "route_internal_metal2" {
    route_table_id = "${aws_route_table.managementRT.id}"
    destination_cidr_block = "192.168.2.0/24"
    network_interface_id = "${aws_network_interface.metal2Private.id}"
}
resource "aws_route" "route_internal_metal3" {
    route_table_id = "${aws_route_table.managementRT.id}"
    destination_cidr_block = "192.168.3.0/24"
    network_interface_id = "${aws_network_interface.metal3Private.id}"
}

resource "aws_route" "route_jump_metal1" {
    route_table_id = "${aws_route_table.publicRT.id}"
    destination_cidr_block = "192.168.1.0/24"
    network_interface_id = "${aws_network_interface.metal1Private.id}"
}
resource "aws_route" "route_jump_metal2" {
    route_table_id = "${aws_route_table.publicRT.id}"
    destination_cidr_block = "192.168.2.0/24"
    network_interface_id = "${aws_network_interface.metal2Private.id}"
}
resource "aws_route" "route_jump_metal3" {
    route_table_id = "${aws_route_table.publicRT.id}"
    destination_cidr_block = "192.168.3.0/24"
    network_interface_id = "${aws_network_interface.metal3Private.id}"
}

resource "aws_route" "route_pub_metal1" {
    route_table_id = "${aws_route_table.publicRT.id}"
    destination_cidr_block = "192.168.101.0/24"
    network_interface_id = "${aws_network_interface.metal1Public.id}"
}
resource "aws_route" "route_pub_metal2" {
    route_table_id = "${aws_route_table.publicRT.id}"
    destination_cidr_block = "192.168.102.0/24"
    network_interface_id = "${aws_network_interface.metal2Public.id}"
}

resource "aws_vpc_dhcp_options" "dhcpOptions" {
	domain_name = "${var.internalFQDN}"
	domain_name_servers = ["AmazonProvidedDNS"]
	ntp_servers = ["169.254.169.123"] 

	tags {
		Name = "dhcpOptions"
		Project = "${var.projectName}"
	}
}
resource "aws_vpc_dhcp_options_association" "vpcHosted-dhcpOptions" {
	vpc_id = "${aws_vpc.vpcHosted.id}"
	dhcp_options_id = "${aws_vpc_dhcp_options.dhcpOptions.id}"
}
