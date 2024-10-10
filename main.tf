terraform {
  backend "s3" {
    bucket = "kk-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "us-east-1"  # or your preferred region
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_lambda_function" "example_lambda" {
  filename         = "lambda_function.zip"
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.12"
  source_code_hash = filebase64sha256("lambda_function.zip")

  # Add any other attributes that match your existing Lambda function
}

resource "aws_iam_role" "lambda_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })

  # Add any other attributes that match your existing IAM role
}

resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging_policy"
  path        = "/"
  description = "IAM policy for logging from a lambda"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })

  # Add any other attributes that match your existing IAM policy
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
}
