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

data "archive_file" "file" {
  type        = "zip"
  source_file = "function/index.js"
  output_path = "function/sample-lambda.zip"
}

# S3 Bucket
resource "random_pet" "bucket_name" {
  prefix = "sample-lambda"
  length = 4
}

resource "aws_s3_bucket" "bucket" {
  bucket = random_pet.bucket_name.id
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.bucket.id
  key    = "sample-lambda.zip"
  source = data.archive_file.file.output_path
  etag   = filemd5(data.archive_file.file.output_path)
}

# LAMBDA
resource "aws_lambda_function" "lambda" {
  function_name    = "sample-lambda"
  runtime          = "nodejs14.x"
  handler          = "index.handler"
  memory_size      = "128"
  timeout          = "5"
  s3_bucket        = aws_s3_bucket.bucket.id
  s3_key           = aws_s3_object.object.key
  source_code_hash = data.archive_file.file.output_base64sha256
  role             = aws_iam_role.role.arn
}

resource "aws_lambda_permission" "permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_api_gateway_rest_api.api.execution_arn

  depends_on = [
    aws_api_gateway_rest_api.api
  ]
}

# API Gateway
resource "aws_api_gateway_rest_api" "api" {
  name = "sample-api"
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "test"
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.api.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "ANY"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
  timeout_milliseconds    = 5000
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.api.id

  depends_on = [
    aws_api_gateway_resource.resource,
    aws_api_gateway_method.method,
    aws_api_gateway_integration.integration,
  ]

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.resource.id,
      aws_api_gateway_method.method.id,
      aws_api_gateway_integration.integration.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}

# IAM
resource "aws_iam_role" "role" {
  name = "role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "policy" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

output "api" {
  value = aws_api_gateway_rest_api.api
}

output "deployment" {
  value = aws_api_gateway_deployment.deployment
}
