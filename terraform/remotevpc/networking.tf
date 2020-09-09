resource "aws_vpc" "vpcremoteHosted" {
	cidr_block = "${local.remotevpcHostedCIDR}"
	enable_dns_support = true
	enable_dns_hostnames = true
	tags = "${
		map(
    		"Name", "vpcremote${var.remotenumber}Hosted",
			"Project", "${var.projectName}",
		)	
  	}"
}


resource "aws_subnet" "remoteMGMTa" {
	vpc_id = "${aws_vpc.vpcremoteHosted.id}"
	cidr_block = "${local.remoteMGMTa}"
	availability_zone = "${var.awsAZ1}"
	tags {
    	Name = "remote${var.remotenumber}MGMTa"
		Project = "${var.projectName}"
  	}
}


resource "aws_subnet" "remoteMGMTb" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"
        cidr_block = "${local.remoteMGMTb}"
        availability_zone = "${var.awsAZ2}"
        tags {
        Name = "remote${var.remotenumber}MGMTb"
                Project = "${var.projectName}"
        }
}

resource "aws_subnet" "remoteMPLS1a" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"
        cidr_block = "${local.remoteMPLS1a}"
        availability_zone = "${var.awsAZ1}"
        tags {
        Name = "remote${var.remotenumber}MPLS1a"
                Project = "${var.projectName}"
        }
}


resource "aws_subnet" "remoteMPLS1b" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"
        cidr_block = "${local.remoteMPLS1b}"
        availability_zone = "${var.awsAZ2}"
        tags {
        Name = "remote${var.remotenumber}MPLS1b"
                Project = "${var.projectName}"
        }
}

resource "aws_subnet" "remoteMPLS2a" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"
        cidr_block = "${local.remoteMPLS2a}"
        availability_zone = "${var.awsAZ1}"
        tags {
        Name = "remote${var.remotenumber}MPLS2a"
                Project = "${var.projectName}"
        }
} 


resource "aws_subnet" "remoteMPLS2b" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"
        cidr_block = "${local.remoteMPLS2b}"
        availability_zone = "${var.awsAZ2}"
        tags {
        Name = "remote${var.remotenumber}MPLS2b"
                Project = "${var.projectName}"
        }
}

resource "aws_subnet" "remoteMPLS3a" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"
        cidr_block = "${local.remoteMPLS3a}"
        availability_zone = "${var.awsAZ1}"
        tags {
        Name = "remote${var.remotenumber}MPLS3a"
                Project = "${var.projectName}"
        }
} 


resource "aws_subnet" "remoteMPLS3b" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"
        cidr_block = "${local.remoteMPLS3b}"
        availability_zone = "${var.awsAZ2}"
        tags {
        Name = "remote${var.remotenumber}MPLS3b"
                Project = "${var.projectName}"
        }
}

resource "aws_subnet" "remoteMPLS4a" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"
        cidr_block = "${local.remoteMPLS4a}"
        availability_zone = "${var.awsAZ1}"
        tags {
        Name = "remote${var.remotenumber}MPLS4a"
                Project = "${var.projectName}"
        }
} 


resource "aws_subnet" "remoteMPLS4b" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"
        cidr_block = "${local.remoteMPLS4b}"
        availability_zone = "${var.awsAZ2}"
        tags {
        Name = "remote${var.remotenumber}MPLS4b"
                Project = "${var.projectName}"
        }
}


resource "aws_route_table" "remoteMGMTRT" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"

        tags {
                Name = "remote${var.remotenumber}MGMTRT"
                Project = "${var.projectName}"
        }
}

resource "aws_route_table" "remoteMPLS1RT" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"

        tags {
                Name = "remote${var.remotenumber}MPLS1RT"
                Project = "${var.projectName}"
        }
}


resource "aws_route_table" "remoteMPLS2RT" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"

        tags {
                Name = "remote${var.remotenumber}MPLS2RT"
                Project = "${var.projectName}"
        }
}

resource "aws_route_table" "remoteMPLS3RT" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"

        tags {
                Name = "remote${var.remotenumber}MPLS3RT"
                Project = "${var.projectName}"
        }
}

resource "aws_route_table" "remoteMPLS4RT" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"

        tags {
                Name = "remote${var.remotenumber}MPLS4RT"
                Project = "${var.projectName}"
        }
}

resource "aws_main_route_table_association" "vpc-remoteMGMTRT" {
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"
        route_table_id = "${aws_route_table.remoteMGMTRT.id}"
}

resource "aws_route_table_association" "vpc-remoteMGMTa" {
        subnet_id = "${aws_subnet.remoteMGMTa.id}"
        route_table_id = "${aws_route_table.remoteMGMTRT.id}"
}

