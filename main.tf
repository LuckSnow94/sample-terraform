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
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    apigateway = local.endpoint
    lambda     = local.endpoint
    s3         = local.endpoint
  }
}

# LAMBDA
resource "aws_lambda_function" "sample_lambda" {
  role          = "aws_iam_role.role.arn"
  function_name = "sample-lambda"
  filename      = "sample-lambda.zip"
  runtime       = "nodejs14.x"
  handler       = "index.handler"
  memory_size   = "128"
  timeout       = "5"
}

resource "aws_lambda_permission" "apigw_lambda" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.sample_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = aws_lambda_function.sample_lambda.arn
}

# API Gateway
resource "aws_api_gateway_rest_api" "sample_api" {
  name = "sample-api"
}

resource "aws_api_gateway_resource" "resource" {
  path_part   = "resource"
  parent_id   = aws_api_gateway_rest_api.sample_api.root_resource_id
  rest_api_id = aws_api_gateway_rest_api.sample_api.id
}

resource "aws_api_gateway_method" "method" {
  rest_api_id   = aws_api_gateway_rest_api.sample_api.id
  resource_id   = aws_api_gateway_resource.resource.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.sample_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.sample_lambda.invoke_arn
}

# IAM
# resource "aws_iam_role" "lambda_exec" {
#   name = "sample-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [{
#       Action = "sts:AssumeRole"
#       Effect = "Allow"
#       Sid    = ""
#       Principal = {
#         Service = "lambda.amazonaws.com"
#       }
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "lambda_policy" {
#   role       = aws_iam_role.lambda_exec.name
#   policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
# }
