provider "aws" {
  region = "us-east-1" # Change to your preferred region
}

# Create VPC
resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags                 = { Name = "Prod-VPC" }
}

# Create Public Subnet
resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "us-east-1a"
  tags                    = { Name = "PublicSubnet" }
}

# Create Private Subnet
resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1a"
  tags              = { Name = "PrivateSubnet" }
}

# Create Internet Gateway
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "InternetGateway" }
}

# Create Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "PublicRouteTable" }
}

# Route Internet Traffic through Internet Gateway
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

# Associate Public Subnet with Public Route Table
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

# Allocate Elastic IP for NAT Gateway
resource "aws_eip" "nat" {
  domain = "vpc"
}

# Create NAT Gateway in Private Subnet
resource "aws_nat_gateway" "nat" {
  subnet_id     = aws_subnet.public.id
  allocation_id = aws_eip.nat.id
  tags          = { Name = "NATGateway" }
}

# Create Private Route Table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  tags   = { Name = "PrivateRouteTable" }
}

# Route Private Subnet Internet Traffic through NAT Gateway
resource "aws_route" "private_nat_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat.id
}

# Associate Private Subnet with Private Route Table
resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private.id
  route_table_id = aws_route_table.private.id
}

# 🔒 Security Group for Bastion Host (Allow SSH only from 192.168.1.46)
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.main.id
  name   = "bastion-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["192.168.1.0/24"] # Only allow SSH from your IP
  }

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
}

# Allocate Elastic IP for Bastion Host
resource "aws_eip" "bastion_eip" {
  domain   = "vpc"
  instance = aws_instance.bastion.id
  tags     = { Name = "Bastion-EIP" }
}

# Create Bastion Host (Public EC2 Instance)
resource "aws_instance" "bastion" {
  ami                    = "ami-0c7af5fe939f2677f" # Change to a valid AMI ID
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id] # 
  key_name               = "AWS"                              # Change this to your SSH key name
  tags                   = { Name = "BastionHost" }
}

# 🔒 Security Group for Private Instance (Only allow SSH from Bastion)
resource "aws_security_group" "private_sg" {
  vpc_id = aws_vpc.main.id
  name   = "private-sg"

  ingress {
    from_port       = 22
    to_port         = 22
    protocol        = "tcp"
    security_groups = [aws_security_group.bastion_sg.id] # Allow only from Bastion
  }

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
}

# Create Private Instance
resource "aws_instance" "private" {
  ami                    = "ami-0c7af5fe939f2677f" # Change to a valid AMI ID
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.private.id
  vpc_security_group_ids = [aws_security_group.private_sg.id] # 
  key_name               = "AWS"                              # Change this to your SSH key name
  tags                   = { Name = "PrivateInstance" }
}


