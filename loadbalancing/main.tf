#loadbalancing main
resource "aws_lb" "huy_lb"{
  name = "huy_loadbalancer"
  subnets = var.public_subnets
  security_groups = [var.public_sg]
  idle_timeout = 400
}

resource "aws_lb_target_group" "huy_tg"{
  name = "huy-lb-tg-$(substr(uuid(),0,3"
  port = var.tg_port #80
  protocol = var.tg_protocol #"HTTP"
  vpc_id = var.vpc_id
  health_check{
    healthy_threshold = var.lb_healthy_threshold
    unhealthy_threshold = var.lb_unhealthy_threshold
    timeout = var.lb_timeout
    interval =  var.lb_interval
}
