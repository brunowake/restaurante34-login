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


provider "aws" {
  region  = "us-east-1"
  access_key = var.AWS_ACCESS_KEY_ID
  secret_key = var.AWS_SECRET_ACCESS_KEY
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
        "clientId" = var.AWS_COGNITO_CLIENT_ID
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
        "clientId" = var.AWS_COGNITO_CLIENT_ID
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
        "clientId" = var.AWS_COGNITO_CLIENT_ID
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
