data "archive_file" "file" {
  type        = "zip"
  source_file = "function/index.js"
  output_path = "function/sample-lambda.zip"
}

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
