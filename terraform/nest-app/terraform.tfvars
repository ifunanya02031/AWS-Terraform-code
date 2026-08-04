region = "us-east-1"
project_name = "nest"
environment = "dev-nest"
project_directory = "nest-app"

vpc_cidr = "10.0.0.0/16"

public_subnet_az1_cidr = "10.0.0.0/24"
public_subnet_az2_cidr = "10.0.1.0/24"

private_app_subnet_az1_cidr = "10.0.2.0/24"
private_app_subnet_az2_cidr = "10.0.3.0/24"

private_data_subnet_az1_cidr = "10.0.4.0/24"
private_data_subnet_az2_cidr = "10.0.5.0/24"

###################################################
# RDS Configuration
###################################################

database_engine = "mysql"

database_engine_version = "8.4.10" #s

database_instance_identifier = "database1"

database_name = "dev_nest_db"

database_instance_class = "db.t3.micro"

database_allocated_storage = 20

multi_az_deployment = true #

publicly_accessible = false

secret_name = "nest-secrets1"

##################################################
# Data Migration Server
##################################################

amazon_linux_ami_id = "ami-0b826bb6d96d2afe4" 

ec2_instance_type = "t3.micro"

##################################################
# S3 Migration Script
##################################################

sql_script_s3_uri = "s3://nest-app-bucket-5-26/migration-dtb/V1__nest.sql"

##################################################
# IAM
##################################################

instance_profile_name = "dev-nest-instance-profile"

##################################################
# Flyway
##################################################

flyway_version = "11.20.0"
