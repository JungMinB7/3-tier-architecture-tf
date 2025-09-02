resource "aws_db_subnet_group" "db_subnets" {
  name       = "${var.name}-db-subnets"
  subnet_ids = var.subnet_ids
  tags       = merge(var.tags, { Name = "${var.name}-db-subnets" })
}

resource "aws_db_parameter_group" "db_parameter" {
  count = var.parameter_group_family == null ? 0 : 1
  name  = "${var.name}-param"
  family = var.parameter_group_family
  tags   = var.tags

  dynamic "parameter" {
    for_each = var.parameters
    content {
      name  = parameter.value.name
      value = parameter.value.value
    }
  }
}

resource "aws_db_instance" "db_instance" {
  identifier                 = var.name
  engine                     = "mysql"
  engine_version             = var.engine_version
  instance_class             = var.instance_class
  allocated_storage          = var.allocated_storage
  max_allocated_storage      = var.max_allocated_storage
  storage_type               = "gp3"
  storage_encrypted          = true
  kms_key_id                 = var.kms_key_id

  username                   = var.master_username
  password                   = var.master_password

  db_subnet_group_name       = aws_db_subnet_group.db_subnets.name
  vpc_security_group_ids     = var.security_group_ids

  multi_az                   = var.multi_az
  publicly_accessible        = false
  port                       = 3306

  backup_retention_period    = var.backup_retention_days
  backup_window              = var.backup_window
  maintenance_window         = var.maintenance_window
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = var.skip_final_snapshot
  final_snapshot_identifier  = var.skip_final_snapshot ? null : "${var.name}-final"

  apply_immediately          = var.apply_immediately

  parameter_group_name       = var.parameter_group_family == null ? null : aws_db_parameter_group.db_parameter[0].name

  tags = var.tags
}
