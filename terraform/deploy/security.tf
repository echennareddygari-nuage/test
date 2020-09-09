resource "aws_security_group" "webfilterPrivateSG" {
        name = "webfilterPrivateSG"
        description = "webfilterPrivateSG"
        vpc_id = "${aws_vpc.vpcHosted.id}"


        ingress {
                from_port = 10050
                to_port = 10050
                protocol = "tcp"
                cidr_blocks = ["${var.vpcHosted2CIDR}"]
                description = "Allow Zabbix Server to Agent Traffic"
        }

        ingress {
                from_port = 22
                to_port = 22
                protocol = "tcp"
                cidr_blocks = ["${var.jump_metroPrivateIP}/32"]
                description = "Allow SSH Access"
        }
        ingress {
                from_port = 22222
                to_port = 22222
                protocol = "tcp"
                cidr_blocks = ["${var.vpcHostedCIDR}"]
                description = "NSG Query Port"
        }
        ingress {
                from_port = 7443
                to_port = 7443
                protocol = "tcp"
                cidr_blocks = ["${var.vpcHostedCIDR}"]
                description = "NSG Download port"
        }
        ingress {
                from_port = 2813
                to_port = 2813
                protocol = "tcp"
                cidr_blocks = ["${var.vpcHosted2CIDR}"]
                description = "Access to monitjson service for Zabbix"
        }

        egress {
                from_port = 514
                to_port = 514
                protocol = "tcp"
                cidr_blocks = ["${var.vpcHosted2CIDR}"]
                description = "Allow Graylog Agent to Server Traffic"
        }

        egress {
                from_port = 5044
                to_port = 5044
                protocol = "tcp"
                cidr_blocks = ["${var.vpcHosted2CIDR}"]
                description = "Allow Graylog Agent to Server Traffic"
        }

        egress {
                from_port = 5555
                to_port = 5555
                protocol = "tcp"
                cidr_blocks = ["${var.vpcHosted2CIDR}"]
                description = "Plaintext test to Graylog Server"
        }

        egress {
                from_port = 10051
                to_port = 10051
                protocol = "tcp"
                cidr_blocks = ["${var.vpcHosted2CIDR}"]
                description = "Allow Zabbix Trapper to Zabbix Server"
        }
        egress {
                from_port = 443
                to_port = 443
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Download DB on Netstar Servers"
        }
        
        egress {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "install packages"
        }

        egress {
                from_port = 123
                to_port = 123
                protocol = "udp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "NTP sync on public servers"
        }


        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["100.64.0.0/10"]
                description = "Allow internal traffic"
        }

        tags {
                Name = "webfilterPrivateSG"
                Project = "${var.projectName}"
        }
}



resource "aws_security_group" "metalPrivateSG" {
	name = "metalPrivateSG"
	description = "metalPrivateSG"
	vpc_id = "${aws_vpc.vpcHosted.id}"

	ingress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["100.64.0.0/10"]
		description = "Allow management Traffic"
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["${var.jump_metroPrivateIP}/32"]
		description = "Allow jump SSH Traffic"
	}

	ingress {
		from_port = 10050
		to_port = 10050
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHostedCIDR}"]
		description = "Allow Zabbix Server to Agent Traffic"
	}

	ingress {
		from_port = 8443
		to_port = 8443
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Zabbix HTTP check to VSD"
	}

	ingress {
		from_port = 2812
		to_port = 2812
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Zabbix HTTP check to Monit"
	}

	ingress {
		from_port = 2813
		to_port = 2813
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Zabbix HTTP check to Monitjson"
	}

        ingress {
		from_port = 161
		to_port = 161
		protocol = "udp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Zabbix SNMP agent access to VSC"
	}

	ingress {
		from_port = 9200
		to_port = 9200
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Zabbix HTTP check to Elastic"
	}

	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Zabbix HTTP check to Portal"
	}

	ingress {
		from_port = 8443
		to_port = 8443
		protocol = "tcp"
		cidr_blocks = ["${var.jump_metroPrivateIP}/32"]
		description = "Allow jump Metro Deploy Traffic"
	}
	
	ingress {
		from_port = 61619
		to_port = 61619
		protocol = "tcp"
		cidr_blocks = ["${var.jump_metroPrivateIP}/32"]
		description = "Allow jump Metro Deploy Traffic"
	}

	ingress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["${var.mgmtMetalCIDR}"]
		description = "Allow management Traffic"
	}

	ingress {
		from_port = -1
		to_port = -1
		protocol = "icmp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow ICMP"
	}

	egress {
		from_port = 514 
		to_port = 514
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Graylog Agent to Server Traffic"
	}

	egress {
		from_port = 5044
		to_port = 5044
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Graylog Agent to Server Traffic"
	}

	egress {
		from_port = 9000
		to_port = 9000
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Graylog Agent to Server Traffic"
	}

	egress {
		from_port = 10051
		to_port = 10051
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Zabbix Trapper to Zabbix Server"
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
 	 }

	tags {
    		Name = "metalPrivateSG"
		Project = "${var.projectName}"
  	}
} 

