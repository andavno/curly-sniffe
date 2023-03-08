module "aws-dev" {
    source = "../../infra"
    instance = "t2.micro"
    region = "us-west-2"
    key = "IaC-DEV"
    name = "DEV instance"
    grupodeSeguranca = "DEV"
    minimo = 0
    maximo = 1
    nomeGrupo = "Dev"
}
