output "vpc_id" {
  description = "VPC ID from the reused module"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public Subnet IDs from the reused module"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private Subnet IDs from the reused module"
  value       = module.vpc.private_subnet_ids
}

output "ec2_instance_id" {
  description = "EC2 Instance ID from the reused module"
  value       = module.ec2.instance_id
}

output "ec2_public_ip" {
  description = "EC2 Public IP from the reused module"
  value       = module.ec2.public_ip
}
