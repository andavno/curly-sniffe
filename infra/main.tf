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
  availability_zones = [ "${var.region}a" ]
  name = var.nomeGrupo
  max_size = var.maximo
  min_size = var.minimo
  launch_template {
      id = aws_launch_template.maquina.id
      version = "$Latest"
    }
}

resource "aws_key_pair" "chaveSSH" {
  key_name = var.key
  public_key = file("${var.key}.pub")
}
