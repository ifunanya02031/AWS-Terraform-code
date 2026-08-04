resource "aws_db_subnet_group" "database_subnet_group" {

  name = "${var.environment}-database-subnet-group"

  subnet_ids = [  #2 AZs
    aws_subnet.private_data_subnet_az1.id,
    aws_subnet.private_data_subnet_az2.id
  ]

  tags = {
    Name = "${var.environment}-database-subnet-group"
  }
}

resource "aws_db_instance" "database_instance" {
    #identifier = "${var.environment}-${var.project_name}-database"

  engine         = var.database_engine
  engine_version = var.database_engine_version
  multi_az  = var.multi_az_deployment
  identifier = var.database_instance_identifier

  username = local.secrets.username #locals block
  password = local.secrets.password

  db_name = var.database_name
  instance_class    = var.database_instance_class
  allocated_storage = var.database_allocated_storage

  db_subnet_group_name = aws_db_subnet_group.database_subnet_group.name #.name

  vpc_security_group_ids = [
    aws_security_group.database_sg.id
  ]

  publicly_accessible = var.publicly_accessible

  skip_final_snapshot = true

  tags = {
    Name = "${var.environment}_database"
  }
}