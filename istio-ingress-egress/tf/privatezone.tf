resource "alicloud_pvtz_zone" "zone" {
    name = "sg.private"
}

resource "alicloud_pvtz_zone_record" "k8s" {
    zone_id = "${alicloud_pvtz_zone.zone.id}"
    resource_record = "placeholder"
    type = "A"
    value = "10.10.10.10"
    ttl="60"
}

resource "alicloud_pvtz_zone_attachment" "zone-attachment" {
    zone_id = "${alicloud_pvtz_zone.zone.id}"
    vpc_ids = ["${var.vpc_id == "" ? join("", alicloud_vpc.vpc.*.id) : var.vpc_id}"]
}