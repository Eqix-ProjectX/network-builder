// output from ne-apac - Network Edge workspace
data "terraform_remote_state" "vd_uuid" {
  backend = "remote"

  config = {
    organization = "EQIX_projectX"
    workspaces = {
      name = "ne-apac"
    }
  }
}

// output from network-apac - Network Assets workspace
data "terraform_remote_state" "evplan_id" {
  backend = "remote"

  config = {
    organization = "EQIX_projectX"
    workspaces = {
      name = "network-apac"
    }
  }
}

// connection between evplan and network edge
// comment
module "evpla_ne" {
  source                = "git::github.com/Eqix-ProjectX/terraform-equinix-virtualconnection-evplan.git"
  connection_name       = "evplan-to-ne"
  notifications_emails  = var.notifications_emails
  bandwidth             = 50
  purchase_order_number = var.purchase_order_number
  device_uuid           = data.terraform_remote_state.vd_uuid.outputs.vd_uuid
  interface_number      = 8
  network_id            = data.terraform_remote_state.evplan_id.outputs.evplan_id
  project_id            = var.project_id
}
