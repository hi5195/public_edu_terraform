# AWS Provider 설정
variable "aws_region" {
  description = "AWS Region"
  type        = string
  default     = "ap-northeast-2"
}

# VPC 설정
variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/24"
}

variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
  default     = "example-vpc"
}

# Availability Zones
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2b"]
}

# IGW 설정
variable "igw_name" {
  description = "Name of the Internet Gateway"
  type        = string
  default     = "example-igw"
}

# EC2 설정
variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
  default     = "ami-0f1e61a80c7ab943e"
}

variable "instance_type" {
  description = "Instance type for EC2"
  type        = string
  default     = "t2.micro"
}
