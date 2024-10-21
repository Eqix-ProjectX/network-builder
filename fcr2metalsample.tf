

provider "equinix" {

  auth_token =var.metal_token
}

#to create Metal VLAN
resource "equinix_metal_vlan" "vlan-server" {
  metro       = var.metal_metro
  project_id  = var.metal_project_id
  vxlan = var.metal_vxlan
}

#to attach Fabric to Metal VLAN 
resource "equinix_metal_connection" "metal-connection" {
  name          = var.metal_connection_name
  redundancy    = var.redundancy_type
  speed         = var.metal_connection_speed
  type          = var.metal_port_type
  project_id    = var.metal_project_id
  metro         = var.metal_metro
  vlans         = [equinix_metal_vlan.vlan-server.vxlan]
  contact_email = var.emails
}

#to connect FCR to Metal (Layer2)
data "terraform_remote_state" "fcr_id" {
  backend = "remote"

  config = {
    organization = "Terraform-Projects-Vipin"
    workspaces = {
      name = "Module-for-Core-Components"
    }
  }
}

resource "equinix_fabric_connection" "primary_cloud_router_connection123" {
  name = var.FCR2Metal_Connectionname
  type = "IP_VC"
  notifications {
    type   = "ALL"
    emails = [var.emails]
  }

  bandwidth = var.FCR2metal_Speed
  order {
    purchase_order_number = var.purchase_order_number
  }
    a_side {
    access_point {
      type = "CLOUD_ROUTER"
      router {
        uuid = data.terraform_remote_state.fcr_id.outputs.Dallas_fcr_id
      }
    }
  }

  z_side {
    access_point {
      type               = "METAL_NETWORK"
      authentication_key = equinix_metal_connection.metal-connection.authorization_code
    }
  }
    
  }

# to create Metal Server 
resource "equinix_metal_device" "metal_device" {
  depends_on = [equinix_metal_vlan.vlan-server,equinix_fabric_connection.primary_cloud_router_connection123]
  hostname         = var.metal_hostname
  plan             = var.metal_plan
  metro            = var.metal_metro
  operating_system = var.metal_os
  billing_cycle    = var.metal_billing_cycle
  project_id       = var.metal_project_id
}

# to create Metal Server to Hybrid bonded Mode 
resource "equinix_metal_device_network_type" "set_hybrid_bonded" {
  device_id = equinix_metal_device.metal_device.id
  type = var.metal_bond_type
}

# to attach VLAN to Metal 
resource "equinix_metal_port_vlan_attachment" "vlan_attachment" {
  depends_on = [equinix_metal_device_network_type.set_hybrid_bonded]
  device_id = equinix_metal_device.metal_device.id
  port_name   = "bond0"
  vlan_vnid = equinix_metal_vlan.vlan-server.vxlan
}
