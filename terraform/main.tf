provider "aws" {
  region = var.region
}

variable "region" {
  default = "ap-south-1"
}

resource "aws_vpc" "pb_vpc" {
  cidr_block = var.vpc_cidr_block
  tags = {
    Name = "${var.env_prefix}-vpc"
  }
}

resource "aws_subnet" "pb_subnet-1" {
  vpc_id            = aws_vpc.pb_vpc.id
  cidr_block        = var.subnet_cidr_block
  availability_zone = var.avail_zone
  tags = {
    Name = "${var.env_prefix}-subnet-1"
  }
}

resource "aws_internet_gateway" "pb_igw" {
  vpc_id = aws_vpc.pb_vpc.id
  tags = {
    Name = "${var.env_prefix}-igw"
  }
}

resource "aws_route_table" "pb_route_table" {
  vpc_id = aws_vpc.pb_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.pb_igw.id
  }
  tags = {
    Name = "${var.env_prefix}-route-table"
  }
}

resource "aws_route_table_association" "pb_route_table_association" {
  subnet_id      = aws_subnet.pb_subnet-1.id
  route_table_id = aws_route_table.pb_route_table.id
}

resource "aws_security_group" "pb_sg" {
  name   = "${var.env_prefix}-sg"
  vpc_id = aws_vpc.pb_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.my_ip}/32", "${var.jenkins_ip}/32"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = {
    Name = "${var.env_prefix}-sg"
  }
}


data "aws_ami" "latest_amazon_linux_image" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["al2023-ami-*-x86_64"]
  }
}

resource "aws_instance" "pb_ec2" {
  ami                         = data.aws_ami.latest_amazon_linux_image.id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.pb_subnet-1.id
  vpc_security_group_ids      = [aws_security_group.pb_sg.id]
  availability_zone           = var.avail_zone
  associate_public_ip_address = true
  key_name                    = "jenkins-ec2-key-pair"

  user_data                   = file("entry-script.sh")
  user_data_replace_on_change = true

  tags = {
    Name = "${var.env_prefix}-ec2"
  }
}

output "instance_ip" {
  value = aws_instance.pb_ec2.public_ip
}
