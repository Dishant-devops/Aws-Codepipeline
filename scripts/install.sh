#!/bin/bash
set -e


SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_ROOT="$(dirname "$SCRIPT_DIR")"

AWS_REGION="ap-southeast-2"
AWS_ACCOUNT_ID="035680193308"
ECR_REPOSITORY="wetherapp"
ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

echo "Logging into ECR"
aws ecr get-login-password --region "$AWS_REGION" | \
docker login --username AWS --password-stdin "$ECR_URI"

echo "Reading image tag from $APP_ROOT/imageDetail.json"
IMAGE_TAG=$(sed -n 's/.*wetherapp:\([^"]*\)".*/\1/p' "$APP_ROOT/imageDetail.json")

echo "Pulling image: $IMAGE_TAG"
docker pull "$ECR_URI/$ECR_REPOSITORY:$IMAGE_TAG"