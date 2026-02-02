#!/bin/bash
set -e
export IMAGE=$1
cd /home/ec2-user
docker compose -f docker-compose.yaml up -d
echo "success"
