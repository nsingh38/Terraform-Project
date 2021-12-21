# data "aws_ami" "linux" {
#   most_recent = true
#   filter {
#     name   = "name"
#     values = ["amzn2-ami-kernel-5.10-hvm-2.0.20211201.0-x86_64-gp2-*"]
#   }
#   filter {
#     name   = "root-device-type"
#     values = ["ebs"]
#   }
#   filter {
#     name   = "virtualization-type"
#     values = ["hvm"]
#   }
#   owners = ["099720109477"] # Canonical
# }

################ key pair ################
resource "aws_key_pair" "key" {
  key_name   = "np-terraform-key-pair"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCdZX3KFUNDPGYVE8UABfQsYJJXxN33XYf5gp91/VLd+bt1AkqKnBTmxIIZk/3SzefFlIvhjH2fcEuHIM5DyxUtyLk2VfToTBotpx3kCwWx7wVfSU8sApvmLq6Fb6APCUABoJ7htrVR3SAKatT+pZft5H+Wx9VjliZ1T+91kAf6niUyXIcUu3pG1zuRPsKccq6RjWrzVNr3APZk95ZHThDSpwJDrnPfw08P83r+Cd39vZ9HtaQGbLUI/yFPg8MQ5K2hly3HPge+rdhNwiI6t4NSaMSoJry/7mbA99XvK1CV3ZlXOuxFl+tDYMq6V66Sgh2bae+Gt02jnSsmnDkBzrFv"
}

################ security group ################
resource "aws_security_group" "sg" {
  name   = "np-terraform-sg"
  vpc_id = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
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
    from_port = 0
    to_port   = 0
    protocol  = "-1"
    self      = true
  }
  ingress {
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "np-terraform-sg"
  }
}

################ launch configuration ################
resource "aws_launch_configuration" "launch_config" {
  name              = "np-terraform-launch-config"
  image_id          = "ami-0ed9277fb7eb570c9"
  instance_type     = "t2.micro"
  user_data         = <<EOF
  #!/bin/bash
  sudo yum install amazon-efs-utils -y
  sudo amazon-linux-extras install nginx1 -y
  sudo systemctl start nginx
  EOF
  key_name          = aws_key_pair.key.id
  security_groups   = [aws_security_group.sg.id]
  enable_monitoring = false
  root_block_device {
    delete_on_termination = true
    encrypted             = false
    volume_size           = 8
    volume_type           = "gp2"
  }
}

################ autoscaling group ################
resource "aws_autoscaling_group" "asg" {
  name                 = "np-terraform-asg"
  launch_configuration = aws_launch_configuration.launch_config.name
  min_size             = 1
  max_size             = 2
  desired_capacity     = 2
  vpc_zone_identifier  = [for id in var.private_subnets_id : id]
  target_group_arns    = [var.tg-arn]
}
