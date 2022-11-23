output "api" {
  value = aws_api_gateway_rest_api.api
}

output "deployment" {
  value = aws_api_gateway_deployment.deployment
}
