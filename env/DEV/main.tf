module "aws-dev" {
    source = "../../infra"
    instance = "t2.micro"
    region = "us-west-2"
    key = "IaC-DEV"
    name = "DEV instance"
}

output "dev_IP" {
  value = module.aws-dev.public_IP
}