
variable "username" {}
variable "int_vrf" {}
variable "int_desc_vrf" {}
variable "int_desc_aws" {}
variable "bw_vrf" {}
variable "project_id" {}
variable "metro_code" {}
variable "sec_metro_code" {}
variable "vnf_asn" {}
variable "neighbor_desc_pri_vrf" {}
variable "neighbor_desc_sec_vrf" {}
variable "neighbor_desc_pri_aws" {}
variable "pri_vc" {}
variable "sec_vc" {}
variable "emails" {}
variable "connection_name_fcr2aws" {}

#vipin - aws details 
# variable "profile_uuid" {}
# variable "authentication_key" {}
#vipin ecx details 
# variable "ecx_access_key" {}
# variable "ecx_secret_key" {}
# variable "ecx_auth_token" {}
# variable "FCRtoAWSspeed" {}
# variable "FCRpurchaseorder" {}
# variable "FCRmetrocode" {}
# variable "FCRaccountnumber" {}
# variable "FCRprojectid" {}
# variable "email" {}
variable "purchase_order_number" {}
# variable "FCRRoutername" {}
# variable "FCRlocation" {}
# variable "FCRemail" {}

# variable "zside_ap_authentication_key" {
#   description = "Authentication key for provider based connections"
#   type        = string
#   sensitive   = true
# }
# variable "zside_location" {
#   description = "Access point metro code"
#   type        = string
#   default     = "SP"
# }
# variable "zside_seller_region" {
#   description = "Access point seller region"
#   type        = string
#   default     = ""
# }

#fcr routing template
variable "direct_rp_name" {
  description = "Name of the Direct Routing Protocol"
  type        = string
}
variable "bgp_rp_name" {
  description = "Name of the BGP Routing Protocol"
  type        = string
  default     = ""
}
variable "bgp_enabled_ipv4" {
  description = "Boolean Enable Flag for IPv4 Peering on BGP Routing Protocol"
  type        = bool
  default     = true
}
variable "bgp_customer_asn" {
  description = "Customer ASN for BGP Routing Protocol"
  type        = string
  default     = ""
}

variable "connection_name_aws" {}
variable "connection_type" {}
variable "interface_number_aws" {}
variable "authentication_key_aws" {}
variable "profile_uuid_aws" {}
variable "seller_region" {}
variable "aws_region" {}
variable "bandwidth_aws" {}
variable "aws_vpc_name" {}
variable "aws_vpc_cidr" {}
variable "aws_subnet_name" {}
variable "aws_subnet_cidr" {}
variable "aws_vpg_name" {}
variable "aws_vif_name" {}
variable "aws_bgp_auth_key" {}
variable "amazon_ip_address" {}
variable "customer_ip_address" {}

#GCP
variable "google_region" {}
variable "google_project_id" {}
variable "google_zone" {}
variable "gcp_vpc_name" {}
# variable "google_network_mtu" {}
variable "google_router_name" {}
variable "google_router_bgp_asn" {}
variable "google_interconnect_name" {}
# variable "google_interconnect_type" {}
variable "google_interconnect_edge_availability_domain" {}
#Fabric Connection
variable "bandwidth_gcp" {}
variable "connection_name_gcp" {}
# variable "connection_type" {}
# variable "notifications_type" {}
# variable "notifications_emails" {}
# variable "bandwidth" {}
# variable "purchase_order_number" {}
# variable "zside_ap_type" {}
variable "zside_location" {}