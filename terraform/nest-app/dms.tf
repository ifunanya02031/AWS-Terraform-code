resource "aws_instance" "data_migrate_ec2" {

  ami           = var.amazon_linux_ami_id
  instance_type = var.ec2_instance_type

  subnet_id = aws_subnet.private_app_subnet_az1.id

  vpc_security_group_ids = [
    aws_security_group.dms_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.s3_full_access_instance_profile.name #iam

  user_data_base64 = base64encode(
    file("${path.module}/db-migrate-script.sh")
  )

  tags = {
    Name = "${var.environment}-data-migration-server"
  }
}