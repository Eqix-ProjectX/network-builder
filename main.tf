terraform {
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "2.9.0"
    }
    iosxe = {
      source = "CiscoDevNet/iosxe"
    }
    aws = {
      source = "hashicorp/aws"
    }
    google = {
      source = "hashicorp/google"
    }
  }
  cloud {

    organization = "EQIX_projectX"

    workspaces {
      name = "network-builder-apac"
    }
  }
}

# provider "iosxe" {
#   alias    = "vd_pri"
#   username = var.username
#   password = data.terraform_remote_state.ne.outputs.vd_password
#   url      = "https://${data.terraform_remote_state.ne.outputs.ssh_ip_vd}"
# }
# provider "iosxe" {
#   alias    = "vd_sec"
#   username = var.username
#   password = data.terraform_remote_state.ne.outputs.vd_password_sec
#   url      = "https://${data.terraform_remote_state.ne.outputs.ssh_ip_vd_sec}"
# }

# data "terraform_remote_state" "ne" {
#   backend = "remote"
#   config = {
#     organization = "EQIX_projectX"
#     workspaces = {
#       name = "ne-apac"
#     }
#   }
# }
# data "terraform_remote_state" "bgp" {
#   backend = "remote"
#   config = {
#     organization = "EQIX_projectX"
#     workspaces = {
#       name = "metal-apac"
#     }
#   }
# }

# locals {
#   ipv4_vrf_pri    = cidrhost(data.terraform_remote_state.bgp.outputs.vrf_ranges[1], 1)
#   ipv4_vrf_sec    = cidrhost(data.terraform_remote_state.bgp.outputs.vrf_ranges_sec[1], 1)
#   ipv4_vd_pri_vrf = cidrhost(data.terraform_remote_state.bgp.outputs.vrf_ranges[1], 2)
#   ipv4_vd_sec_vrf = cidrhost(data.terraform_remote_state.bgp.outputs.vrf_ranges_sec[1], 2)
# }

# # IOS-XE configuration
# resource "iosxe_interface_ethernet" "interface_pri_vrf" {
#   provider                         = iosxe.vd_pri
#   type                             = "GigabitEthernet"
#   name                             = var.int_vrf
#   bandwidth                        = var.bw_vrf
#   description                      = var.int_desc_vrf
#   shutdown                         = false
#   ip_proxy_arp                     = false
#   ip_redirects                     = false
#   ip_unreachables                  = false
#   ipv4_address                     = local.ipv4_vd_pri_vrf
#   ipv4_address_mask                = cidrnetmask("${local.ipv4_vd_pri_vrf}/30")
#   snmp_trap_link_status            = true
#   logging_event_link_status_enable = true
# }
# resource "iosxe_interface_ethernet" "interface_sec_vrf" {
#   provider                         = iosxe.vd_sec
#   type                             = "GigabitEthernet"
#   name                             = var.int_vrf
#   bandwidth                        = var.bw_vrf
#   description                      = var.int_desc_vrf
#   shutdown                         = false
#   ip_proxy_arp                     = false
#   ip_redirects                     = false
#   ip_unreachables                  = false
#   ipv4_address                     = local.ipv4_vd_sec_vrf
#   ipv4_address_mask                = cidrnetmask("${local.ipv4_vd_sec_vrf}/30")
#   snmp_trap_link_status            = true
#   logging_event_link_status_enable = true
# }
# resource "iosxe_interface_ethernet" "interface_pri_aws" {
#   provider                         = iosxe.vd_pri
#   type                             = "GigabitEthernet"
#   name                             = var.interface_number_aws
#   bandwidth                        = var.bw_vrf
#   description                      = var.int_desc_aws
#   shutdown                         = false
#   ip_proxy_arp                     = false
#   ip_redirects                     = false
#   ip_unreachables                  = false
#   ipv4_address                     = split("/", var.customer_ip_address)[0]
#   ipv4_address_mask                = cidrnetmask(var.customer_ip_address)
#   snmp_trap_link_status            = true
#   logging_event_link_status_enable = true
# }

# resource "iosxe_bgp" "bgp_pri" {
#   provider             = iosxe.vd_pri
#   asn                  = var.vnf_asn
#   log_neighbor_changes = true
# }
# resource "iosxe_bgp" "bgp_sec" {
#   provider             = iosxe.vd_sec
#   asn                  = var.vnf_asn
#   log_neighbor_changes = true
# }

