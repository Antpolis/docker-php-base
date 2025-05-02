FROM php:8.3.20-fpm-alpine3.21

RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories

RUN apk --update --no-cache add \
    openssl \
    ca-certificates \
    git \
    wget \
    nginx \
    build-base \ 
    libstdc++ \ 
    bash \
    shadow

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

RUN install-php-extensions gd xdebug mbstring @composer bz2 csv exif imagick mcrypt mysqli redis soap tidy xsl yaml zip excimer

COPY ./zz-dailyvanity.conf /usr/local/etc/php-fpm.d/
COPY ./php.ini /usr/local/etc/php/

RUN rm -f /etc/nginx/sites-enabled/default
# Configure NGINX
COPY nginx-default.conf /etc/nginx/sites-enabled/default

# Make sure logs go to stdout/stderr
RUN ln -sf /dev/stdout /var/log/nginx/access.log && \
    ln -sf /dev/stderr /var/log/nginx/error.log

RUN apk --no-cache add shadow && usermod -u 33 www-data && groupmod -g 33 www-data
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint-nginx.sh
RUN chmod +x /usr/local/bin/docker-entrypoint-nginx.sh

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

RUN chown -Rf www-data:www-data /var/www/html
RUN chmod -Rf 775 /var/www/html

EXPOSE 80

ENTRYPOINT ["/usr/local/bin/docker-entrypoint-nginx.sh"]
