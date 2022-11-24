output "rest_api_id" {
  description = "Rest API string to include in request path."
  value       = aws_api_gateway_rest_api.api.id
}
