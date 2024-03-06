terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = ">= 4.10"
    archive = {
      source  = "hashicorp/archive"
      version = "~> 2.2.0"
    }
  }

}
provider "aws" {
  region  = "us-east-1"
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
}

resource "aws_lambda_function" "terraform_singIn" {
  function_name = "signUp"
  filename      = "signUp.zip"
  runtime = "nodejs20.x"
  handler = "index.handler"
  source_code_hash = data.archive_file.lambda_terraform_signIn.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
}

resource "aws_lambda_function" "terraform_confirm_signUp" {
  function_name = "signUp"
  filename      = "signUp.zip"
  runtime = "nodejs20.x"
  handler = "index.handler"
  source_code_hash = data.archive_file.lambda_terraform_confirm_signUp.output_base64sha256
  role             = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_test_lambda"
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