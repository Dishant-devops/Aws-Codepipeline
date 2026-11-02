#!/bin/bash
set -euo pipefail

# 1. Dynamically resolve the deployment root directory relative to this script
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP_ROOT="$(dirname "$SCRIPT_DIR")"
IMAGE_DETAIL_FILE="$APP_ROOT/imageDetail.json"

AWS_REGION="ap-southeast-2"
AWS_ACCOUNT_ID="035680193308"
ECR_REPOSITORY="wetherapp"
CONTAINER_NAME="weather-container"

ECR_URI="${AWS_ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com"

# 2. Verify imageDetail.json exists and extract the tag
if [[ ! -f "$IMAGE_DETAIL_FILE" ]]; then
    echo "ERROR: $IMAGE_DETAIL_FILE not found!" >&2
    exit 1
fi

echo "Reading image tag from $IMAGE_DETAIL_FILE"
IMAGE_TAG=$(sed -n 's/.*wetherapp:\([^"]*\)".*/\1/p' "$IMAGE_DETAIL_FILE")

if [[ -z "$IMAGE_TAG" ]]; then
    echo "ERROR: Failed to extract IMAGE_TAG from $IMAGE_DETAIL_FILE" >&2
    exit 1
fi

# 3. Stop and remove existing container if it is already running (idempotency)
if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    echo "Stopping and removing existing container: $CONTAINER_NAME"
    docker rm -f "$CONTAINER_NAME"
fi

# 4. Start the new container
echo "Starting new Weather application ($ECR_URI/$ECR_REPOSITORY:$IMAGE_TAG)"
docker run -d \
  --name "$CONTAINER_NAME" \
  --restart unless-stopped \
  -p 80:8000 \
  "$ECR_URI/$ECR_REPOSITORY:$IMAGE_TAG"

echo "Application started successfully"