output "jenkings_public_dns" {
  value = "[ ${aws_instance.jenkings_ec2.public_dns} ]  "
}

output "cidr_block" {
  description = "The cidr_block of the VPC."
  value       = aws_vpc.main.cidr_block
}