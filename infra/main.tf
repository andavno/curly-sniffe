terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }
  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = var.region
}

resource "aws_launch_template" "maquina" {
  image_id         = "ami-830c94e3"
  instance_type = var.instance
  key_name = var.key
  tags = {
    Name = "Terraform Ansible Python"
  }
  security_group_names = [ var.grupodeSeguranca ]
  user_data = filebase64("ansible.sh")
}

resource "aws_autoscaling_group" "grupo" {
  availability_zones = [ "${var.region}a", "${var.region}b" ]
  name = var.nomeGrupo
  max_size = var.maximo
  min_size = var.minimo
  launch_template {
      id = aws_launch_template.maquina.id
      version = "$Latest"
    }
    target_group_arns = [ aws_lb_target_group.alvoLoadBalancer.arn ]
}

resource "aws_key_pair" "chaveSSH" {
  key_name = var.key
  public_key = file("${var.key}.pub")
}

resource "aws_default_subnet" "subnet_a" {
  availability_zone =  "${var.region}a"
}

resource "aws_default_subnet" "subnet_b" {
  availability_zone =  "${var.region}b"
}
resource "aws_lb" "loadBalancer" {
  internal = false
  subnets = [ aws_default_subnet.subnet_a.id, aws_default_subnet.subnet_b.id ]
}
resource "aws_lb_target_group" "alvoLoadBalancer" {
  name = "maquinasAlvo"
  port = "8000"
  protocol = "HTTP"
  vpc_id = aws_default_vpc.default.id
}
resource "aws_default_vpc" "default" {
  
}
resource "aws_lb_listener" "entradaLoadBalancer" {
  load_balancer_arn = aws_lb.loadBalancer.arn
  port = "8000"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alvoLoadBalancer.arn
  }
}

resource "aws_autoscaling_policy" "escala-Producao" {
  name = "terraform-escala"
  autoscaling_group_name = var.nomeGrupo
  policy_type = "TargetTrackingScaling"
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 50.0
  }
}