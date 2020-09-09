resource "aws_security_group" "metalPrivateSG" {
        name = "metalPrivateSG"
        description = "metalPrivateSG"
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"

        ingress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["100.64.0.0/10"]
                description = "Allow management Traffic"
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
                from_port = 80
                to_port = 80
                protocol = "tcp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "install packages"
        }
        egress {
                from_port = 0
                to_port = 0
                protocol = "-1"
                cidr_blocks = ["100.64.0.0/10"]
                description = "Allow internal traffic"
        }


        tags {
                Name = "metalPrivateSG"
                Project = "${var.projectName}"
        }
}

resource "aws_security_group" "proxyMPLSSG" {
        name = "proxyMPLSSG"
        description = "proxyMPLSSG"
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"

        ingress {
                from_port = -1
                to_port = -1
                protocol = "icmp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow ICMP"
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

resource "aws_security_group" "metalPublicMPLS" {
        name = "metalPublicMPLS"
        description = "metalPublicMPLS"
        vpc_id = "${aws_vpc.vpcremoteHosted.id}"

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

        ingress {
                from_port = -1
                to_port = -1
                protocol = "icmp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow ICMP"
        }

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
                description = "Allow VxLAN DTLS"
        }

        egress {
                from_port = 4789
                to_port = 4789
                protocol = "udp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow VxLAN DTLS"
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
                description = "Allow IPSec DTLS"
        }

        egress {
                from_port = 4500
                to_port = 4500
                protocol = "udp"
                cidr_blocks = ["0.0.0.0/0"]
                description = "Allow IPSec DTLS"
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

        tags {
                Name = "metalPublicMPLS"
                Project = "${var.projectName}"
        }
}
