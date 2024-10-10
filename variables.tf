variable "aws_region" {
  description = "The AWS region to deploy to"
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
  default     = "example_lambda_function"
}

variable "lambda_role_arn" {
  description = "The ARN of the IAM role for the Lambda function"
}
