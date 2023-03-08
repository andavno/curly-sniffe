module "aws-prod" {
    source = "../../infra"
    instance = "t2.micro"
    region = "us-west-2"
    key = "IaC-PROD"
    name = "PROD instance"
    grupodeSeguranca = "Producao"
    maximo = 5
    minimo = 1
    nomeGrupo = "Prod"
}