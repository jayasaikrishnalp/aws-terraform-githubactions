variable "aws_region" {
  description = "AWS region for the Lambda function"
  default     = "us-east-1"
}

variable "lambda_function_name" {
  description = "Name of the Lambda function"
  default     = "example-python312-lambda-function"
}
