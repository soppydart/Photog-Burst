#! /bin/bash

echo "Starting docker containers..."
docker-compose -f docker-compose.production.yaml up --build -d
echo "Deployment completed!"
