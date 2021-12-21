################ network load balancer ################
resource "aws_lb" "lb" {
  name                       = "np-terraform-lb"
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = [for id in var.public_subnets_id : id]
  enable_deletion_protection = false
}

################ load balancer listner ################
resource "aws_lb_listener" "listner" {
  load_balancer_arn = aws_lb.lb.arn
  port              = "80"
  protocol          = "TCP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb-tg.arn
  }
}

################ load balancer target group ################
resource "aws_lb_target_group" "lb-tg" {
  name     = "np-terraform-lb-tg"
  port     = 80
  protocol = "TCP"
  vpc_id   = var.vpc_id
}

# resource "aws_lb_target_group_attachment" "test" {
#   target_group_arn = aws_lb_target_group.test.arn
#   autoscaling_group_name = aws_autoscaling_group.MyWPReaderNodesASGroup.id
#   target_id        = aws_instance.test.id
#   port             = 80
# }