# resource "iosxe_bgp_neighbor" "neighbor_pri_vrf" {
#   provider                = iosxe.vd_pri
#   asn                     = var.vnf_asn
#   ip                      = local.ipv4_vrf_pri
#   remote_as               = data.terraform_remote_state.bgp.outputs.vrf_asn
#   description             = var.neighbor_desc_pri_vrf
#   shutdown                = false
#   disable_connected_check = false
#   log_neighbor_changes    = true
# }

# resource "iosxe_bgp_neighbor" "neighbor_sec_vrf" {
#   provider                = iosxe.vd_sec
#   asn                     = var.vnf_asn
#   ip                      = local.ipv4_vrf_sec
#   remote_as               = data.terraform_remote_state.bgp.outputs.vrf_asn
#   description             = var.neighbor_desc_sec_vrf
#   shutdown                = false
#   disable_connected_check = false
#   log_neighbor_changes    = true
# }

# resource "iosxe_bgp_neighbor" "neighbor_pri_aws" {
#   provider                = iosxe.vd_pri
#   asn                     = var.vnf_asn
#   ip                      = split("/", var.amazon_ip_address)[0]
#   remote_as               = 64512
#   description             = var.neighbor_desc_pri_aws
#   shutdown                = false
#   disable_connected_check = false
#   log_neighbor_changes    = true
#   password                = var.aws_bgp_auth_key
# }

# resource "iosxe_bgp_address_family_ipv4" "redist_pri" {
#   provider                            = iosxe.vd_pri
#   asn                                 = var.vnf_asn
#   af_name                             = "unicast"
#   ipv4_unicast_redistribute_connected = true
# }
# resource "iosxe_bgp_address_family_ipv4" "redist_sec" {
#   provider                            = iosxe.vd_sec
#   asn                                 = var.vnf_asn
#   af_name                             = "unicast"
#   ipv4_unicast_redistribute_connected = true
# }

# # resource "iosxe_save_config" "write_pri" {
# #   provider = iosxe.vd_pri
# #   depends_on = [
# #     iosxe_bgp.bgp_pri, iosxe_bgp_neighbor.neighbor_pri_vrf,
# #     iosxe_bgp_neighbor.neighbor_pri_aws,
# #     iosxe_interface_ethernet.interface_pri_vrf,
# #     iosxe_interface_ethernet.interface_pri_aws.
# #     iosxe_bgp_address_family_ipv4.redist_pri
# #   ]
# # }
# # resource "iosxe_save_config" "write_sec" {
# #   provider = iosxe.vd_sec
# #   depends_on = [
# #     iosxe_bgp.bgp_sec, iosxe_bgp_neighbor.neighbor_sec_vrf,
# #     iosxe_interface_ethernet.interface_sec_vrf,
# #     iosxe_bgp_address_familty_ipv4.redist_sec
# #   ]
# # }

# resource "equinix_fabric_connection" "vd2vrf_pri" {
#   name = var.pri_vc
#   type = "EVPL_VC"
#   redundancy {
#     priority = "PRIMARY"
#   }
#   notifications {
#     type   = "ALL"
#     emails = var.emails
#   }
#   bandwidth = 50

#   a_side {
#     access_point {
#       type = "VD"
#       virtual_device {
#         type = "EDGE"
#         uuid = data.terraform_remote_state.ne.outputs.vd_uuid
#       }
#       interface {
#         type = "NETWORK"
#         id   = var.int_vrf
#       }
#     }
#   }
#   z_side {
#     service_token {
#       uuid = equinix_metal_connection.vrf2vd.service_tokens[0].id
#     }
#   }
# }
# resource "equinix_fabric_connection" "vd2vrf_sec" {
#   name = var.sec_vc
#   type = "EVPL_VC"
#   redundancy {
#     priority = "SECONDARY"
#     group    = one(equinix_fabric_connection.vd2vrf_pri.redundancy).group
#   }
#   notifications {
#     type   = "ALL"
#     emails = var.emails
#   }
#   bandwidth = 50

