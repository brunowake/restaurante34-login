terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = ">= 4.10"
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

  cloud {
    organization = "restaurante34"

    workspaces {
      name = "restaurante34"
    }
  }
}

variable "AWS_ACCESS_KEY_ID" {
   type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
   type = string
}

provider "aws" {
  region  = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

resource "aws_cognito_user_pool" "restaurante34_user_pool" {
  name = "restaurante34-user-pool"  
}

resource "aws_cognito_user_pool_client" "restaurante34_user_pool_client" {
  name = "restaurante34-user-pool-client" 
  user_pool_id = aws_cognito_user_pool.restaurante34_user_pool.id

}

resource "aws_api_gateway_rest_api" "restaurante34-api" {
  name = "restaurante34-api" 
}

resource "aws_api_gateway_resource" "restaurante34-api_resource" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  parent_id   = aws_api_gateway_rest_api.restaurante34-api.root_resource_id
  path_part   = "restaurante34"  
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

resource "aws_lambda_permission" "restaurante34_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_singUp.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.restaurante34-api.execution_arn}/*/*"
}

resource "aws_lambda_function" "terraform_singUp" {
  function_name     = "signUp"
  filename          = "signUp.zip"
  runtime           = "nodejs20.x"
  handler           = "index.handler"
  source_code_hash  = data.archive_file.lambda_terraform_signUp.output_base64sha256
  role              = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "terraform_singIn" {
  function_name     = "signIn"
  filename          = "signIn.zip"
  runtime           = "nodejs20.x"
  handler           = "index.handler"
  source_code_hash  = data.archive_file.lambda_terraform_signIn.output_base64sha256
  role              = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "terraform_confirm_signUp" {
  function_name     = "confirmSignUp"
  filename          = "confirmSignUp.zip"
  runtime           = "nodejs20.x"
  handler           = "index.handler"
  source_code_hash  = data.archive_file.lambda_terraform_confirm_signUp.output_base64sha256
  role              = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_permission" "terraform_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_singUp.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.restaurante34-api.execution_arn}/*/*"
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}