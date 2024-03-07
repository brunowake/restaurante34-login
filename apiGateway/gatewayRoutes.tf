# singUp route

resource "aws_api_gateway_resource" "restaurante34-api_resource" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  parent_id   = aws_api_gateway_rest_api.restaurante34-api.root_resource_id
  path_part   = "singUp"  
}

resource "aws_api_gateway_method" "restaurante34-api_method" {
  rest_api_id   = aws_api_gateway_rest_api.restaurante34-api.id
  resource_id   = aws_api_gateway_resource.restaurante34-api_resource.id
  http_method   = "POST"  
  authorization = "NONE" 
}

resource "aws_api_gateway_integration" "restaurante34-api_integration" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  resource_id = aws_api_gateway_resource.restaurante34-api_resource.id
  http_method = aws_api_gateway_method.restaurante34-api_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.terraform_singUp.invoke_arn
}
