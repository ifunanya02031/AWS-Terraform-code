variable "region" {
    type = string
}

variable "project_name" {
    type = string
}

variable "environment" {
    description = "Environment (dev, staging, prod)"
    type = string
}

variable "project_directory" { #where tf code is located
    description = "Project directory name"
    type = string
}

variable "vpc_cidr" {
  type = string
}

variable "public_subnet_az1_cidr" {
  type = string
}

variable "public_subnet_az2_cidr" {
  type = string
}

variable "private_app_subnet_az1_cidr" {
  type = string
}

variable "private_app_subnet_az2_cidr" {
  type = string
}

variable "private_data_subnet_az1_cidr" {
  type = string
}

variable "private_data_subnet_az2_cidr" {
  type = string
}

##################################################
# Secrets Manager
##################################################

variable "secret_name" {
  type        = string
}

##################################################
# RDS
##################################################

variable "database_engine" {
  type        = string
}
variable "database_instance_identifier" {
  type = string
  
}
variable "database_engine_version" {
  type        = string
}

variable "database_name" {
  type        = string
}

variable "database_instance_class" {
  type        = string
}

variable "database_allocated_storage" {
  type        = number
}

variable "multi_az_deployment" { #
  type        = bool
}

variable "publicly_accessible" {
  type        = bool
}
##################################################
# Data Migration Server
##################################################

variable "amazon_linux_ami_id" {
  type        = string
}

variable "ec2_instance_type" {
  type        = string
}

##################################################
# S3 Migration Script
##################################################

variable "sql_script_s3_uri" {
  type        = string
}

##################################################
# IAM
##################################################

variable "instance_profile_name" {
  type        = string
}

##################################################
# Flyway
##################################################

variable "flyway_version" {
  type        = string
}
