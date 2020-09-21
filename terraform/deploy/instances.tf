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
  private_ips       = ["${var.vsc1PublicIP}", "${var.vsc3PublicIP}", "${var.metal1PublicIP}" ]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicSG.id}"]
  
  tags = {
    Name = "metal1-eth1"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal1MPLS1" {
  subnet_id         = "${aws_subnet.vpcHostedMPLS1a.id}"
  private_ips       = ["${var.vsc5MPLS1IP}","${var.metal1MPLS1IP}"]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicSG.id}"]

  tags = {
    Name = "metal1-eth2"
    Project = "${var.projectName}"
  }
}
resource "aws_network_interface" "metal1MPLS2" {
  subnet_id         = "${aws_subnet.vpcHostedMPLS2a.id}"
  private_ips       = ["${var.metal1MPLS2IP}"]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicSG.id}"]

  tags = {
    Name = "metal1-eth3"
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
  private_ips       = ["${var.vsc2PublicIP}", "${var.vsc4PublicIP}", "${var.metal2PublicIP}" ]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicSG.id}"]
  
  tags = {
    Name = "metal2-eth1"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal2MPLS1" {
  subnet_id         = "${aws_subnet.vpcHostedMPLS1b.id}"
  private_ips       = ["${var.metal2MPLS1IP}"]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicSG.id}"]

  tags = {
    Name = "metal2-eth2"
    Project = "${var.projectName}"
  }
}
resource "aws_network_interface" "metal2MPLS2" {
  subnet_id         = "${aws_subnet.vpcHostedMPLS2b.id}"
  private_ips       = ["${var.vsc7MPLS2IP}","${var.metal2MPLS2IP}"]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicSG.id}"]

  tags = {
    Name = "metal2-eth3"
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

resource "aws_network_interface" "metal3MPLS1" {
  subnet_id         = "${aws_subnet.vpcHostedMPLS1c.id}"
  private_ips       = ["${var.vsc6MPLS1IP}","${var.metal3MPLS1IP}"]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicSG.id}"]

  tags = {
    Name = "metal3-eth2"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "metal3MPLS2" {
  subnet_id         = "${aws_subnet.vpcHostedMPLS2c.id}"
  private_ips       = ["${var.vsc8MPLS2IP}","${var.metal3MPLS2IP}"]
  source_dest_check = false
  security_groups   = ["${aws_security_group.metalPublicSG.id}"]

  tags = {
    Name = "metal3-eth3"
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


resource "aws_network_interface" "proxy3Private" {
  subnet_id         = "${aws_subnet.vpcHostedCore1a.id}"
  private_ips       = ["${var.proxy3PrivateIP}"]
  security_groups   = ["${aws_security_group.proxyPrivateSG.id}"]

  tags = {
    Name = "proxy3-eth0"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "proxy3Internal" {
  subnet_id         = "${aws_subnet.vpcHostedCore1a.id}"
  private_ips       = ["${var.proxy3InternalIP}"]
  security_groups   = ["${aws_security_group.proxyPrivateSG.id}"]

  tags = {
    Name = "proxy3-eth1"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "proxy3MPLS1" {
  subnet_id         = "${aws_subnet.vpcHostedMPLS1a.id}"
  private_ips       = ["${var.proxy3MPLS1IP}"]
  security_groups   = ["${aws_security_group.proxyMPLSSG.id}"]

  tags = {
    Name = "proxy3-eth2"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "proxy3MPLS2" {
  subnet_id         = "${aws_subnet.vpcHostedMPLS2a.id}"
  private_ips       = ["${var.proxy3MPLS2IP}"]
  security_groups   = ["${aws_security_group.proxyMPLSSG.id}"]

  tags = {
    Name = "proxy3-eth3"
    Project = "${var.projectName}"
  }
}


resource "aws_network_interface" "proxy4Private" {
  subnet_id         = "${aws_subnet.vpcHostedCore1b.id}"
  private_ips       = ["${var.proxy4PrivateIP}"]
  security_groups   = ["${aws_security_group.proxyPrivateSG.id}"]
 
  tags = {
    Name = "proxy4-eth0"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "proxy4Internal" {
  subnet_id         = "${aws_subnet.vpcHostedCore1b.id}"
  private_ips       = ["${var.proxy4InternalIP}"]
  security_groups   = ["${aws_security_group.proxyPrivateSG.id}"]

  tags = {
    Name = "proxy4-eth1"
    Project = "${var.projectName}"
  }
}


resource "aws_network_interface" "proxy4MPLS1" {
  subnet_id         = "${aws_subnet.vpcHostedMPLS1b.id}"
  private_ips       = ["${var.proxy4MPLS1IP}"]
  security_groups   = ["${aws_security_group.proxyMPLSSG.id}"]

  tags = {
    Name = "proxy4-eth2"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "proxy4MPLS2" {
  subnet_id         = "${aws_subnet.vpcHostedMPLS2b.id}"
  private_ips       = ["${var.proxy4MPLS2IP}"]
  security_groups   = ["${aws_security_group.proxyMPLSSG.id}"]

  tags = {
    Name = "proxy4-eth3"
    Project = "${var.projectName}"
  }
}
resource "aws_network_interface" "webfilter1" {
  subnet_id         = "${aws_subnet.vpcHostedCore1a.id}"
  private_ips       = ["${var.webfilter1IP}"]
  security_groups   = ["${aws_security_group.webfilterPrivateSG.id}"]

  tags = {
    Name = "webfilter1-eth0"
    Project = "${var.projectName}"
  }
}

resource "aws_network_interface" "webfilter2" {
  subnet_id         = "${aws_subnet.vpcHostedCore1b.id}"
  private_ips       = ["${var.webfilter2IP}"]
  security_groups   = ["${aws_security_group.webfilterPrivateSG.id}"]

  tags = {
    Name = "webfilter2-eth0"
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

resource "aws_instance" "webfilter01" {
  ami           = "${var.webfilterAMI}"
  instance_type = "${var.webfilterInstanceType}"
  availability_zone = "${var.awsAZ1}"
  key_name = "${var.awsKeyName}"
  network_interface {
    network_interface_id = "${aws_network_interface.webfilter1.id}"
    device_index         = 0
  }
  root_block_device = {
        volume_size = "${var.webfilterRootDiskSize}"
  }

  tags = {
        Name = "webfilter01"
        Project = "${var.projectName}"
    }
}

resource "aws_instance" "webfilter02" {
  ami           = "${var.webfilterAMI}"
  instance_type = "${var.webfilterInstanceType}"
  availability_zone = "${var.awsAZ2}"
  key_name = "${var.awsKeyName}"
  network_interface { 
    network_interface_id = "${aws_network_interface.webfilter2.id}"
    device_index         = 0
  }
  root_block_device = {
        volume_size = "${var.webfilterRootDiskSize}"
  }

  tags = {
        Name = "webfilter02"
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

resource "aws_instance" "NUHproxy3" {
  ami           = "${var.NUHAMI}"
  instance_type = "${var.NUHInstanceType}"
  availability_zone = "${var.awsAZ1}"
  key_name = "${var.awsKeyName}"
  network_interface {
    network_interface_id = "${aws_network_interface.proxy3Private.id}"
    device_index         = 0
  }
  root_block_device = {
        volume_size = "${var.proxyRootDiskSize}"
  }

  tags = {
        Name = "NUHproxy3"
        Project = "${var.projectName}"
    }
}

resource "aws_instance" "NUHproxy4" {
  ami           = "${var.NUHAMI}"
  instance_type = "${var.NUHInstanceType}"
  availability_zone = "${var.awsAZ2}"
  key_name = "${var.awsKeyName}"
  network_interface {
    network_interface_id = "${aws_network_interface.proxy4Private.id}"
    device_index         = 0
  }
  root_block_device = {
        volume_size = "${var.proxyRootDiskSize}"
  }

  tags = {
        Name = "NUHproxy4"
        Project = "${var.projectName}"
    }
}

data "template_cloudinit_config" "jump_userdata" {
    part {
      content = <<EOF
#cloud-config

packages:
 - awscli
 - ansible
 - epel-release
 - python-boto
# - python2-openshift
# - python-pyzabbix
 - git
 - tmux
 - wget
 - unzip
 - screen

## NOTE:  Any epel package needs to be installed via yum install -y in runcmd section.

runcmd:
 - sudo -u centos mkdir /home/centos/bin
 - yum install -y python2-openshift
 - yum install -y python-pyzabbix
 - mkdir /home/software
 - mkdir /home/software/licenses
 - mkdir /home/software/installers/${var.nuageVersion}
 - mkdir /home/software/installers/metroae
 - mkdir /home/software/VNS
 - wget https://amazon-eks.s3-us-west-2.amazonaws.com/1.13.8/2019-08-14/bin/linux/amd64/kubectl -O /home/centos/bin/kubectl
 - wget https://amazon-eks.s3-us-west-2.amazonaws.com/1.14.6/2019-08-22/bin/linux/amd64/aws-iam-authenticator -O /home/centos/bin/aws-iam-authenticator
 - chown centos:centos -R /home/centos/bin/
 - sudo -u centos chmod +x /home/centos/bin/*
 - sudo -u centos mkdir /home/centos/.aws/
 - cp /root/.aws/config /home/centos/.aws/config
 - chown centos:centos -R /home/centos/.aws/
 - aws s3 sync s3://${var.nuage-files-s3bucket}/installers/${var.nuageVersion} /home/software/installers/${var.nuageVersion}
 - aws s3 sync s3://${var.nuage-files-s3bucket}/installers/metroae /home/software/installers/metroae/
 - aws s3 sync s3://${var.nuage-files-s3bucket}/licenses /home/software/licenses/
 - chown centos:centos -R /home/software/

write_files:
- content: |
    [default]
    region = ${var.awsRegion}
    credential_source = Ec2InstanceMetadata
  path: /root/.aws/config
EOF
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
  user_data = "${data.template_cloudinit_config.jump_userdata.rendered}"
  iam_instance_profile = "${aws_iam_instance_profile.installerS3AccessInstanceProfile.name}"
  vpc_security_group_ids = ["${aws_security_group.jumpPrivateSG.id}"]
  root_block_device = {
        volume_size = "${var.proxyRootDiskSize}"
  }
    
  tags = {
        Name = "jump/metro"
        Project = "${var.projectName}"
    }
}

output "jump_metro_ip" {
  value = "${aws_instance.jump-metro.public_ip}"
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

resource "aws_network_interface_attachment" "metal1-eth2" {
  instance_id          = "${aws_instance.metal1.id}"
  network_interface_id = "${aws_network_interface.metal1MPLS1.id}"
  device_index         = 2

  depends_on = ["aws_instance.metal1"]
}

resource "aws_network_interface_attachment" "metal1-eth3" {
  instance_id          = "${aws_instance.metal1.id}"
  network_interface_id = "${aws_network_interface.metal1MPLS2.id}"
  device_index         = 3

  depends_on = ["aws_instance.metal1"]
}

resource "aws_network_interface_attachment" "metal2-eth1" {
  instance_id          = "${aws_instance.metal2.id}"
  network_interface_id = "${aws_network_interface.metal2Public.id}"
  device_index         = 1

  depends_on = ["aws_instance.metal2"]
}

resource "aws_network_interface_attachment" "metal2-eth2" {
  instance_id          = "${aws_instance.metal2.id}"
  network_interface_id = "${aws_network_interface.metal2MPLS1.id}"
  device_index         = 2

  depends_on = ["aws_instance.metal2"]
}

resource "aws_network_interface_attachment" "metal2-eth3" {
  instance_id          = "${aws_instance.metal2.id}"
  network_interface_id = "${aws_network_interface.metal2MPLS2.id}"
  device_index         = 3

  depends_on = ["aws_instance.metal2"]
}

resource "aws_network_interface_attachment" "metal3-eth1" {
  instance_id          = "${aws_instance.metal3.id}"
  network_interface_id = "${aws_network_interface.metal3Public.id}"
  device_index         = 1

  depends_on = ["aws_instance.metal3"]
}

resource "aws_network_interface_attachment" "metal3-eth2" {
  instance_id          = "${aws_instance.metal3.id}"
  network_interface_id = "${aws_network_interface.metal3MPLS1.id}"
  device_index         = 2

  depends_on = ["aws_instance.metal3"]
}

resource "aws_network_interface_attachment" "metal3-eth3" {
  instance_id          = "${aws_instance.metal3.id}"
  network_interface_id = "${aws_network_interface.metal3MPLS2.id}"
  device_index         = 3

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

resource "aws_network_interface_attachment" "proxy3-eth1" {
  instance_id          = "${aws_instance.NUHproxy3.id}"
  network_interface_id = "${aws_network_interface.proxy3Internal.id}"
  device_index         = 1
 
  depends_on = ["aws_instance.NUHproxy3"]
}

resource "aws_network_interface_attachment" "proxy3-eth2" {
  instance_id          = "${aws_instance.NUHproxy3.id}"
  network_interface_id = "${aws_network_interface.proxy3MPLS1.id}"
  device_index         = 2

  depends_on = ["aws_instance.NUHproxy3"]
}

resource "aws_network_interface_attachment" "proxy3-eth3" {
  instance_id          = "${aws_instance.NUHproxy3.id}"
  network_interface_id = "${aws_network_interface.proxy3MPLS2.id}"
  device_index         = 3

  depends_on = ["aws_instance.NUHproxy3"]
}

resource "aws_network_interface_attachment" "proxy4-eth1" {
  instance_id          = "${aws_instance.NUHproxy4.id}"
  network_interface_id = "${aws_network_interface.proxy4Internal.id}"
  device_index         = 1

  depends_on = ["aws_instance.NUHproxy4"]
}

resource "aws_network_interface_attachment" "proxy4-eth2" {
  instance_id          = "${aws_instance.NUHproxy4.id}"
  network_interface_id = "${aws_network_interface.proxy4MPLS1.id}"
  device_index         = 2

  depends_on = ["aws_instance.NUHproxy4"]
}

resource "aws_network_interface_attachment" "proxy4-eth3" {
  instance_id          = "${aws_instance.NUHproxy4.id}"
  network_interface_id = "${aws_network_interface.proxy4MPLS2.id}"
  device_index         = 3

  depends_on = ["aws_instance.NUHproxy4"]
}
