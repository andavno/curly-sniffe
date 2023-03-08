resource "aws_security_group" "acesso_geral" {
  name = var.grupodeSeguranca
  ingress{
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    ipv6_cidr_blocks = [ "::/0" ]
    protocol = "-1"
    to_port = 0
  } 
  egress{
    cidr_blocks = [ "0.0.0.0/0" ]
    from_port = 0
    ipv6_cidr_blocks = [ "::/0" ]
    protocol = "-1"
    to_port = 0
  }
  tags = {
    Name = "acesso_geral"
  }
}