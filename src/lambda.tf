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
