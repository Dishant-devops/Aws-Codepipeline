#!/bin/bash
set -e

AWS_REGION="ap-southeast-2"
AWS_ACCOUNT_ID="035680193308"
ECR_REPOSITORY="wetherapp"

ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "Logging into ECR"

aws ecr get-login-password --region "$AWS_REGION" | \
docker login --username AWS --password-stdin "$ECR_URI"

echo "Reading image tag"

IMAGE_TAG=$(sed -n 's/.*wetherapp:\([^"]*\)".*/\1/p' imageDetail.json)

echo "Pulling image: $IMAGE_TAG"

docker pull "$ECR_URI/$ECR_REPOSITORY:$IMAGE_TAG"