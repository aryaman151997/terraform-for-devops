# key pair (login)

resource "aws_key_pair" "my_key" {

  key_name   = "${var.env}-terraform-instance-key"
  public_key = file("terraform-instance-key.pub")
  tags = {
    Environment = var.env
  }
}

# VPC 
resource "aws_default_vpc" "default" {

}

# Security group

resource "aws_security_group" "terraform-sg" {
  name        = "${var.env}-terraform-sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_default_vpc.default.id

  # inbound rules

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http open"
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "ssh open"
  }


  # outbound rules

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "all access to outbound "
  }

  tags = {
    Name = "terraform-sg"
  }
}

# ec2 instance


resource "aws_instance" "my_instance" {
  count = 3  
  security_groups = [aws_security_group.terraform-sg.name]
  key_name        = "terraform-instance-key"
  instance_type   = var.ec2_instance_type
  ami             = var.ec2_ami_id
  user_data       = file("install_nginx.sh")

  root_block_device {
    volume_size = var.env == "prd" ? 20 : var.ec2_default_root_storage_size
    volume_type = "gp3"
  }
  tags = {
    Name = "terraform ec2"
    Environment = var.env
  }

}
