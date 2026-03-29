provider "aws" {
  region = "us-east-1"
}

# Security Group - para permitir acesso SSH e do Flask
resource "aws_security_group" "app_security" {
  name        = "terraform-security"
  description = "Security group para o app"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Flask App"
    from_port   = 5000
    to_port     = 5000
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

# Chave SSH
resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "tf_key_pair" {
  key_name   = "tf-key-pair"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "local_file" "tf_key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tf-key-pair.pem"
}

# Instância EC2
resource "aws_instance" "app_ec2" {
  ami                    = "ami-0c02fb55956c7d316"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.tf_key_pair.key_name
  vpc_security_group_ids = [aws_security_group.app_security.id]

  tags = {
    Name = "terraform-ec2"
  }
}

# Saídas 
output "instance_id" {
  description = "ID da instância EC2"
  value       = aws_instance.app_ec2.id
}

output "instance_public_ip" {
  description = "IP público da instância EC2"
  value       = aws_instance.app_ec2.public_ip
}
