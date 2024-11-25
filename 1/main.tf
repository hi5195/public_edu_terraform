terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}



# VPC 생성
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/24"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "example-vpc"
  }
}

# IGW 생성
resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "example-igw"
  }
}

# Public Subnet 생성
resource "aws_subnet" "public" {
  count                   = 2
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet("10.0.0.0/24", 3, count.index) # /27
  map_public_ip_on_launch = true
  availability_zone       = element(["ap-northeast-2a", "ap-northeast-2b"], count.index)
  tags = {
    Name = "example-public-subnet-${count.index}"
  }
}

# Private Subnet 생성
resource "aws_subnet" "private" {
  count             = 4
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet("10.0.0.0/24", 3, count.index + 2) # /27
  availability_zone = element(["ap-northeast-2a", "ap-northeast-2b"], count.index % 2)
  tags = {
    Name = "example-private-subnet-${count.index}"
  }
}

# Public 라우팅 테이블 생성 및 IGW 연결
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "example-public-rt"
  }
}

# Public 라우팅 테이블에 IGW 경로 추가
resource "aws_route" "public_route" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id
}

# Public Subnet과 라우팅 테이블 연결
resource "aws_route_table_association" "public" {
  count          = 2
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

# Private 라우팅 테이블 생성
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "example-private-rt"
  }
}

# Private Subnet과 라우팅 테이블 연결
resource "aws_route_table_association" "private" {
  count          = 4
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

# S3 Gateway Endpoint 생성
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.ap-northeast-2.s3"
  vpc_endpoint_type = "Gateway"
  
  # 직접 라우팅 테이블 ID를 참조
  route_table_ids = [
    aws_route_table.private.id
  ]
}


# EC2용 Security Group 생성
resource "aws_security_group" "ec2_sg" {
  vpc_id = aws_vpc.main.id
  name        = "example-ec2-sg"
  
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


resource "aws_instance" "web" {
  ami           = "ami-0f1e61a80c7ab943e"
  instance_type = "t2.micro"
  subnet_id     = element(aws_subnet.public.*.id, 0)

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  tags = {
    Name = "example-ec2"
  }
}
