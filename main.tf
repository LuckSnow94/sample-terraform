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

resource "aws_lambda_function" "sample_lambda" {
  function_name = "sample-lambda"
  filename      = "sample-lambda.zip"
  runtime       = "nodejs14.x"
  handler       = "index.handler"
  role          = "test"
  memory_size   = "128"
  timeout       = "30"
}
