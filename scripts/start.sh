#!/bin/bash
set -e

AWS_REGION="ap-southeast-2"
AWS_ACCOUNT_ID="035680193308"
ECR_REPOSITORY="wetherapp"

ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

IMAGE_TAG=$(sed -n 's/.*wetherapp:\([^"]*\)".*/\1/p' imageDetail.json)

echo "Starting new Weather application"

docker run -d \
  --name weather-container \
  --restart unless-stopped \
  -p 80:8000 \
  "$ECR_URI/$ECR_REPOSITORY:$IMAGE_TAG"

echo "Application started"