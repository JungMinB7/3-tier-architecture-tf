output "asg_name"     { value = aws_autoscaling_group.asg.name }
output "lt_id"        { value = aws_launch_template.launch_template.id }
output "lt_latest"    { value = aws_launch_template.launch_template.latest_version }