resource "aws_security_group" "metalPublicSG" {
	name = "metalPublicSG"
	description = "metalPublicSG"
	vpc_id = "${aws_vpc.vpcHosted.id}"

	ingress {
		from_port = 7407
		to_port = 7407
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow JSON RPC Traffic"
	}
	
	egress {
	        from_port = 7407
                to_port = 7407
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow JSON RPC Traffic" 
        }

	ingress {
		from_port = 4789
		to_port = 4789
		protocol = "udp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow VxLAN Traffic"
	}

	egress {
                from_port = 4789
                to_port = 4789
                protocol = "udp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow VxLAN Traffic" 
        }

	ingress {
		from_port = 6633
		to_port = 6633
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow NSG Openflow Traffic"
	}

	egress {
                from_port = 6633
                to_port = 6633
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow NSG Openflow Traffic" 
        }

	ingress {
		from_port = 4500
		to_port = 4500
		protocol = "udp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow IPSec Traffic"
	}

	egress {
    	 	from_port = 4500
    		to_port = 4500
    		protocol = "udp"
    		cidr_blocks = ["0.0.0.0/0"]
    		description = "Allow IPSec Traffic" 
  	}

	ingress {
		from_port = 48179
		to_port = 48179
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow NSG-BGP Traffic"
	}

	egress {
    		from_port = 48179
    		to_port = 48179
    		protocol = "tcp"
    		cidr_blocks = ["0.0.0.0/0"]
    		description = "Allow NSG-BGP Traffic" 
  	}	

        ingress {
                from_port = 179
                to_port = 179
                protocol = "tcp"
                cidr_blocks = ["100.64.0.0/10"]
                description = "Allow Internal VSC BGP Traffic"
        }

	ingress {
		from_port = 179
		to_port = 179
		protocol = "tcp"
		cidr_blocks = ["${var.vsc01EIP}/32"]
		description = "Allow VSC BGP Traffic"
	}

	ingress {
		from_port = 179
		to_port = 179
		protocol = "tcp"
		cidr_blocks = ["${var.vsc02EIP}/32"]
		description = "Allow VSC BGP Traffic"
	}

	ingress {
		from_port = 179
		to_port = 179
		protocol = "tcp"
		cidr_blocks = ["${var.vsc03EIP}/32"]
		description = "Allow VSC BGP Traffic"
	}

	ingress {
		from_port = 179
		to_port = 179
		protocol = "tcp"
		cidr_blocks = ["${var.vsc04EIP}/32"]
		description = "Allow VSC BGP Traffic"
	}

	ingress {
		from_port = 123
		to_port = 123
		protocol = "udp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow NSG-NTP Traffic"
	}

	egress {
    		from_port = 123
    		to_port = 123
    		protocol = "udp"
    		cidr_blocks = ["0.0.0.0/0"]
    		description = "Allow NSG-NTP Traffic" 
  	}


        egress {
                from_port = 179
                to_port = 179
                protocol = "tcp"
                cidr_blocks = ["100.64.0.0/10"]
                description = "Allow Internal VSC BGP Traffic"
        }

	egress {
		from_port = 179
		to_port = 179
		protocol = "tcp"
		cidr_blocks = ["${var.vsc01EIP}/32"]
		description = "Allow VSC BGP Traffic"
	}

	egress {
		from_port = 179
		to_port = 179
		protocol = "tcp"
		cidr_blocks = ["${var.vsc02EIP}/32"]
		description = "Allow VSC BGP Traffic"
	}

	egress {
		from_port = 179
		to_port = 179
		protocol = "tcp"
		cidr_blocks = ["${var.vsc03EIP}/32"]
		description = "Allow VSC BGP Traffic"
	}

	egress {
		from_port = 179
		to_port = 179
		protocol = "tcp"
		cidr_blocks = ["${var.vsc04EIP}/32"]
		description = "Allow VSC BGP Traffic"
	}

	tags {
    		Name = "metalPublicSG"
		Project = "${var.projectName}"
	}
} 
 
