#!/bin/bash

cd "$(dirname "$0")/.." || exit 1

npm run dev &
sleep 3
php artisan octane:start --server=frankenphp --caddyfile=php/Caddyfile --host=0.0.0.0 --port=8000 --watch
trap "kill 0" EXIT
