#EICE SG

resource "aws_security_group" "eice_sg" {

  name        = "${var.environment}-eice-sg"
  description = "EICE Security Group"
  vpc_id      = aws_vpc.vpc.id

  egress {

    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr] #
  }

  tags = {
    Name = "${var.environment}-eice-sg"
  }
}

# ALB SG

resource "aws_security_group" "alb_sg" {

  name   = "${var.environment}-alb-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]
  }

  egress { #All traffic

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-alb-sg"
  }
}

# WEB APP SG
resource "aws_security_group" "web_app_sg" {

  name   = "${var.environment}-web-app-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {

    from_port = 80
    to_port   = 80
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb_sg.id
    ]
  }

  ingress {

    from_port = 443
    to_port   = 443
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb_sg.id
    ]
  }

  ingress {

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = [
      aws_security_group.eice_sg.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-web-app-sg"
  }
}

# DATA MIGRATION SERVER SG

resource "aws_security_group" "dms_sg" {

  name   = "${var.environment}-dms-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    security_groups = [
      aws_security_group.eice_sg.id
    ]
  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.environment}-dms-sg"
  }
}

# DATABASE SG

resource "aws_security_group" "database_sg" {

  name   = "${var.environment}-database-sg"
  vpc_id = aws_vpc.vpc.id

  ingress {

    from_port = 3306 #MYSQL AURORA
    to_port   = 3306
    protocol  = "tcp"

    security_groups = [
      aws_security_group.web_app_sg.id #people's data from webserver
    ]
  }

  ingress {

    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    security_groups = [
      aws_security_group.dms_sg.id #data structure for database
    ]
  }

  tags = {
    Name = "${var.environment}-database-sg"
  }
}