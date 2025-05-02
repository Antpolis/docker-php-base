#!/bin/bash
set -e

# Start PHP-FPM in the background
php-fpm -D

# Start NGINX in foreground (so container stays alive)
nginx -g "daemon off;"