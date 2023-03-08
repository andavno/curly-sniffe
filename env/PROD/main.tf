module "aws-prod" {
    source = "../../infra"
    instance = "t2.micro"
    region = "us-west-2"
    key = "IaC-PROD"
    name = "PROD instance"
}

output "prod_IP" {
  value = module.aws-prod.public_IP
}