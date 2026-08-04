provider "aws"{ #authenticating terraform with aws
    region = "us-east-1"
    profile = "cloud-projects" 

    default_tags {
      tags = { #
        "Automation" = "terraform"
        "Project" = "var.project_name"
        "Environment" = "var.environment"
      }
    }
}