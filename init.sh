#!/bin/bash

DOCKER_HOST=$(hostname)

sed -i 's/docker_name/'"$DOCKER_HOST"'/g' /etc/nginx/sites-available/default
chown -Rf www-data:www-data /var/www/html
chown -Rf www-data:www-data /KSS

# Apache gets grumpy about PID files pre-existing
service php7.1-fpm start
exec nginx -g 'daemon off;'