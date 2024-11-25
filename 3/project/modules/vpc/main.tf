resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "example-vpc"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "example-igw"
  }
}

resource "aws_subnet" "public" {
  count                   = var.public_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 3, count.index)
  map_public_ip_on_launch = true
  availability_zone       = element(var.availability_zones, count.index)
  tags = {
    Name = "example-public-subnet-${count.index}"
  }
}

resource "aws_subnet" "private" {
  count             = var.private_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, count.index + 2)
  availability_zone = element(var.availability_zones, count.index % 2)
  tags = {
    Name = "example-private-subnet-${count.index}"
  }
}

resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id
  name   = "example-ec2-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example-ec2-sg"
  }
}
