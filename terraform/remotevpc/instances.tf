resource "aws_network_interface" "metal1Private" {
  subnet_id         = "${aws_subnet.remoteMGMTa.id}"
  private_ips       = ["${local.metal1PrivateIP}"]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPrivateSG.id}"]

  tags = {
    Name = "metal${var.remotemetal1}-eth0"
    Project = "${var.projectName}"
  }
}



resource "aws_network_interface" "metal2Private" {
  subnet_id         = "${aws_subnet.remoteMGMTb.id}"
  private_ips       = ["${local.metal2PrivateIP}"]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPrivateSG.id}"]

  tags = {
    Name = "metal${var.remotemetal2}-eth0"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal1MPLS1" {
  subnet_id         = "${aws_subnet.remoteMPLS1a.id}"
  private_ips       = ["${local.metal1MPLS1IP}", "${local.nuh1MPLS1IP}", "${local.remotevsc1MPLS1IP}" ]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicMPLS.id}"]

  tags = {
    Name = "metal${var.remotemetal1}-eth1"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal2MPLS1" {
  subnet_id         = "${aws_subnet.remoteMPLS1b.id}"
  private_ips       = ["${local.metal2MPLS1IP}", "${local.nuh2MPLS1IP}", "${local.remotevsc2MPLS1IP}" ]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicMPLS.id}"]

  tags = {
    Name = "metal${var.remotemetal2}-eth1"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal1MPLS2" {
  subnet_id         = "${aws_subnet.remoteMPLS2a.id}"
  private_ips       = ["${local.metal1MPLS2IP}", "${local.nuh1MPLS2IP}", "${local.remotevsc3MPLS2IP}" ]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicMPLS.id}"]

  tags = {
    Name = "metal${var.remotemetal1}-eth2"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal2MPLS2" {
  subnet_id         = "${aws_subnet.remoteMPLS2b.id}"
  private_ips       = ["${local.metal2MPLS2IP}", "${local.nuh2MPLS2IP}", "${local.remotevsc4MPLS2IP}" ]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicMPLS.id}"]

  tags = {
    Name = "metal${var.remotemetal2}-eth2"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal1MPLS3" {
  subnet_id         = "${aws_subnet.remoteMPLS3a.id}"
  private_ips       = ["${local.metal1MPLS3IP}", "${local.nuh1MPLS3IP}", "${local.remotevsc5MPLS3IP}" ]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicMPLS.id}"]

  tags = {
    Name = "metal${var.remotemetal1}-eth3"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal2MPLS3" {
  subnet_id         = "${aws_subnet.remoteMPLS3b.id}"
  private_ips       = ["${local.metal2MPLS3IP}", "${local.nuh2MPLS3IP}", "${local.remotevsc6MPLS3IP}" ]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicMPLS.id}"]

  tags = {
    Name = "metal${var.remotemetal2}-eth3"
    Project = "${var.projectName}"
  }
}


resource "aws_network_interface" "metal1MPLS4" {
  subnet_id         = "${aws_subnet.remoteMPLS4a.id}"
  private_ips       = ["${local.metal1MPLS4IP}", "${local.nuh1MPLS4IP}", "${local.remotevsc7MPLS4IP}" ]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicMPLS.id}"]

  tags = {
    Name = "metal${var.remotemetal1}-eth4"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal2MPLS4" {
  subnet_id         = "${aws_subnet.remoteMPLS4b.id}"
  private_ips       = ["${local.metal2MPLS4IP}", "${local.nuh2MPLS4IP}", "${local.remotevsc8MPLS4IP}" ]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicMPLS.id}"]

  tags = {
    Name = "metal${var.remotemetal2}-eth4"
    Project = "${var.projectName}"
  }
}



resource "aws_instance" "metal1" {
  ami           = "${var.remoteMetalAMI}"
  instance_type = "${var.remoteMetalInstanceType}"
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
        Name = "metal${var.remotemetal1}"
        Project = "${var.projectName}"
    }
}

resource "aws_network_interface_attachment" "metal1-eth1" {
  instance_id          = "${aws_instance.metal1.id}"
  network_interface_id = "${aws_network_interface.metal1MPLS1.id}"
  device_index         = 1

  depends_on = ["aws_instance.metal1"]
}

resource "aws_network_interface_attachment" "metal1-eth2" {
  instance_id          = "${aws_instance.metal1.id}"
  network_interface_id = "${aws_network_interface.metal1MPLS2.id}"
  device_index         = 2

  depends_on = ["aws_instance.metal1"]
}

resource "aws_network_interface_attachment" "metal1-eth3" {
  instance_id          = "${aws_instance.metal1.id}"
  network_interface_id = "${aws_network_interface.metal1MPLS3.id}"
  device_index         = 3

  depends_on = ["aws_instance.metal1"]
}

resource "aws_network_interface_attachment" "metal1-eth4" {
  instance_id          = "${aws_instance.metal1.id}"
  network_interface_id = "${aws_network_interface.metal1MPLS4.id}"
  device_index         = 4

  depends_on = ["aws_instance.metal1"]
}





resource "aws_instance" "metal2" {
  ami           = "${var.remoteMetalAMI}"
  instance_type = "${var.remoteMetalInstanceType}"
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
        Name = "metal${var.remotemetal2}"
        Project = "${var.projectName}"
    }
}



resource "aws_network_interface_attachment" "metal2-eth1" {
  instance_id          = "${aws_instance.metal2.id}"
  network_interface_id = "${aws_network_interface.metal2MPLS1.id}"
  device_index         = 1

  depends_on = ["aws_instance.metal2"]
}


resource "aws_network_interface_attachment" "metal2-eth2" {
  instance_id          = "${aws_instance.metal2.id}"
  network_interface_id = "${aws_network_interface.metal2MPLS2.id}"
  device_index         = 2

  depends_on = ["aws_instance.metal2"]
}
resource "aws_network_interface_attachment" "metal2-eth3" {
  instance_id          = "${aws_instance.metal2.id}"
  network_interface_id = "${aws_network_interface.metal2MPLS3.id}"
  device_index         = 3

  depends_on = ["aws_instance.metal2"]
}
resource "aws_network_interface_attachment" "metal2-eth4" {
  instance_id          = "${aws_instance.metal2.id}"
  network_interface_id = "${aws_network_interface.metal2MPLS4.id}"
  device_index         = 4

  depends_on = ["aws_instance.metal2"]
}

