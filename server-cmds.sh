#!/bin/bash
set -e

IMAGE=$1

if [ -z "$IMAGE" ]; then
  echo "ERROR: Image name not provided"
  exit 1
fi

echo "Deploying image: $IMAGE"

export IMAGE=$IMAGE

APP_DIR="$HOME/app"
cd "$APP_DIR"

echo "Stopping existing containers..."
docker compose down || true

echo "Pulling latest image..."
docker compose pull

echo "Starting containers..."
docker compose up -d

echo "Running containers:"
docker ps

echo "SUCCESS"
