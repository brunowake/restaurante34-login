
resource "aws_api_gateway_rest_api" "restaurante34-api" {
  name = "restaurante34-api" 
}

resource "aws_iam_policy" "api_gateway_access_policy" {
  name        = "api_gateway_access_policy"
  description = "Allows access to API Gateway resources"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "apigateway:GET"
        Resource = "arn:aws:apigateway:us-east-1::/restapis/sxxs67mloi/resources/tcpqt2/methods/POST/integration"
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "api_gateway_access_attachment" {
  name       = "api_gateway_access_attachment"
  users      = ["restaurante34-cicd"]  # Provide the name of the existing IAM user here
  policy_arn = aws_iam_policy.api_gateway_access_policy.arn
}

resource "aws_api_gateway_deployment" "prod_deployment" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  stage_name  = "prod"

}
resource "aws_api_gateway_stage" "prod_stage" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  stage_name  = "prod"
  deployment_id = aws_api_gateway_deployment.prod_deployment.id
}