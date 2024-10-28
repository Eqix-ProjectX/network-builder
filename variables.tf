/*
variable "username" {}
variable "int" {}
variable "int_desc" {}
variable "bw" {}
variable "project_id" {}
variable "metro_code" {}
variable "sec_metro_code" {}
variable "vnf_asn" {}
variable "neighbor_desc_pri" {}
variable "neighbor_desc_sec" {}
variable "pri_vc" {}
variable "sec_vc" {}
variable "emails" {}
variable "connection_name" {}
variable "purchase_order_number" {}
variable "project_id" {}
variable "notifications_emails" {} 

*/

#vipin - aws details 
variable "ecx_client_id" {
  type    = string
  default = ""
}

variable "ecx_client_secret" {
  type    = string
  default = ""
}

variable "aws_access_key" {
  type    = string
  default = ""
}

variable "aws_secret_key" {
  type    = string
  default = ""
}

variable "connection_name" {
  description = "Connection name. An alpha-numeric 24 characters string which can include only hyphens and underscores"
  type        = string
}

variable "connection_type" {
  description = "Defines the connection type like VG_VC, EVPL_VC, EPL_VC, EC_VC, IP_VC, ACCESS_EPL_VC"
  type        = string
}

variable "notifications_type" {
  description = "Notification Type - ALL is the only type currently supported"
  type        = string
  default     = "ALL"
}

variable "notifications_emails" {
  description = "Array of contact emails"
  type        = list(string)
}

variable "bandwidth" {
  description = "Connection bandwidth in Mbps"
  type        = number
}

variable "purchase_order_number" {
  description = "Purchase order number"
  type        = string
  default     = ""
}

variable "aws_zside_authentication_key" {
  description = "Authentication key for provider based connections"
  type        = string
  default     = ""
}

variable "aws_zside_seller_region" {
  description = "Access point seller region"
  type        = string
  default     = ""
}

variable "aws_zside_ap_type" {
  description = "Service profile type - L2_PROFILE, L3_PROFILE, ECIA_PROFILE, ECMC_PROFILE"
  type        = string
  default     = "L2_PROFILE"
}

variable "aws_zside_profile_uuid" {
  description = "AWS profile UUID"
  type        = string
}

variable "aws_zide_location" {
  description = "Access point metro code"
  type        = string
  default     = "SP"
}

variable "aws_gateway_name" {
  description = "The name of the Gateway"
  type        = string
}

variable "aws_gateway_asn" {
  description = "The ASN to be configured on the Amazon side of the connection. The ASN must be in the private range of 64,512 to 65,534 or 4,200,000,000 to 4,294,967,294"
  type        = number
}

variable "aws_vif_name" {
  description = "The name for the virtual interface"
  type        = string
}

variable "aws_vif_address_family" {
  description = "The address family for the BGP peer. ipv4 or ipv6"
  type        = string
}

variable "aws_vif_bgp_asn" {
  description = "The autonomous system (AS) number for Border Gateway Protocol (BGP) configuration"
  type        = number
}

variable "aws_vif_amazon_address" {
  description = "The IPv4 CIDR address to use to send traffic to Amazon. Required for IPv4 BGP peers"
  type        = string
  default     = ""
}

variable "aws_vif_customer_address" {
  description = "The IPv4 CIDR destination address to which Amazon should send traffic. Required for IPv4 BGP peers"
  type        = string
  default     = ""
}

variable "aws_vif_bgp_auth_key" {
  description = "The authentication key for BGP configuration"
  type        =  string
  default     = ""
  sensitive   = true
}

variable "aws_vpc_cidr" {
  description = "AWS VPC CIDR"
  type        = string
}

variable "aws_vpc_name" {
  description = "AWS VPC CIDR"
  type        = string
}

variable "aws_subnet_cidr" {
  description = "AWS Subnet CIDR"
  type        = string
}

variable "aws_subnet_name" {
  description = "AWS Subnet name"
  type        = string
}

variable "aws_vpg_name" {
  description = "AWS VPG name"
  type        = string
}


