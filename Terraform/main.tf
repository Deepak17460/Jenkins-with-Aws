terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.54.1"
    }
  }

  backend "s3" {
    bucket  = "dpcode72"
    key     = "terraform/terraform.tfstate"
    region  = "var.region"
    encrypt = true
    acl     = "bucket-owner-full-control"
  }
}

provider "aws" {
  region = var.region
}

resource "aws_security_group" "dpcode_sg" {
  name        = "dpcode_sg"
  description = "Allow SSH, HTTP, and port 8004"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 8004
    to_port     = 8004
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
    Name = "dpcode-sg"
  }
}

resource "aws_key_pair" "dpcode_key" {
  key_name   = "dpcode_key"
  public_key = var.public_key
}

resource "aws_instance" "dpcode" {
  ami           = "ami-0b72821e2f351e396"
  instance_type = "t2.micro"
  subnet_id     = var.subnet_id
  associate_public_ip_address = true
  key_name                    = aws_key_pair.dpcode_key.key_name
  vpc_security_group_ids      = [aws_security_group.dpcode_sg.id]

  tags = {
    Name = "mydpcode"
  }
}
