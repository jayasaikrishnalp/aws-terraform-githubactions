provider "aws" {
  region = var.aws_region
}

resource "aws_lambda_function" "example_lambda" {
  filename      = "lambda_function.zip"
  function_name = var.lambda_function_name
  role          = var.lambda_role_arn
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.12"

  source_code_hash = filebase64sha256("lambda_function.zip")
}
