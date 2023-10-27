resource "aws_db_instance" "wordpress" {
  allocated_storage     = 10
  max_allocated_storage = 100
  #identifier           = var.rds_db_identifier
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = var.rds_instance_type
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  skip_final_snapshot  = true

  vpc_security_group_ids = [
    aws_security_group.wordpress_db.id
  ]

  tags = var.tags
}