resource "aws_security_group" "proxyPublicSG" {
	name = "proxyPublicSG"
	description = "proxyPublicSG"
	vpc_id = "${aws_vpc.vpcHosted.id}"

        ingress {
		from_port = 3000
		to_port = 3002
		protocol = "tcp"
		cidr_blocks = ["${var.nokiaProxyCIDR1}", "${var.nokiaProxyCIDR2}"]
		description = "TEMP - Web access to monitoring tools"
	}

	ingress {
		from_port = 11443
		to_port = 11443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow Post-Bootstrap"
	}

	ingress {
		from_port = 12443
		to_port = 12443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow Pre-Bootstrap"
	}

	ingress {
		from_port = 39090
		to_port = 39090
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow Stats Collection"
	}

	ingress {
		from_port = 514
		to_port = 514
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow Syslog Collection"
	}

	ingress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow portal UI access"
	}

	ingress {
		from_port = 8008
		to_port = 8008
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow upgrade server access"
	}

        ingress {
                from_port = 8080
                to_port = 8080
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Webfiltering Download port"
        }


        ingress {
                from_port = 9090
                to_port = 9090
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Webfiltering Query port"
        }

	tags {
    		Name = "proxyPublicSG"
		Project = "${var.projectName}"
  	}
} 

resource "aws_security_group" "proxyMPLSSG" {
        name = "proxyMPLSSG"
        description = "proxyMPLSSG"
        vpc_id = "${aws_vpc.vpcHosted.id}"

        ingress {
                from_port = -1
                to_port = -1
                protocol = "icmp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow ICMP"
        }

        ingress {
                from_port = 3000
                to_port = 3002
                protocol = "tcp"
                cidr_blocks = ["${var.nokiaProxyCIDR1}", "${var.nokiaProxyCIDR2}"]
                description = "TEMP - Web access to monitoring tools"
        }


        ingress {
                from_port = 53
                to_port = 53
                protocol = "udp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow DNS requests"
        }

        ingress {
                from_port = 11443
                to_port = 11443
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow Post-Bootstrap"
        }

        ingress {
                from_port = 12443
                to_port = 12443
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow Pre-Bootstrap"
        }

        ingress {
                from_port = 39090
                to_port = 39090
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow Stats Collection"
        }

        ingress {
                from_port = 514
                to_port = 514
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow Syslog Collection"
        }

        ingress {
                from_port = 443
                to_port = 443
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow portal UI access"
        }

        ingress {
                from_port = 8008
                to_port = 8008
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow upgrade server access"
        }

        ingress {
                from_port = 8080
                to_port = 8080
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Webfiltering Download port"
        }


        ingress {
                from_port = 9090
                to_port = 9090
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Webfiltering Query port"
        }

        tags {
                Name = "proxyMPLSSG"
                Project = "${var.projectName}"
        }
}

