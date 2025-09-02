resource "aws_instance" "ec2" {
  ami                         = var.ami
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  key_name                    = var.key_name
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = var.associate_public_ip_address

  user_data                   = var.user_data
  user_data_replace_on_change = true

  metadata_options {
    http_tokens = "required"
  }

  dynamic "root_block_device" {
    for_each = var.root_block_device == null ? [] : [var.root_block_device]
    content {
      volume_size = lookup(root_block_device.value, "volume_size", 20)
      volume_type = lookup(root_block_device.value, "volume_type", "gp3")
      encrypted   = lookup(root_block_device.value, "encrypted", true)
    }
  }

  tags = merge(var.tags, { Name = var.name })
}
