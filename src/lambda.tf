resource "aws_lambda_function" "lambda" {
  function_name    = "sample-lambda"
  runtime          = "nodejs12.x"
  handler          = "index.handler"
  memory_size      = "128"
  timeout          = "5"
  s3_bucket        = aws_s3_bucket.bucket.id
  s3_key           = aws_s3_object.object.key
  source_code_hash = data.archive_file.file.output_base64sha256
  role             = "sample-role"
}
