terraform{ #no variablizing in backend.tf
    backend "s3" {
        bucket = "nest-app-bucket-5-26"
        key = "nest/ec2/terraform.tfstate"
        region = "us-east-1"
        dynamodb_table = "nest-tf-state-lock"
        profile = "cloud-projects"
    }
}