#   a_side {
#     access_point {
#       type = "VD"
#       virtual_device {
#         type = "EDGE"
#         uuid = data.terraform_remote_state.ne.outputs.vd_uuid_sec
#       }
#       interface {
#         type = "NETWORK"
#         id   = var.int_vrf
#       }
#     }
#   }
#   z_side {
#     service_token {
#       uuid = equinix_metal_connection.vrf2vd.service_tokens[1].id
#     }
#   }
# }

# /*
# resource "time_sleep" "wait_2_min" {
#   create_duration = "2m"
#   depends_on = [
#     equinix_fabric_connection.vd2vrf_pri,
#     equinix_fabric_connection.vd2vrf_sec
#   ]
# }
# */

# /*
# resource "equinix_metal_connection" "vrf2vd" {
#   name          = var.connection_name
#   project_id    = var.project_id
#   metro         = var.metro_code
#   redundancy    = "redundant"
#   type          = "shared"
#   contact_email = join("", var.emails)
#   vrfs = [
#     data.terraform_remote_state.bgp.outputs.vrf_pri,
#     data.terraform_remote_state.bgp.outputs.vrf_sec
#   ]
#   service_token_type = "z_side"
# }
# */

# /* commented out portion of BGP peering setup for now -TF not supported-
# resource "equinix_metal_virtual_circuit" "peer_pri" {
#   project_id = var.project_id
#   connection_id = equinix_metal_connection.vrf2vd.id
#   port_id       = equinix_metal_connection.vrf2vd.ports[0].id
#   vrf_id        = data.terraform_remote_state.bgp.outputs.vrf_pri
#   peer_asn      = var.vnf_asn
#   subnet        = cidrsubnet(data.terraform_remote_state.bgp.outputs.vrf_ranges[1], 5, 0)
#   metal_ip      = local.ipv4_mg_pri
#   customer_ip   = local.ipv4_pri
#   nni_vlan      = [for z in equinix_fabric_connection.vd2vrf_pri.z_side : [for ap in z.access_point : [for lp in ap.link_protocol : lp.vlan_tag]]][0]
#   depends_on    = [time_sleep.wait_2_min,
#   equinix_fabric_connection.vd2vrf_pri]
# }
# resource "equinix_metal_virtual_circuit" "peer_sec" {
#   project_id         = var.project_id
#   connection_id = equinix_metal_connection.vrf2vd.id
#   port_id    = equinix_metal_connection.vrf2vd.ports[1].id
#   vrf_id     = data.terraform_remote_state.bgp.outputs.vrf_sec
#   peer_asn   = var.vnf_asn
#   subnet     = cidrsubnet(data.terraform_remote_state.bgp.outputs.vrf_ranges_sec[1], 5, 0)
#   metal_ip = local.ipv4_mg_sec
#   customer_ip = local.ipv4_sec
#   nni_vlan = [for z in equinix_fabric_connection.vd2vrf_pri.z_side : [for ap in z.access_point : [for lp in ap.link_protocol : lp.vlan_tag]]][0]
#   depends_on = [time_sleep.wait_2_min]
# }
# */

module "aws-connection" {
  source                = "github.com/Eqix-ProjectX/terraform-equinix-virtualconnection-aws/"
  connection_name       = var.connection_name_aws
  connection_type       = var.connection_type
  notifications_emails  = var.emails
  bandwidth             = var.bandwidth_aws
  purchase_order_number = var.purchase_order_number
  device_uuid           = data.terraform_remote_state.ne.outputs.vd_uuid
  interface_number      = var.interface_number_aws
  authentication_key    = var.authentication_key_aws
  profile_uuid          = var.profile_uuid_aws
  metro                 = var.metro_code
  aws_vpc_cidr          = var.aws_vpc_cidr
  seller_region         = var.seller_region
  aws_region            = var.aws_region
  aws_vpc_name          = var.aws_vpc_name
  aws_subnet_name       = var.aws_subnet_name
  aws_subnet_cidr       = var.aws_subnet_cidr
  aws_vpg_name          = var.aws_vpg_name
  aws_vif_name          = var.aws_vif_name
  customer_asn          = var.vnf_asn
  aws_bgp_auth_key      = var.aws_bgp_auth_key
  amazon_ip_address     = var.amazon_ip_address
  customer_ip_address   = var.customer_ip_address
}