resource "aws_route_table_association" "vpc-remoteMGMTb" {
        subnet_id = "${aws_subnet.remoteMGMTb.id}"
        route_table_id = "${aws_route_table.remoteMGMTRT.id}"
}

resource "aws_route_table_association" "vpc-remoteMPLS1a" {
        subnet_id = "${aws_subnet.remoteMPLS1a.id}"
        route_table_id = "${aws_route_table.remoteMPLS1RT.id}"
}

resource "aws_route_table_association" "vpc-remoteMPLS1b" {
        subnet_id = "${aws_subnet.remoteMPLS1b.id}"
        route_table_id = "${aws_route_table.remoteMPLS1RT.id}"
}

resource "aws_route_table_association" "vpc-remoteMPLS2a" {
        subnet_id = "${aws_subnet.remoteMPLS2a.id}"
        route_table_id = "${aws_route_table.remoteMPLS2RT.id}"
}

resource "aws_route_table_association" "vpc-remoteMPLS2b" {
        subnet_id = "${aws_subnet.remoteMPLS2b.id}"
        route_table_id = "${aws_route_table.remoteMPLS2RT.id}"
}

resource "aws_route_table_association" "vpc-remoteMPLS3a" {
        subnet_id = "${aws_subnet.remoteMPLS3a.id}"
        route_table_id = "${aws_route_table.remoteMPLS3RT.id}"
}

resource "aws_route_table_association" "vpc-remoteMPLS3b" {
        subnet_id = "${aws_subnet.remoteMPLS3b.id}"
        route_table_id = "${aws_route_table.remoteMPLS3RT.id}"
}

resource "aws_route_table_association" "vpc-remoteMPLS4a" {
        subnet_id = "${aws_subnet.remoteMPLS4a.id}"
        route_table_id = "${aws_route_table.remoteMPLS4RT.id}"
}

resource "aws_route_table_association" "vpc-remoteMPLS4b" {
        subnet_id = "${aws_subnet.remoteMPLS4b.id}"
        route_table_id = "${aws_route_table.remoteMPLS4RT.id}"
}

resource "aws_route" "route_jump_metal1" {
    route_table_id = "${aws_route_table.remoteMGMTRT.id}"
    destination_cidr_block = "${local.metal1privateCIDR}"
    network_interface_id = "${aws_network_interface.metal1Private.id}"
}

resource "aws_route" "route_jump_metal2" {
    route_table_id = "${aws_route_table.remoteMGMTRT.id}"
    destination_cidr_block = "${local.metal2privateCIDR}"
    network_interface_id = "${aws_network_interface.metal2Private.id}"
}

resource "aws_ec2_transit_gateway" "TGWMPLS1" {
  description = "remote${var.remotenumber}MPLS1TGW"
        tags {
                Name = "remote${var.remotenumber}MPLS1TGW"
                Project = "${var.projectName}"
        }
}

resource "aws_ec2_transit_gateway" "TGWMPLS2" {
  description = "remote${var.remotenumber}MPLS2TGW"
        tags {
                Name = "remote${var.remotenumber}MPLS2TGW"
                Project = "${var.projectName}"
        }
}


resource "aws_ec2_transit_gateway" "TGWMPLS3" {
  description = "remote${var.remotenumber}MPLS3TGW"
        tags {
                Name = "remote${var.remotenumber}MPLS3TGW"
                Project = "${var.projectName}"
        }
}


