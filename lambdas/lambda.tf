resource "aws_lambda_permission" "terraform_lambda_permission" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.terraform_singUp.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "${aws_api_gateway_rest_api.restaurante34-api.execution_arn}/*/*"
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
        "clienteID" = var.AWS_COGNITO_CLIENT_ID
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
        "clienteID" = var.AWS_COGNITO_CLIENT_ID
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
        "clienteID" = var.AWS_COGNITO_CLIENT_ID
      }
  }
}