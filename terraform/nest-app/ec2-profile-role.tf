#DMS IAM ROLE

resource "aws_iam_role" "s3_full_access_role" {

  name = "${var.environment}-role-s3-full-access"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Action = "sts:AssumeRole"

        Effect = "Allow"

        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_full_access_policy_attachment" { 

  role = aws_iam_role.s3_full_access_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_instance_profile" "s3_full_access_instance_profile" { ###

  name = "${var.environment}-instance-profile"

  role = aws_iam_role.s3_full_access_role.name
}

#WEB APP IAM ROLE

resource "aws_iam_role" "web_app_role" {

  name = "${var.environment}-web-app-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Action = "sts:AssumeRole"

        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "web_app_s3_access" { #Policy1

  role = aws_iam_role.web_app_role.name

  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_role_policy_attachment" "web_app_secret_access" { #RDS authenticate & store data

  role = aws_iam_role.web_app_role.name

  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

resource "aws_iam_instance_profile" "web_app_instance_profile" {

  name = "${var.environment}-web-app-profile"

  role = aws_iam_role.web_app_role.name
}