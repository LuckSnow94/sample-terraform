terraform {
  required_version = "1.3.5"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.39.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.1.0"
    }
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }
}

provider "aws" {
  access_key                  = "accesskeytest"
  secret_key                  = "secretkeytest"
  region                      = "us-east-1"
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true
  skip_credentials_validation = true

  endpoints {
    apigateway     = local.endpoint
    apigatewayv2   = local.endpoint
    cloudformation = local.endpoint
    cloudwatch     = local.endpoint
    cloudwatchlogs = local.endpoint
    dynamodb       = local.endpoint
    ec2            = local.endpoint
    es             = local.endpoint
    elasticache    = local.endpoint
    firehose       = local.endpoint
    iam            = local.endpoint
    kinesis        = local.endpoint
    lambda         = local.endpoint
    rds            = local.endpoint
    redshift       = local.endpoint
    route53        = local.endpoint
    s3             = local.s3
    secretsmanager = local.endpoint
    ses            = local.endpoint
    sns            = local.endpoint
    sqs            = local.endpoint
    ssm            = local.endpoint
    stepfunctions  = local.endpoint
    sts            = local.endpoint
  }
}

provider "archive" {}

provider "random" {}
