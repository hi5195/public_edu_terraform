variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_count" {
  description = "Number of public subnets"
  type        = number
}

variable "private_count" {
  description = "Number of private subnets"
  type        = number
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
}
