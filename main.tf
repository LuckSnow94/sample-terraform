terraform {
  required_version = "1.3.4"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.39.0"
    }
  }
}

provider "aws" {
  profile                     = "default"
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway = var.endpoint
    lambda     = var.endpoint
    s3         = var.endpoint
  }
}
