#!/bin/bash
set -e

# ================================================================
# CONFIG
# ================================================================

export PROJECT_NAME="nest"
export ENVIRONMENT="dev"

export APP_URL="http://web-app-nest-alb-2-484597763.us-east-1.elb.amazonaws.com" #revisit

export WEB_FILES_S3_URI="s3://nest-app-bucket-5-26/nest/webfiles/nest.zip"
export SERVICE_PROVIDER_FILE_S3_URI="s3://nest-app-bucket-5-26/nest/webfiles/AppServiceProvider.php"
export APPLICATION_CODE_FILE_NAME="nest"

export RDS_ENDPOINT="database1.c8pie66wkj4t.us-east-1.rds.amazonaws.com"
export RDS_DB_NAME="dev_nest_db"
export RDS_DB_USERNAME="admin"

export SECRET_NAME= "nest-secrets1"
export AWS_REGION="us-east-1"

# ================================================================
# INSTALL DEPENDENCIES
# ================================================================

sudo yum update -y
sudo yum install -y jq unzip awscli wget

sudo dnf install -y \
httpd php php-cli php-fpm php-mysqlnd php-bcmath php-ctype \
php-fileinfo php-json php-mbstring php-openssl php-pdo php-gd \
php-tokenizer php-xml php-curl

# ================================================================
# VERIFY IAM ROLE
# ================================================================

aws sts get-caller-identity

# ================================================================
# GET SECRETS FROM AWS
# ================================================================

SECRET_JSON=$(aws secretsmanager get-secret-value \
  --secret-id "${SECRET_NAME}" \
  --region "${AWS_REGION}" \
  --query SecretString \
  --output text)

echo "Secret retrieved successfully"

export RDS_DB_PASSWORD=$(echo "${SECRET_JSON}" | jq -r '.password')

if [ -z "$RDS_DB_PASSWORD" ]; then
  echo "ERROR: DB password missing from Secrets Manager"
  exit 1
fi

# ================================================================
# CONFIGURE APACHE / PHP
# ================================================================

sudo sed -i '/^memory_limit =/ s/=.*$/= 256M/' /etc/php.ini
sudo sed -i '/^max_execution_time =/ s/=.*$/= 300/' /etc/php.ini

sudo sed -i '/<Directory "\/var\/www\/html">/,/<\/Directory>/ s/AllowOverride None/AllowOverride All/' /etc/httpd/conf/httpd.conf

# ================================================================
# DEPLOY APPLICATION FROM S3
# ================================================================

cd /var/www/html

sudo aws s3 cp "${WEB_FILES_S3_URI}" .

# NON-INTERACTIVE UNZIP (FIXED)
sudo unzip -o -q "${APPLICATION_CODE_FILE_NAME}.zip" -d "${APPLICATION_CODE_FILE_NAME}"

sudo cp -R "${APPLICATION_CODE_FILE_NAME}/." .

sudo rm -rf "${APPLICATION_CODE_FILE_NAME}" "${APPLICATION_CODE_FILE_NAME}.zip"

# ================================================================
# PERMISSIONS
# ================================================================

sudo chmod -R 755 /var/www/html
sudo chmod -R 775 /var/www/html/storage
sudo chmod -R 775 /var/www/html/bootstrap/cache

# ================================================================
# SAFE .ENV GENERATION (NO SED - FULL FIX)
# ================================================================

sudo tee .env > /dev/null <<EOF
APP_NAME=${PROJECT_NAME}-${ENVIRONMENT}
APP_URL=${APP_URL}

DB_CONNECTION=mysql
DB_HOST=${RDS_ENDPOINT}
DB_DATABASE=${RDS_DB_NAME}
DB_USERNAME=${RDS_DB_USERNAME}
DB_PASSWORD=${RDS_DB_PASSWORD}

APP_ENV=production
APP_DEBUG=false
EOF

echo "---- FINAL .env ----"
cat .env

# ================================================================
# REPLACE SERVICE PROVIDER FILE
# ================================================================

sudo aws s3 cp "${SERVICE_PROVIDER_FILE_S3_URI}" \
/var/www/html/app/Providers/AppServiceProvider.php

# ================================================================
# START APACHE
# ================================================================

sudo systemctl enable httpd
sudo systemctl start httpd
sudo systemctl status httpd