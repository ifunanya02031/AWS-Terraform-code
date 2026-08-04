data "aws_secretsmanager_secret_version" "secrets" {
  secret_id = var.secret_name
}

locals {
  secrets = jsondecode( #parsing json
    data.aws_secretsmanager_secret_version.secrets.secret_string
  )
}