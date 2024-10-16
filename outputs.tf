# output "hostname_instance" {
#   value = module.instance.hostname
# }
# output "instance_id" {
#   value = module.instance.id
# }
# output "instance_pip" {
#   value = module.instance.pip
# }
# output "hostname_vd" {
#   value     = module.ne.hostname_vd
#   sensitive = true
# }
# output "hostname_vd_sec" {
#   value     = module.ne.hostname_vd_sec
#   sensitive = true
# }
# output "ssh_ip_vd" {
#   value = module.ne.ssh_ip_vd
# }
# output "ssh_ip_vd_sec" {
#   value = module.ne.ssh_ip_vd_sec
# }

/*output "token_pri" {
  value     = equinix_metal_connection.vrf2vd.service_tokens[0].id
  sensitive = true
}
output "token_sec" {
  value     = equinix_metal_connection.vrf2vd.service_tokens[1].id
  sensitive = true
}*/


# for AWS connection
output "fcr_2_aws_vc_id" {
  value = equinix_fabric_connection.Localname_fcr2aws.id
}

output "AWS_DX_id" {
value = data.aws_dx_connection.aws_connection.id
}

output "AWS_VPG_id" {
  value = aws_vpn_gateway.vgw.id
}

output "AWS_VPC_id" {
  value = aws_vpc.main.id
}

output "AWS_Subnet_id" {
  value = aws_subnet.private.id
}

output "AWS_VIF_VLAN_id" {
  value = data.aws_dx_connection.aws_connection.vlan_id
}