resource "aws_ec2_transit_gateway" "TGWMPLS4" {
  description = "remote${var.remotenumber}MPLS4TGW"
        tags {
                Name = "remote${var.remotenumber}MPLS4TGW"
                Project = "${var.projectName}"
        }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "remoteVPC-MPLS1" {
  subnet_ids         = ["${aws_subnet.remoteMPLS1a.id}", "${aws_subnet.remoteMPLS1b.id}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.TGWMPLS1.id}"
  vpc_id             = "${aws_vpc.vpcremoteHosted.id}"
        tags {
                Name = "remote${var.remotenumber}VPC-MPLS1"
                Project = "${var.projectName}"
        }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "remoteVPC-MPLS2" {
  subnet_ids         = ["${aws_subnet.remoteMPLS2a.id}", "${aws_subnet.remoteMPLS2b.id}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.TGWMPLS2.id}"
  vpc_id             = "${aws_vpc.vpcremoteHosted.id}"
        tags {
                Name = "remote${var.remotenumber}VPC-MPLS2"
                Project = "${var.projectName}"
        }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "remoteVPC-MPLS3" {
  subnet_ids         = ["${aws_subnet.remoteMPLS3a.id}", "${aws_subnet.remoteMPLS3b.id}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.TGWMPLS3.id}"
  vpc_id             = "${aws_vpc.vpcremoteHosted.id}"
        tags {
                Name = "remote${var.remotenumber}VPC-MPLS3"
                Project = "${var.projectName}"
        }
}

resource "aws_ec2_transit_gateway_vpc_attachment" "remoteVPC-MPLS4" {
  subnet_ids         = ["${aws_subnet.remoteMPLS4a.id}", "${aws_subnet.remoteMPLS4b.id}"]
  transit_gateway_id = "${aws_ec2_transit_gateway.TGWMPLS4.id}"
  vpc_id             = "${aws_vpc.vpcremoteHosted.id}"
        tags {
                Name = "remote${var.remotenumber}VPC-MPLS4"
                Project = "${var.projectName}"
        }
}

data "aws_ec2_transit_gateway_route_table" "MPLS1default" {
  filter {
    name   = "default-association-route-table"
    values = ["true"]
  }

  filter {
    name   = "transit-gateway-id"
    values = ["${aws_ec2_transit_gateway.TGWMPLS1.id}"]
  }
}

resource "null_resource" "tag-default-MPLS1RT" {
  provisioner "local-exec" {
    command = "aws ec2 create-tags --resources ${data.aws_ec2_transit_gateway_route_table.MPLS1default.id} --tags Key=Name,Value=remote${var.remotenumber}-MPLS1RT"
  }

  depends_on = ["aws_ec2_transit_gateway.TGWMPLS1"]
}


data "aws_ec2_transit_gateway_route_table" "MPLS2default" {
  filter {
    name   = "default-association-route-table"
    values = ["true"]
  }

  filter {
    name   = "transit-gateway-id"
    values = ["${aws_ec2_transit_gateway.TGWMPLS2.id}"]
  }
}

resource "null_resource" "tag-default-MPLS2RT" {
  provisioner "local-exec" {
    command = "aws ec2 create-tags --resources ${data.aws_ec2_transit_gateway_route_table.MPLS2default.id} --tags Key=Name,Value=remote${var.remotenumber}-MPLS2RT"
  }

  depends_on = ["aws_ec2_transit_gateway.TGWMPLS2"]
}


data "aws_ec2_transit_gateway_route_table" "MPLS3default" {
  filter {
    name   = "default-association-route-table"
    values = ["true"]
  }

  filter {
    name   = "transit-gateway-id"
    values = ["${aws_ec2_transit_gateway.TGWMPLS3.id}"]
  }
}

resource "null_resource" "tag-default-MPLS3RT" {
  provisioner "local-exec" {
    command = "aws ec2 create-tags --resources ${data.aws_ec2_transit_gateway_route_table.MPLS3default.id} --tags Key=Name,Value=remote${var.remotenumber}-MPLS3RT"
  }

  depends_on = ["aws_ec2_transit_gateway.TGWMPLS3"]
}

data "aws_ec2_transit_gateway_route_table" "MPLS4default" {
  filter {
    name   = "default-association-route-table"
    values = ["true"]
  }

  filter {
    name   = "transit-gateway-id"
    values = ["${aws_ec2_transit_gateway.TGWMPLS4.id}"]
  }
}

resource "null_resource" "tag-default-MPLS4RT" {
  provisioner "local-exec" {
    command = "aws ec2 create-tags --resources ${data.aws_ec2_transit_gateway_route_table.MPLS4default.id} --tags Key=Name,Value=remote${var.remotenumber}-MPLS4RT"
  }

  depends_on = ["aws_ec2_transit_gateway.TGWMPLS4"]
}

resource "aws_route" "MPLS1defRoute" {
  route_table_id            = "${aws_route_table.remoteMPLS1RT.id}"
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id = "${aws_ec2_transit_gateway.TGWMPLS1.id}"
  depends_on                = ["aws_ec2_transit_gateway.TGWMPLS1"]
}

resource "aws_route" "MPLS2defRoute" {
  route_table_id            = "${aws_route_table.remoteMPLS2RT.id}"
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id = "${aws_ec2_transit_gateway.TGWMPLS2.id}"
  depends_on                = ["aws_ec2_transit_gateway.TGWMPLS2"]
}

resource "aws_route" "MPLS3defRoute" {
  route_table_id            = "${aws_route_table.remoteMPLS3RT.id}"
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id = "${aws_ec2_transit_gateway.TGWMPLS3.id}"
  depends_on                = ["aws_ec2_transit_gateway.TGWMPLS3"]
}

resource "aws_route" "MPLS4defRoute" {
  route_table_id            = "${aws_route_table.remoteMPLS4RT.id}"
  destination_cidr_block    = "0.0.0.0/0"
  transit_gateway_id = "${aws_ec2_transit_gateway.TGWMPLS4.id}"
  depends_on                = ["aws_ec2_transit_gateway.TGWMPLS4"]
}


data "aws_vpc" "MainVPC" {
    cidr_block = "${var.vpcHostedCIDR}"

}
