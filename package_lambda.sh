#!/bin/bash

# Install dependencies
pip install --target ./package -r requirements.txt
cd package
zip -r ../lambda_function.zip .
cd ..
zip -g lambda_function.zip lambda_function.py

# Check if the IAM role exists
ROLE_NAME="lambda_execution_role"
ROLE_ARN=$(aws iam get-role --role-name $ROLE_NAME --query 'Role.Arn' --output text 2>/dev/null)

if [ $? -ne 0 ]; then
  echo "Role does not exist. Creating..."
  
  # Create the IAM role
  ROLE_ARN=$(aws iam create-role \
    --role-name $ROLE_NAME \
    --assume-role-policy-document '{
      "Version": "2012-10-17",
      "Statement": [
        {
          "Effect": "Allow",
          "Principal": {
            "Service": "lambda.amazonaws.com"
          },
          "Action": "sts:AssumeRole"
        }
      ]
    }' \
    --query 'Role.Arn' \
    --output text)

  # Attach necessary policies (e.g., basic execution role)
  aws iam attach-role-policy \
    --role-name $ROLE_NAME \
    --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole

  echo "Role created with ARN: $ROLE_ARN"
else
  echo "Role already exists with ARN: $ROLE_ARN"
fi

# Export the role ARN as a Terraform variable
echo "lambda_role_arn = \"$ROLE_ARN\"" > terraform.tfvars