resource "aws_security_group" "toolsPrivateSG" {
	name = "toolsPrivateSG"
	description = "toolsPrivateSG"
	vpc_id = "${aws_vpc.vpcHosted.id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["${var.jump_metroPrivateIP}/32"]
		description = "Allow SSH Access"
	}

        ingress {
		from_port = 10050
		to_port = 10050
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Zabbix Server traffic for agent and other checks"
	}
	
        egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
 	}
        tags {
                Name = "toolsPrivateSG"
                Project = "${var.projectName}"
        }

}

resource "aws_security_group" "proxyPrivateSG" {
	name = "proxyPrivateSG"
	description = "proxyPrivateSG"
	vpc_id = "${aws_vpc.vpcHosted.id}"

        ingress {
		from_port = 8443
		to_port = 8443
		protocol = "tcp"
		cidr_blocks = ["${var.jump_metroPrivateIP}/32"]
		description = "TEMP - Allow VSD Access"
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHostedCIDR}"]
		description = "Allow SSH"
	}

        ingress {
		from_port = 10050
		to_port = 10050
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Zabbix Server traffic for agent and other checks"
	}

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["${var.jump_metroPrivateIP}/32"]
		description = "Allow SSH"
	}
	
	ingress {
		from_port = 8443
		to_port = 8443
		protocol = "tcp"
		cidr_blocks = ["${var.mgmtMetalCIDR}"]
		description = "Allow VSD UI/API Access"
	}
	
	ingress {
		from_port = 6200
		to_port = 6200
		protocol = "tcp"
		cidr_blocks = ["${var.mgmtMetalCIDR}"]
		description = "Allow ES Access"
	}

	ingress {
		from_port = 9200
		to_port = 9200
		protocol = "tcp"
		cidr_blocks = ["${var.mgmtMetalCIDR}"]
		description = "Allow ES Access"
	}

	ingress {
		from_port = 3242
		to_port = 3242
		protocol = "udp"
		cidr_blocks = ["${var.vpcHostedCIDR}"]
		description = "Allow HeartBeat Notification App"
	}


        ingress {
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["100.64.0.0/10"]
                description = "Allow NUH configuration"
        }

       egress {
                from_port = 22222
                to_port = 22222
                protocol = "tcp"
                cidr_blocks = ["100.64.0.0/10"]
                description = "webfilter query port"
        }
        
        egress {
                from_port = 7443
                to_port = 7443
                protocol = "tcp"
                cidr_blocks = ["100.64.0.0/10"]
                description = "webfilter download port"

        }
        egress {
		from_port = 443
		to_port = 443
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "TEMP - Allow AWS API for proxy switchover"
	}

	egress {
		from_port = 5044
		to_port = 5044
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Graylog Agent to Server Traffic"
	}

	egress {
		from_port = 514 
		to_port = 514
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Syslog to OSS"
	}
	
	egress {
		from_port = 53
		to_port = 53
		protocol = "UDP"
		cidr_blocks = ["${var.vpcHostedCIDR}"]
		description = "Allow DNS"
	}

	egress {
		from_port = 123
		to_port = 123
		protocol = "tcp"
		cidr_blocks = ["${var.providerNTP}/32"]
		description = "Allow NTP"
	}

	egress {
		from_port = 39090
		to_port = 39090
		protocol = "tcp"
		cidr_blocks = ["${var.mgmtMetalCIDR}"]
		description = "Allow Stats Passthrough"
	}

	egress {
		from_port = 7443
		to_port = 7443
		protocol = "tcp"
		cidr_blocks = ["${var.mgmtMetalCIDR}"]
		description = "Allow VSD API"
	}

	egress {
		from_port = 8443
		to_port = 8443
		protocol = "tcp"
		cidr_blocks = ["${var.mgmtMetalCIDR}"]
		description = "Allow VSD UI Access"
	}

	egress {
		from_port = 3000
		to_port = 3000
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Grafana UI/API"
	}

	egress {
		from_port = 9000
		to_port = 9000
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Graylog UI/API"
	}

	egress {
		from_port = 8980
		to_port = 8980
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Zabbix UI/API"
	}

	egress {
		from_port = 10051
		to_port = 10051
		protocol = "tcp"
		cidr_blocks = ["${var.vpcHosted2CIDR}"]
		description = "Allow Zabbix Trapper to Zabbix Server"
	}
	
	egress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["${var.mgmtMetalCIDR}"]
		description = "Allow SDWAN Portal Access"
	}
	
	egress {
		from_port = 3242
		to_port = 3242
		protocol = "udp"
		cidr_blocks = ["${var.vpcHostedCIDR}"]
		description = "Allow HeartBeat Notification App"
	}
	
	egress {
		from_port = 5222
		to_port = 5222
		protocol = "tcp"
		cidr_blocks = ["${var.mgmtMetalCIDR}"]
		description = "Allow NA XMPP Access to VSD"
	}

        egress {
                from_port = 6200
                to_port = 6200
                protocol = "tcp"
                cidr_blocks = ["${var.mgmtMetalCIDR}"]
                description = "Allow ES NGINX API for Portal"
        }
 
 
	egress {
		from_port = 587
		to_port = 587
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow NA Outgoing Email to SES"
	}
	
	egress {
		from_port = 9200
		to_port = 9200
		protocol = "tcp"
		cidr_blocks = ["${var.mgmtMetalCIDR}"]
		description = "Allow ES REST API for Portal"
	}
	
	egress {
		from_port = 7080
		to_port = 7080
		protocol = "tcp"
		cidr_blocks = ["${var.mgmtMetalCIDR}"]
		description = "Allow for crlreloader script"
	}

	tags {
                Name = "proxyPrivateSG"
		Project = "${var.projectName}"
  	}
} 

