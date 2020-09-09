data "aws_route53_zone" "internalFQDN" {
    name   = "${var.internalFQDN}"
    private_zone = "true"
    vpc_id = "${data.aws_vpc.MainVPC.id}"
}



resource "aws_route53_record" "metal1" {
        zone_id = "${data.aws_route53_zone.internalFQDN.zone_id}"
        name = "metal${var.remotemetal1}.${var.internalFQDN}"
        type = "A"
        ttl = "${var.internalDNSTTL}"
        records = ["${local.metal1PrivateIP}"]
}


resource "aws_route53_record" "metal2" {
        zone_id = "${data.aws_route53_zone.internalFQDN.zone_id}"
        name = "metal${var.remotemetal2}.${var.internalFQDN}"
        type = "A"
        ttl = "${var.internalDNSTTL}"
        records = ["${local.metal2PrivateIP}"]
}
