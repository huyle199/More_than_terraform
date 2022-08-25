#loadbalancing main
resource "aws_lb" "huy_lb"{
  name = "huy_loadbalancer"
  subnets = var.public_subnets
  security_groups = [var.public_sg]
  idle_timeout = 400
}
