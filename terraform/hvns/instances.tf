resource "aws_network_interface" "metal1Private" {
  subnet_id         = "${aws_subnet.vpcHostedCore1a.id}"
  private_ips       = ["${var.metal1PrivateIP}"]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPrivateSG.id}"]
  
  tags = {
    Name = "metal1-eth0"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal1Public" {
  subnet_id         = "${aws_subnet.vpcHostedPublic1a.id}"
  private_ips       = ["10.100.1.101", "10.100.1.103", "${var.metal1PublicIP}" ]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicSG.id}"]
  
  tags = {
    Name = "metal1-eth1"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal2Private" {
  subnet_id         = "${aws_subnet.vpcHostedCore1b.id}"
  private_ips       = ["${var.metal2PrivateIP}"]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPrivateSG.id}"]
  
  tags = {
    Name = "metal2-eth0"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal2Public" {
  subnet_id         = "${aws_subnet.vpcHostedPublic1b.id}"
  private_ips       = ["10.100.2.102", "10.100.2.104", "${var.metal2PublicIP}" ]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicSG.id}"]
  
  tags = {
    Name = "metal2-eth1"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal3Private" {
  subnet_id         = "${aws_subnet.vpcHostedCore1c.id}"
  private_ips       = ["${var.metal3PrivateIP}"]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPrivateSG.id}"]
  
  tags = {
    Name = "metal3-eth0"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal3Public" {
  subnet_id         = "${aws_subnet.vpcHostedPublic1c.id}"
  private_ips       = ["${var.metal3PublicIP}"]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicSG.id}"]
  
  tags = {
    Name = "metal3-eth1"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "proxy1Private" {
  subnet_id         = "${aws_subnet.vpcHostedCore1a.id}"
  private_ips       = ["${var.proxy1PrivateIP}"]
  security_groups   = ["${aws_security_group.proxyPrivateSG.id}"]
  
  tags = {
    Name = "proxy1-eth0"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "proxy1Public" {
  subnet_id         = "${aws_subnet.vpcHostedPublic1a.id}"
  private_ips       = ["${var.proxy1PublicIP}"]
  security_groups   = ["${aws_security_group.proxyPublicSG.id}"]
  
  tags = {
    Name = "proxy1-eth1"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "proxy2Private" {
  subnet_id         = "${aws_subnet.vpcHostedCore1b.id}"
  private_ips       = ["${var.proxy2PrivateIP}"]
  security_groups   = ["${aws_security_group.proxyPrivateSG.id}"]
  
  tags = {
    Name = "proxy2-eth0"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "proxy2Public" {
  subnet_id         = "${aws_subnet.vpcHostedPublic1b.id}"
  private_ips       = ["${var.proxy2PublicIP}"]
  security_groups   = ["${aws_security_group.proxyPublicSG.id}"]
  
  tags = {
    Name = "proxy2-eth1"
    Project = "${var.projectName}"
  }
}

resource "aws_instance" "metal1" {
  ami           = "${var.metalAMI}"
  instance_type = "${var.metalInstanceType}"
  availability_zone = "${var.awsAZ1}"
  key_name = "${var.awsKeyName}"
  network_interface {
    network_interface_id = "${aws_network_interface.metal1Private.id}"
    device_index         = 0
  }
  root_block_device = {
        volume_size = "${var.metalRootDiskSize}"
  }
  
  tags = {
        Name = "metal1"
        Project = "${var.projectName}"
    }
}

resource "aws_instance" "metal2" {
  ami           = "${var.metalAMI}"
  instance_type = "${var.metalInstanceType}"
  availability_zone = "${var.awsAZ2}"
  key_name = "${var.awsKeyName}"
  network_interface {
    network_interface_id = "${aws_network_interface.metal2Private.id}"
    device_index         = 0
  }
  root_block_device = {
        volume_size = "${var.metalRootDiskSize}"
  }

  tags = {
        Name = "metal2"
        Project = "${var.projectName}"
    }
}

resource "aws_instance" "metal3" {
  ami           = "${var.metalAMI}"
  instance_type = "${var.metalInstanceType}"
  availability_zone = "${var.awsAZ3}"
  key_name = "${var.awsKeyName}"
  network_interface {
    network_interface_id = "${aws_network_interface.metal3Private.id}"
    device_index         = 0
  }
  root_block_device = {
        volume_size = "${var.metalRootDiskSize}"
  }
    
  tags = {
        Name = "metal3"
        Project = "${var.projectName}"
    }
}

resource "aws_instance" "proxy1" {
  ami           = "${var.proxyAMI}"
  instance_type = "${var.proxyInstanceType}"
  availability_zone = "${var.awsAZ1}"
  key_name = "${var.awsKeyName}"
  network_interface {
    network_interface_id = "${aws_network_interface.proxy1Private.id}"
    device_index         = 0
  }
  root_block_device = {
        volume_size = "${var.proxyRootDiskSize}"
  }
    
  tags = {
        Name = "proxy1"
        Project = "${var.projectName}"
    }
}

resource "aws_instance" "proxy2" {
  ami           = "${var.proxyAMI}"
  instance_type = "${var.proxyInstanceType}"
  availability_zone = "${var.awsAZ2}"
  key_name = "${var.awsKeyName}"
  network_interface {
    network_interface_id = "${aws_network_interface.proxy2Private.id}"
    device_index         = 0
  }
  root_block_device = {
        volume_size = "${var.proxyRootDiskSize}"
  }
    
  tags = {
        Name = "proxy2"
        Project = "${var.projectName}"
    }
}

resource "aws_instance" "jump-metro" {
  ami           = "${var.jumpAMI}"
  instance_type = "${var.jumpInstanceType}"
  availability_zone = "${var.awsAZ1}"
  key_name = "${var.awsKeyName}"
  subnet_id = "${aws_subnet.vpcHostedPublic1a.id}"
  private_ip = "${var.jump_metroPrivateIP}"
  source_dest_check = false
  associate_public_ip_address = true
  vpc_security_group_ids = ["${aws_security_group.jumpPrivateSG.id}"]
  root_block_device = {
        volume_size = "${var.proxyRootDiskSize}"
  }
    
  tags = {
        Name = "jump/metro"
        Project = "${var.projectName}"
    }
}

resource "aws_instance" "tools01" {
  ami           = "${var.toolsAMI}"
  instance_type = "${var.toolsInstanceType}"
  availability_zone = "${var.awsAZ1}"
  key_name = "${var.awsKeyName}"
  subnet_id = "${aws_subnet.vpcHostedOps1a.id}"
  source_dest_check = false
  vpc_security_group_ids = ["${aws_security_group.toolsPrivateSG.id}"]
  root_block_device = {
        volume_size = "${var.toolsRootDiskSize}"
  }
    
  tags = {
        Name = "tools01"
        Project = "${var.projectName}"
    }
}

resource "aws_network_interface_attachment" "metal1-eth1" {
  instance_id          = "${aws_instance.metal1.id}"
  network_interface_id = "${aws_network_interface.metal1Public.id}"
  device_index         = 1

  depends_on = ["aws_instance.metal1"]
}

resource "aws_network_interface_attachment" "metal2-eth1" {
  instance_id          = "${aws_instance.metal2.id}"
  network_interface_id = "${aws_network_interface.metal2Public.id}"
  device_index         = 1

  depends_on = ["aws_instance.metal2"]
}

resource "aws_network_interface_attachment" "metal3-eth1" {
  instance_id          = "${aws_instance.metal3.id}"
  network_interface_id = "${aws_network_interface.metal3Public.id}"
  device_index         = 1

  depends_on = ["aws_instance.metal3"]
}

resource "aws_network_interface_attachment" "proxy1-eth1" {
  instance_id          = "${aws_instance.proxy1.id}"
  network_interface_id = "${aws_network_interface.proxy1Public.id}"
  device_index         = 1
  
  depends_on = ["aws_instance.proxy1"]
}

resource "aws_network_interface_attachment" "proxy2-eth1" {
  instance_id          = "${aws_instance.proxy2.id}"
  network_interface_id = "${aws_network_interface.proxy2Public.id}"
  device_index         = 1
  
  depends_on = ["aws_instance.proxy2"]
}
