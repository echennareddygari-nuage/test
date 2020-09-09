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

resource "aws_subnet" "vpcHostedPublic1a" {
# Imported
	vpc_id = "${aws_vpc.vpcHosted.id}"
	cidr_block = "10.100.1.0/24"
}

resource "aws_security_group" "jumpPrivateSG" {
# Imported
}

resource "aws_instance" "installer" {
  ami           = "${var.installerAMI}"
  instance_type = "${var.installerInstanceType}"
  availability_zone = "${var.awsAZ1}"
  key_name = "${var.awsKeyName}"
  subnet_id = "${aws_subnet.vpcHostedPublic1a.id}"
  private_ip = "${var.installerPrivateIP}"
  source_dest_check = false
  associate_public_ip_address = true
  iam_instance_profile = "${aws_iam_instance_profile.installerS3AccessInstanceProfile.name}"
  vpc_security_group_ids = ["${aws_security_group.jumpPrivateSG.id}"]
  root_block_device = {
        volume_size = "${var.installerRootDiskSize}"
  }
    
  tags = {
        Name = "installer"
        Project = "${var.projectName}"
    }
}