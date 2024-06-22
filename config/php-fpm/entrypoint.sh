#!/bin/sh
set -e

exec nginx
exec "$@"