resource "aws_security_group" "eksClusterSG" {
  	name        = "eksClusterSG"
  	description = "Cluster communication with worker nodes"
  	vpc_id      = "${aws_vpc.vpcHosted.id}"

  	egress {
    		from_port   = 0
    		to_port     = 0
    		protocol    = "-1"
    		cidr_blocks = ["0.0.0.0/0"]
  	}

	tags {
    	        Name = "eksClusterSG"
		Project = "${var.projectName}"
  	}
}

resource "aws_security_group" "eksWorkerSG" {
 	name        = "eksWorkerSG"
	description = "Security group for all nodes in the cluster"
	vpc_id      = "${aws_vpc.vpcHosted.id}"

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
 	 }

	tags = "${
		map(
			"Name", "eksWorkerSG",
			"Project", "${var.projectName}",
			"kubernetes.io/cluster/${var.eksClusterName}", "owned",
		)
	}"
}

resource "aws_security_group_rule" "zabbixAgentAllow_10net" {
	description              = "Allow Zabbix Agent to Server Traffic on 10net"
	from_port                = 10051
	protocol                 = "tcp"
	security_group_id        = "${aws_security_group.eksWorkerSG.id}"
	cidr_blocks 		 = ["${var.vpcHostedCIDR}"]
	to_port                  = 10051
	type                     = "ingress"
}

resource "aws_security_group_rule" "zabbixAgentAllow_192net" {
	description              = "Allow Zabbix Agent to Server Traffic on 192net"
	from_port                = 10051
	protocol                 = "tcp"
	security_group_id        = "${aws_security_group.eksWorkerSG.id}"
	cidr_blocks 		 = ["${var.mgmtMetalCIDR}"]
	to_port                  = 10051
	type                     = "ingress"
}

resource "aws_security_group_rule" "graylogAgentAllow_10net" {
	description              = "Allow Graylog Agent to Server Traffic on 10net"
	from_port                = 5044
	protocol                 = "tcp"
	security_group_id        = "${aws_security_group.eksWorkerSG.id}"
	cidr_blocks 		 = ["${var.vpcHostedCIDR}"]
	to_port                  = 5044
	type                     = "ingress"
}

