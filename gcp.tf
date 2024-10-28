provider "google" {
  region  = var.google_region
  project = var.google_project_id
  zone    = var.google_zone
}

resource "google_compute_network" "vpc_network" {
  name                    = var.gcp_vpc_name
  auto_create_subnetworks = "true"
}

resource "google_compute_router" "cloud-router-google" {
  name    = var.google_router_name
  network = google_compute_network.vpc_network.name
  bgp {
    asn = var.google_router_bgp_asn
  }
}

resource "google_compute_interconnect_attachment" "cloud-router-google" {
  name                     = var.google_interconnect_name
  type                     = "PARTNER"
  router                   = google_compute_router.cloud-router-google.id
  region                   = var.google_region
  edge_availability_domain = var.google_interconnect_edge_availability_domain
}

module "cloud_router_google_connection" {
  source = "equinix/fabric/equinix//modules/cloud-router-connection"

  connection_name       = var.connection_name_gcp
  connection_type       = "IP_VC"
  notifications_type    = "ALL"
  notifications_emails  = var.emails
  bandwidth             = var.bandwidth_gcp
  purchase_order_number = var.purchase_order_number

  #Aside
  aside_fcr_uuid = "98808313-8d92-4d64-a85b-0c7f12f72c57"

  #Zside
  zside_ap_type               = "SP"
  zside_ap_authentication_key = google_compute_interconnect_attachment.cloud-router-google.pairing_key
  zside_ap_profile_type       = "L2_PROFILE"
  zside_location              = var.zside_location
  zside_seller_region         = var.google_region
  zside_fabric_sp_name        = "Google Cloud Partner Interconnect Zone 1"
}

resource "google_compute_router_peer" "bgp_peer" {
  name      = "peer-vrf2gcp"
  router    = google_compute_router.cloud-router-google.name
  region    = google_compute_router.cloud-router-google.region
  peer_asn  = 13531
  interface = "2fcr"
  #   ip_address      = google_compute_router.cloud-router-google.ip_address
  #   peer_ip_address = "1.1.1.1"

  depends_on = [
    google_compute_interconnect_attachment.cloud-router-google
  ]
}

output "eq_ip" {
  value = google_compute_interconnect_attachment.cloud-router-google.customer_router_ip_address
}
output "gcp_ip" {
  value = google_compute_interconnect_attachment.cloud-router-google.cloud_router_ip_address
}

resource "equinix_fabric_routing_protocol" "direct_gcp" {
  connection_uuid = module.cloud_router_google_connection.primary_connection_id
  type            = "DIRECT"
  name            = "direct_gcp"
  direct_ipv4 {
    equinix_iface_ip = google_compute_interconnect_attachment.cloud-router-google.customer_router_ip_address
  }

  depends_on = [
    google_compute_interconnect_attachment.cloud-router-google
  ]
}
resource "equinix_fabric_routing_protocol" "bgp_gcp" {
  connection_uuid = module.cloud_router_google_connection.primary_connection_id
  type            = "BGP"
  name            = "bgp_gcp"
  bgp_ipv4 {
    customer_peer_ip = google_compute_interconnect_attachment.cloud-router-google.cloud_router_ip_address
    enabled          = true
  }
  customer_asn = var.google_router_bgp_asn

  depends_on = [
    google_compute_interconnect_attachment.cloud-router-google
  ]
}