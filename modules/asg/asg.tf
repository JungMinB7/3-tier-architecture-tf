resource "aws_launch_template" "launch_template" {
  name_prefix   = "${var.name}-lt-"
  image_id      = var.ami
  instance_type = var.instance_type
  key_name      = var.key_name

  iam_instance_profile {
    name = var.iam_instance_profile
  }

  vpc_security_group_ids = var.security_group_ids
  user_data              = var.user_data_base64

  update_default_version = true

  metadata_options {
    http_tokens = "required"
  }

  dynamic "block_device_mappings" {
    for_each = var.root_block_device == null ? [] : [var.root_block_device]
    content {
      device_name = lookup(block_device_mappings.value, "device_name", "/dev/xvda")
      ebs {
        volume_size = lookup(block_device_mappings.value, "volume_size", 20)
        volume_type = lookup(block_device_mappings.value, "volume_type", "gp3")
        encrypted   = lookup(block_device_mappings.value, "encrypted", true)
      }
    }
  }

  tag_specifications {
    resource_type = "instance"
    tags          = merge(var.tags, { Name = "${var.name}-instance" })
  }
}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.name}-asg"
  vpc_zone_identifier       = var.subnet_ids
  target_group_arns         = var.target_group_arns
  desired_capacity          = var.desired_capacity
  min_size                  = var.min_size
  max_size                  = var.max_size
  health_check_type         = var.health_check_type
  health_check_grace_period = var.health_check_grace_period
  termination_policies      = var.termination_policies

  launch_template {
    id      = aws_launch_template.launch_template.id
    version = "$Latest"
  }

  capacity_rebalance = true
  wait_for_elb_capacity = var.wait_for_elb_capacity

  tag {
    key                 = "Name"
    value               = "${var.name}-asg"
    propagate_at_launch = true
  }

  dynamic "instance_maintenance_policy" {
    for_each = var.instance_maintenance_policy == null ? [] : [var.instance_maintenance_policy]
    content {
      min_healthy_percentage = instance_maintenance_policy.value.min_healthy_percentage
      max_healthy_percentage = instance_maintenance_policy.value.max_healthy_percentage
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_policy" "cpu_target" {
  count                  = var.enable_target_tracking ? 1 : 0
  name                   = "${var.name}-cpu-ttsp"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.asg.name

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value       = var.cpu_target_value
    disable_scale_in   = false
  }
}
