#!/bin/sh
set -e

nginx

exec php-fpm "$@"