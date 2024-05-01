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
resource "aws_api_gateway_rest_api" "restaurante34-api" {
  name = "restaurante34-api" 
}

resource "aws_api_gateway_resource" "restaurante34-api_signUp_resource" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  parent_id   = aws_api_gateway_rest_api.restaurante34-api.root_resource_id
  path_part   = "signUp"  
}

resource "aws_api_gateway_method" "restaurante34-api_signUp_method" {
  rest_api_id   = aws_api_gateway_rest_api.restaurante34-api.id
  resource_id   = aws_api_gateway_resource.restaurante34-api_signUp_resource.id
  http_method   = "POST"  
  authorization = "NONE" 
}
resource "aws_api_gateway_integration" "restaurante34-api_signUp_integration" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  resource_id = aws_api_gateway_resource.restaurante34-api_signUp_resource.id
  http_method = aws_api_gateway_method.restaurante34-api_signUp_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.terraform_singUp.invoke_arn
}

resource "aws_api_gateway_resource" "restaurante34-api_signIn_resource" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  parent_id   = aws_api_gateway_rest_api.restaurante34-api.root_resource_id
  path_part   = "signIn"  
}

resource "aws_api_gateway_method" "restaurante34-api_signIn_method" {
  rest_api_id   = aws_api_gateway_rest_api.restaurante34-api.id
  resource_id   = aws_api_gateway_resource.restaurante34-api_signIn_resource.id
  http_method   = "POST"  
  authorization = "NONE" 
}

resource "aws_api_gateway_integration" "restaurante34-api_signIn_integration" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  resource_id = aws_api_gateway_resource.restaurante34-api_signIn_resource.id
  http_method = aws_api_gateway_method.restaurante34-api_signIn_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.terraform_singIn.invoke_arn
}


resource "aws_api_gateway_resource" "restaurante34-api_confirmSignUp_resource" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  parent_id   = aws_api_gateway_rest_api.restaurante34-api.root_resource_id
  path_part   = "confirmSignUp"  
}

resource "aws_api_gateway_method" "restaurante34-api_confirmSignUp_method" {
  rest_api_id   = aws_api_gateway_rest_api.restaurante34-api.id
  resource_id   = aws_api_gateway_resource.restaurante34-api_confirmSignUp_resource.id
  http_method   = "POST"  
  authorization = "NONE" 
}

resource "aws_api_gateway_integration" "restaurante34-api_confirmSignUp_integration" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  resource_id = aws_api_gateway_resource.restaurante34-api_confirmSignUp_resource.id
  http_method = aws_api_gateway_method.restaurante34-api_confirmSignUp_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.terraform_confirm_signUp.invoke_arn
}

resource "aws_api_gateway_resource" "restaurante34-api_getUsers_resource" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  parent_id   = aws_api_gateway_rest_api.restaurante34-api.root_resource_id
  path_part   = "signUp"  
}

resource "aws_api_gateway_method" "restaurante34-api_getUsers_method" {
  rest_api_id   = aws_api_gateway_rest_api.restaurante34-api.id
  resource_id   = aws_api_gateway_resource.restaurante34-api_getUsers_resource.id
  http_method   = "POST"  
  authorization = "NONE" 
}
resource "aws_api_gateway_integration" "restaurante34-api_getUsers" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  resource_id = aws_api_gateway_resource.restaurante34-api_getUsers_resource.id
  http_method = aws_api_gateway_method.restaurante34-api_getUsers_method.http_method
  type        = "AWS_PROXY"
  integration_http_method = "POST"
  uri         = aws_lambda_function.terraform_getUsers.invoke_arn
}

resource "aws_lambda_permission" "terraform_lambda_permission_getUsers" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_getUsers.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.restaurante34-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "terraform_lambda_permission_signUp" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_singUp.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.restaurante34-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "terraform_lambda_permission_signIn" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_singIn.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.restaurante34-api.execution_arn}/*/*"
}

resource "aws_lambda_permission" "terraform_lambda_permission_confirmSignUp" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_confirm_signUp.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.restaurante34-api.execution_arn}/*/*"
}
variable "AWS_ACCESS_KEY_ID" {
   type = string
}

variable "AWS_SECRET_ACCESS_KEY" {
   type = string
}

variable "AWS_COGNITO_CLIENT_ID" {
   type = string
}
variable "API_URL" {
   type = string
}

provider "aws" {
  region  = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
}

data "archive_file" "lambda_terraform_getUsers" {
  type = "zip"

  source_dir  = "${path.module}/getUsers"
  output_path = "${path.module}/getUsers.zip"
}
data "archive_file" "lambda_terraform_signUp" {
  type = "zip"

  source_dir  = "${path.module}/signUp"
  output_path = "${path.module}/signUp.zip"
}

data "archive_file" "lambda_terraform_signIn" {
  type = "zip"

  source_dir  = "${path.module}/signIn"
  output_path = "${path.module}/signIn.zip"
}

data "archive_file" "lambda_terraform_confirm_signUp" {
  type = "zip"

  source_dir  = "${path.module}/confirmSignUp"
  output_path = "${path.module}/confirmSignUp.zip"
}
# to Create function
resource "aws_lambda_function" "terraform_singUp" {
  function_name = "signUp"
  filename      = "signUp.zip"
  runtime = "nodejs20.x"
  handler = "index.handler"
  source_code_hash = data.archive_file.lambda_terraform_signUp.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn

  environment {
      variables = {
        "clienteID" = var.AWS_COGNITO_CLIENT_ID,
        "apiUrl" = var.API_URL
      }
  }
}

resource "aws_lambda_function" "terraform_singIn" {
  function_name = "signIn"
  filename      = "signIn.zip"
  runtime = "nodejs20.x"
  handler = "index.handler"
  source_code_hash = data.archive_file.lambda_terraform_signIn.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
  environment {
      variables = {
        "clienteID" = var.AWS_COGNITO_CLIENT_ID,
        "apiUrl" = var.API_URL
      }
  }
}

resource "aws_lambda_function" "terraform_confirm_signUp" {
  function_name = "confirmSignUp"
  filename      = "confirmSignUp.zip"
  runtime = "nodejs20.x"
  handler = "index.handler"
  source_code_hash = data.archive_file.lambda_terraform_confirm_signUp.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn

  environment {
      variables = {
        "clienteID" = var.AWS_COGNITO_CLIENT_ID,
        "apiUrl" = var.API_URL
      }
  }
}

resource "aws_lambda_function" "terraform_getUsers" {
  function_name = "getUsers"
  filename      = "getUsers.zip"
  runtime = "nodejs20.x"
  handler = "index.handler"
  source_code_hash = data.archive_file.lambda_terraform_getUsers.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn

  environment {
      variables = {
        "clienteID" = var.AWS_COGNITO_CLIENT_ID,
        "apiUrl" = var.API_URL
      }
  }
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda_role"
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

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
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

resource "aws_api_gateway_deployment" "prod_deployment" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  stage_name  = "prod"

}
resource "aws_api_gateway_stage" "prod_stage" {
  rest_api_id = aws_api_gateway_rest_api.restaurante34-api.id
  stage_name  = "prod"
  deployment_id = aws_api_gateway_deployment.prod_deployment.id
}