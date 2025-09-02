locals {
  hc = merge(
    {
      path = "/health", interval = 30, timeout = 5,
      healthy_threshold = 3, unhealthy_threshold = 3, matcher = "200-399"
    },
    var.health_check
  )
}

resource "aws_lb" "alb" {
  name               = var.name
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = var.security_group_ids
  idle_timeout       = var.idle_timeout
  enable_deletion_protection = var.deletion_protection
  tags               = var.tags
}

resource "aws_lb_target_group" "alb_tg" {
  name        = "${var.name}-tg"
  port        = var.target_group_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = var.target_type

  health_check {
    enabled             = true
    path                = local.hc.path
    interval            = local.hc.interval
    timeout             = local.hc.timeout
    healthy_threshold   = local.hc.healthy_threshold
    unhealthy_threshold = local.hc.unhealthy_threshold
    matcher             = local.hc.matcher
  }
  tags = var.tags
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  dynamic "default_action" {
    for_each = (var.certificate_arn != null && var.redirect_to_https) ? [1] : []
    content {
      type = "redirect"
      redirect {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
      }
    }
  }

  dynamic "default_action" {
    for_each = (var.certificate_arn == null || !var.redirect_to_https) ? [1] : []
    content {
      type             = "forward"
      target_group_arn = aws_lb_target_group.alb_tg.arn
    }
  }
}

resource "aws_lb_listener" "https" {
  count             = var.certificate_arn != null ? 1 : 0
  load_balancer_arn = aws_lb.alb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.alb_tg.arn
  }
}

