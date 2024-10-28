## to supply provider packages 

terraform {
  required_providers {
    equinix = {
      source  = "equinix/equinix"
      version = "2.4.0"
    }
    aws = {
      source  = "hashicorp/aws"
      version = "5.63.1"

    }
  }
}

## to supply Equinix Credentials 

provider "equinix" {

  client_id     = var.ecx_client_id
  client_secret = var.ecx_client_secret
}

## to supply AWS Credentials 

provider "aws" {
  region     = var.aws_zside_seller_region
}

## to call FCR UID from Terraform cloud Remote state file 

data "terraform_remote_state" "fcr_id" {
  backend = "remote"

  config = {
    organization = "EQIX_projectX"
    workspaces = {
      name = "network-apac"
    }
  }
}

## to create random VC connection name for FCR to AWS 

resource "random_pet" "this" {
  length = 2
}


## to create VC connection from FCR to AWS 

resource "equinix_fabric_connection" "Localname_fcr2aws" {
  name = "${var.connection_name}-${random_pet.this.id}" 
  type = var.connection_type
  notifications {
    type   = var.notifications_type
    emails = var.notifications_emails
  }
  bandwidth = var.bandwidth
  order {
    purchase_order_number = var.purchase_order_number
  }
  a_side {
    access_point {
      type = "CLOUD_ROUTER"
      router {
        uuid = data.terraform_remote_state.fcr_id.outputs.fcr_id
      }

    }
  }

  z_side {
    access_point {
      type               = var.aws_zside_ap_type
      authentication_key = var.aws_zside_authentication_key
      seller_region      = var.aws_zside_seller_region
      profile {
        type = "L2_PROFILE"
        uuid = var.aws_zside_profile_uuid
      }
      location {
        metro_code = var.aws_zide_location
      }
    }
  }
}

## data source to fetch AWS Dx connection ID 

data "aws_dx_connection" "aws_connection" {
  depends_on = [
    equinix_fabric_connection.Localname_fcr2aws
  ]
  name = "${var.connection_name}-${random_pet.this.id}" 
}

## to accept AWS Dx Connection

resource "aws_dx_connection_confirmation" "localname2" {
depends_on = [
    equinix_fabric_connection.Localname_fcr2aws
  ]
  connection_id = data.aws_dx_connection.aws_connection.id
}



resource "aws_vpc" "main" {
  cidr_block = var.aws_vpc_cidr
  tags = {
    Name = var.aws_vpc_name
  }
}

resource "aws_subnet" "private" {
  depends_on = [aws_vpc.main ]
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.aws_subnet_cidr
   tags = {
    Name = var.aws_subnet_name
  }
}

resource "aws_vpn_gateway" "vgw" {
   depends_on = [aws_subnet.private ]
  vpc_id = aws_vpc.main.id
tags = {
    Name = var.aws_vpg_name
  }
}

## to configure AWS VIF 

resource "aws_dx_private_virtual_interface" "aws_virtual_interface" {
  depends_on = [
    equinix_fabric_connection.Localname_fcr2aws,
    aws_vpn_gateway.vgw,aws_dx_connection_confirmation.localname2
  ]
  connection_id    = data.aws_dx_connection.aws_connection.id
  name             = var.aws_vif_name
  vlan             = data.aws_dx_connection.aws_connection.vlan_id
  address_family   = var.aws_vif_address_family
  bgp_asn          = var.aws_vif_bgp_asn
  amazon_address   = var.aws_vif_amazon_address
  customer_address = var.aws_vif_customer_address
  bgp_auth_key     = var.aws_vif_bgp_auth_key
  vpn_gateway_id   = aws_vpn_gateway.vgw.id
}

## to configure BGP on FCR 

 resource "equinix_fabric_routing_protocol" "localnameforBGPonFCR" {
  connection_uuid = equinix_fabric_connection.Localname_fcr2aws.id
  type            = "DIRECT"
  name            = "L3_FCRSG_to_AWS_Equinixside"
  direct_ipv4 {
    equinix_iface_ip = var.aws_vif_customer_address

  }
}

resource "equinix_fabric_routing_protocol" "LocalnameforBGPonVIF" {
  depends_on = [
    equinix_fabric_routing_protocol.localnameforBGPonFCR
  ]
  connection_uuid = equinix_fabric_connection.Localname_fcr2aws.id
  type            = "BGP"
  customer_asn    = 64512
  name            = "L3_FCRSG_to_AWS_AWSside"
  bgp_auth_key    = "XXYYFFDDCC"
  bgp_ipv4 {
    customer_peer_ip = "192.168.1.2"
    enabled          = true
  }

}