resource "aws_security_group_rule" "graylogAgentAllow_192net" {
	description              = "Allow Graylog Agent to Server Traffic on 192net"
	from_port                = 5044
	protocol                 = "tcp"
	security_group_id        = "${aws_security_group.eksWorkerSG.id}"
	cidr_blocks 	         = ["${var.mgmtMetalCIDR}"]
	to_port                  = 5044
	type                     = "ingress"
}

resource "aws_security_group_rule" "graylogAPIAllow_10net" {
	description              = "Allow Graylog API to Server Traffic on 10net"
	from_port                = 9000
	protocol                 = "tcp"
	security_group_id        = "${aws_security_group.eksWorkerSG.id}"
	cidr_blocks 	         = ["${var.vpcHostedCIDR}"]
	to_port                  = 9000
	type                     = "ingress"
}

resource "aws_security_group_rule" "graylogAPIAllow_192net" {
	description              = "Allow Graylog API to Server Traffic on 192net"
	from_port                = 9000
	protocol                 = "tcp"
	security_group_id        = "${aws_security_group.eksWorkerSG.id}"
	cidr_blocks 	         = ["${var.mgmtMetalCIDR}"]
	to_port                  = 9000
	type                     = "ingress"
}

resource "aws_security_group_rule" "graylogSyslogAllow_10net" {
	description              = "Allow Graylog Syslog to Server Traffic on 10net"
	from_port                = 514
	protocol                 = "tcp"
	security_group_id        = "${aws_security_group.eksWorkerSG.id}"
	cidr_blocks 		 = ["${var.vpcHostedCIDR}"]
	to_port                  = 514
	type                     = "ingress"
}

resource "aws_security_group_rule" "graylogSyslogAllow_192net" {
	description              = "Allow Graylog Syslog to Server Traffic on 192net"
	from_port                = 514
	protocol                 = "tcp"
	security_group_id        = "${aws_security_group.eksWorkerSG.id}"
	cidr_blocks 	         = ["${var.mgmtMetalCIDR}"]
	to_port                  = 514
	type                     = "ingress"
}

resource "aws_security_group_rule" "eksWorkerSGIngressSelf" {
	description              = "Allow node to communicate with each other"
	from_port                = 0
	protocol                 = "-1"
	security_group_id        = "${aws_security_group.eksWorkerSG.id}"
	source_security_group_id = "${aws_security_group.eksWorkerSG.id}"
	to_port                  = 65535
	type                     = "ingress"
}

resource "aws_security_group_rule" "eksWorkerSGIngressCluster" {
	description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
	from_port                = 1025
	protocol                 = "tcp"
	security_group_id        = "${aws_security_group.eksWorkerSG.id}"
	source_security_group_id = "${aws_security_group.eksClusterSG.id}"
	to_port                  = 65535
	type                     = "ingress"
}

resource "aws_security_group_rule" "eksClusterSGIngressWorkerHTTPS" {
	description              = "Allow pods to communicate with the cluster API Server"
	from_port                = 443
	protocol                 = "tcp"
	security_group_id        = "${aws_security_group.eksClusterSG.id}"
	source_security_group_id = "${aws_security_group.eksWorkerSG.id}"
	to_port                  = 443
	type                     = "ingress"
}

resource "aws_security_group" "jumpPrivateSG" {
	name = "jumpPrivateSG"
	description = "jumpPrivateSG"
	vpc_id = "${aws_vpc.vpcHosted.id}"

	ingress {
		from_port = 22
		to_port = 22
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow SSH"
	}
	ingress {
		from_port = -1
		to_port = -1
		protocol = "icmp"
		cidr_blocks = ["0.0.0.0/0"]
		description = "Allow ICMP"
	}

	egress {
		from_port   = 0
		to_port     = 0
		protocol    = "-1"
		cidr_blocks = ["0.0.0.0/0"]
 	 }

	tags {
    		Name = "jumpPrivateSG"
		Project = "${var.projectName}"
  	}
} 
