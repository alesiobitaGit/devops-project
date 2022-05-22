output "jenkings_public_dns" {
  value = "[ ${aws_instance.jenkings_ec2.public_dns} ]  "
}

output "vpc_id" {
  description = "The ID of the VPC."
  value       = aws_vpc.main.id
}

output "cidr_block" {
  description = "The cidr_block of the VPC."
  value       = aws_vpc.main.cidr_block
}

output "main_route_table_id" {
  description = "The ID of the main route table."
  value       = aws_vpc.main.main_route_table_id
}

output "default_security_group_id" {
  description = "The id of the VPC default security group"
  value       = aws_vpc.main.default_security_group_id
}

output "default_network_acl_id" {
  description = "The ID of the network ACL created by default on VPC creation"
  value       = aws_vpc.main.default_network_acl_id
}