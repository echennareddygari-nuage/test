resource "aws_route53_zone" "internalFQDN" {
	name = "${var.internalFQDN}"
	vpc {
	    vpc_id = "${aws_vpc.vpcHosted.id}"
	}

	tags {
		Name = "${var.internalFQDN}"
		Project = "${var.projectName}"
	}
}

resource "aws_route53_record" "metal01" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "metal01.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.metal1PrivateIP}"]
}

resource "aws_route53_record" "metal02" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "metal02.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.metal2PrivateIP}"]
}

resource "aws_route53_record" "metal03" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "metal03.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.metal3PrivateIP}"]
}

resource "aws_route53_record" "tools01" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "tools01.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${aws_instance.tools01.private_ip}"]
}

resource "aws_route53_record" "vsd01" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "vsd01.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.vsd1IP}"]
}

resource "aws_route53_record" "vsd02" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "vsd02.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.vsd2IP}"]
}

resource "aws_route53_record" "vsd03" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "vsd03.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.vsd3IP}"]
}

resource "aws_route53_record" "vsd" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "vsd.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.vsd1IP}","${var.vsd2IP}","${var.vsd3IP}"]
}

resource "aws_route53_record" "xmpp" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "xmpp.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${aws_route53_record.vsd01.records[0]}","${aws_route53_record.vsd02.records[0]}","${aws_route53_record.vsd03.records[0]}"]
}

resource "aws_route53_record" "es01" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "es01.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.es1IP}"]
}

resource "aws_route53_record" "es02" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "es02.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.es2IP}"]
}
resource "aws_route53_record" "es03" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "es03.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.es3IP}"]
}

resource "aws_route53_record" "es" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "es.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.es1IP}","${var.es2IP}","${var.es3IP}"]
}

resource "aws_route53_record" "portal01" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "portal01.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.portal1IP}"]
}

resource "aws_route53_record" "portal02" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "portal02.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.portal2IP}"]
}

resource "aws_route53_record" "portal03" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "portal03.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.portal3IP}"]
}

resource "aws_route53_record" "portal" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "portal.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.portal1IP}","${var.portal2IP}","${var.portal3IP}"]
}

resource "aws_route53_record" "proxy01" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "proxy01.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.proxy1PrivateIP}"]
}

resource "aws_route53_record" "proxy02" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "proxy02.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["${var.proxy2PrivateIP}"]
}

resource "aws_route53_record" "vsc01" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "vsc01.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["192.168.1.101"]
}

resource "aws_route53_record" "vsc02" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "vsc02.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["192.168.2.102"]
}

resource "aws_route53_record" "vsc03" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "vsc03.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["192.168.1.103"]
}

resource "aws_route53_record" "vsc04" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "vsc04.${var.internalFQDN}"
	type = "A"
	ttl = "${var.internalDNSTTL}"
	records = ["192.168.2.104"]
}

resource "aws_route53_record" "xmpp_srv" {
	zone_id = "${aws_route53_zone.internalFQDN.zone_id}"
	name = "_xmpp-client._tcp.xmpp.${var.internalFQDN}"
	type = "SRV"
	ttl = "${var.internalDNSTTL}"
	records = ["10 0 5222 ${aws_route53_record.vsd01.fqdn}","10 0 5222 ${aws_route53_record.vsd02.fqdn}","10 0 5222 ${aws_route53_record.vsd03.fqdn}"]
}

resource "aws_route53_zone" "internal_ptr" {
  name = "168.192.in-addr.arpa"
  vpc {
    vpc_id = "${aws_vpc.vpcHosted.id}"
  }
}
resource "aws_route53_record" "vsd1_ptr" {
	zone_id = "${aws_route53_zone.internal_ptr.zone_id}"
	name = "20.1.168.192.in-addr.arpa"
	type = "PTR"
	ttl = "${var.internalDNSTTL}"
	records = ["${aws_route53_record.vsd01.fqdn}"]
}
resource "aws_route53_record" "vsd2_ptr" {
	zone_id = "${aws_route53_zone.internal_ptr.zone_id}"
	name = "20.2.168.192.in-addr.arpa"
	type = "PTR"
	ttl = "${var.internalDNSTTL}"
	records = ["${aws_route53_record.vsd02.fqdn}"]
}
resource "aws_route53_record" "vsd3_ptr" {
	zone_id = "${aws_route53_zone.internal_ptr.zone_id}"
	name = "20.3.168.192.in-addr.arpa"
	type = "PTR"
	ttl = "${var.internalDNSTTL}"
	records = ["${aws_route53_record.vsd03.fqdn}"]
}
