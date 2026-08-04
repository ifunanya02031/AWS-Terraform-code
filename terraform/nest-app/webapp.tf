resource "aws_instance" "web_app_ec2" {

  ami           = var.amazon_linux_ami_id
  instance_type = var.ec2_instance_type

  subnet_id = aws_subnet.private_app_subnet_az1.id

  vpc_security_group_ids = [
    aws_security_group.web_app_sg.id
  ]

  iam_instance_profile = aws_iam_instance_profile.web_app_instance_profile.name

  user_data_base64 = base64encode(
    file("${path.module}/web-app-deploy.sh")
  )

  tags = {
    Name = "${var.environment}-web-app"
  }
}