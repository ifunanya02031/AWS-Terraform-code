#!/bin/bash

# ================================================================
# Define environment variables | EC2 USER DATA
# ================================================================
export SQL_SCRIPT_S3_URI="s3://nest-app-bucket-5-26/migration-dtb/V1__nest.sql" #sql file in bucket
export RDS_ENDPOINT="database1.c8pie66wkj4t.us-east-1.rds.amazonaws.com"
export RDS_DB_NAME="dev_nest_db"
export RDS_DB_USERNAME="admin"
export FLYWAY_VERSION="11.20.0"
export SECRET_NAME="nest-secrets1"
export AWS_REGION="us-east-1"

# ================================================================
# Retrieve RDS database credentials from AWS Secrets Manager
# ================================================================

# Install jq if not available (for JSON parsing) 
sudo yum install -y jq #edit json file- 

# Retrieve secret from Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id "${SECRET_NAME}" \
  --region "${AWS_REGION}" \
  --query SecretString \
  --output text)

# Parse username and password from JSON
export RDS_DB_PASSWORD=$(echo "${SECRET_JSON}" | jq -r '.password')

# ====================================================================
# Install Flyway and run database migrations | AUTOMATION | USER DATA
# ====================================================================

sudo yum update -y

# Navigate to a consistent directory
cd /home/ec2-user

# Download and extract Flyway on the home dir
sudo wget -qO- "https://download.red-gate.com/maven/release/com/redgate/flyway/flyway-commandline/${FLYWAY_VERSION}/flyway-commandline-${FLYWAY_VERSION}-linux-x64.tar.gz" | tar -xvz && sudo ln -s "$(pwd)/flyway-${FLYWAY_VERSION}/flyway" /usr/local/bin

# Create the SQL directory for migrations | data needs to be in a sql folder for flyway to migrate
sudo mkdir -p sql

# Download/Copy the (actual) migration SQL script from AWS S3
sudo aws s3 cp "${SQL_SCRIPT_S3_URI}" sql/

# Run Flyway migration | authenticating to RDS
sudo flyway -url="jdbc:mysql://${RDS_ENDPOINT}:3306/${RDS_DB_NAME}?allowPublicKeyRetrieval=true" \
  -user="${RDS_DB_USERNAME}" \
  -password="${RDS_DB_PASSWORD}" \
  -locations="filesystem:sql" \
  migrate