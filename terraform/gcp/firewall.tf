# firewall
// # mgmt
// resource "google_compute_firewall" "mgmt" {
//   name    = "${var.projectPrefix}mgmt-firewall-${var.buildSuffix}"
//   network = module.google_network.vpcs["public"].id

//   allow {
//     protocol = "icmp"
//   }

//   allow {
//     protocol = "tcp"
//     ports    = ["22", "443", "80"]
//   }

//   source_ranges = var.adminSourceAddress
// }
