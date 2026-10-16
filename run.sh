#!/bin/bash

echo "Stopping and removing the old container (if it exists)"
podman stop your-app 2>/dev/null || true
podman rm your-app 2>/dev/null || true

echo "Building the main Docker image (FrankenPHP)"
podman build -t your-app-image:latest -f docker/php/Dockerfile .

echo "Running a new container"
podman run -d \
  --name your-app \
  --restart unless-stopped \
  --network host \
  --env-file .env \
  -v .:/app:Z \
  -v /app/vendor \
  -v ./storage:/app/storage:Z \
  -v ./docker/php/Caddyfile:/etc/caddy/Caddyfile:Z \
  -v ./docker/php/php.ini:/usr/local/etc/php/conf.d/99-custom.ini:Z \
  -v caddy_data_your:/data \
  -v caddy_config_your:/config \
  your-app-image:latest

echo "Finished!"
