resource "aws_security_group" "security_group" {
  name   = "security_group"
  vpc_id = var.vpc #aws_vpc.vpc.id

  dynamic "ingress" {
    for_each = var.sg_ports
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = var.sg_cidr_blocks
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = var.sg_cidr_blocks
  }

  tags = {
    Name = "Security Group"
  }
}
