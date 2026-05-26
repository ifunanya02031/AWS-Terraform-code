# ===================================================================================
# WRAPPER OF DOCKERFILE | GIVE LOCATION OF DOCKERFILE TO WRAP IT
# PASS ARGUMENTS/VALUES
# Docker image is reusable/transferable/prepackaged (consistent) | Launch containers
# Define Docker build arguments
# VALUES BAKED INTO AN IMAGE 
# ====================================================================================

$PROJECT_NAME = "nest-app"
$ENVIRONMENT = "dev"
$RECORD_NAME = "www"
$DOMAIN_NAME = "http://nest-app-cntnr-alb-1595472623.us-east-1.elb.amazonaws.com"
$GITHUB_USERNAME = "Ifunanya02031"

$REPOSITORY_NAME = "nest-app-code" #repo with app. code | needs to clone into html dir.
$SERVICE_PROVIDER_FILE_NAME = "AppServiceProvider"
$APPLICATION_CODE_FILE_NAME = "nest" #.zip
$RDS_ENDPOINT = "nest-app-dtb-instance.c8pie66wkj4t.us-east-1.rds.amazonaws.com"
$RDS_DB_NAME = "nest_app_dtb"
$RDS_DB_USERNAME = "admin"

$IMAGE_NAME = "nest-docker-image"
$IMAGE_TAG = "latest-docker-image"

$SECRET_NAME = "nest-app-secrets"
$AWS_REGION = "us-east-1"

# ===================================================================================
# Retrieve secrets from AWS Secrets Manager | ATTACH IAM ROLE TO ECS(like EC2)/WEBAPP
# ===================================================================================

$SECRET_JSON = aws secretsmanager get-secret-value --secret-id $SECRET_NAME --region $AWS_REGION --query SecretString --output text
$SECRET = $SECRET_JSON | ConvertFrom-Json
$PERSONAL_ACCESS_TOKEN = $SECRET.personal_access_token
$RDS_DB_PASSWORD = $SECRET.password

# =================================================================================
# Enable BuildKit | retrieves and uses secrets during build process | Doesn't store
# =================================================================================

$env:DOCKER_BUILDKIT = 1
$env:PERSONAL_ACCESS_TOKEN_SECRET = $PERSONAL_ACCESS_TOKEN #temporarily stores in env. variables 
$env:RDS_DB_PASSWORD_SECRET = $RDS_DB_PASSWORD

# ================================================================
# Build Docker image
# ================================================================

docker build `
    --secret id=personal_access_token,env=PERSONAL_ACCESS_TOKEN_SECRET `
    --secret id=rds_db_password,env=RDS_DB_PASSWORD_SECRET `
    --build-arg PROJECT_NAME="$PROJECT_NAME" `
    --build-arg ENVIRONMENT="$ENVIRONMENT" `
    --build-arg RECORD_NAME="$RECORD_NAME" `
    --build-arg DOMAIN_NAME="$DOMAIN_NAME" `
    --build-arg GITHUB_USERNAME="$GITHUB_USERNAME" `
    --build-arg REPOSITORY_NAME="$REPOSITORY_NAME" `
    --build-arg SERVICE_PROVIDER_FILE_NAME="$SERVICE_PROVIDER_FILE_NAME" `
    --build-arg APPLICATION_CODE_FILE_NAME="$APPLICATION_CODE_FILE_NAME" `
    --build-arg RDS_ENDPOINT="$RDS_ENDPOINT" `
    --build-arg RDS_DB_NAME="$RDS_DB_NAME" `
    --build-arg RDS_DB_USERNAME="$RDS_DB_USERNAME" `
    -t "${IMAGE_NAME}:${IMAGE_TAG}" `
    . #Dockerfile in present dir. | must 'cd' | how it wraps it

# ================================================================
# Cleanup
# ================================================================

#clears secrets from env. variables | checks & balances
Remove-Item Env:\PERSONAL_ACCESS_TOKEN_SECRET, Env:\RDS_DB_PASSWORD_SECRET -ErrorAction SilentlyContinue