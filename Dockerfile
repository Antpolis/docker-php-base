FROM php:7.4.30-fpm-alpine3.16

ARG PHP_DEBUG="off"

RUN echo http://dl-2.alpinelinux.org/alpine/edge/community/ >> /etc/apk/repositories


RUN apk --update --no-cache add \
    openssl \
    ca-certificates \
    git \
    wget \
    nodejs \
    npm \ 
    build-base \ 
    libstdc++ \ 
    bash \
    openssh \ 
    nginx \
    shadow

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

RUN install-php-extensions gd xdebug mbstring @composer bz2 csv exif imagick mcrypt mysqli redis soap tidy xsl yaml zip excimer

COPY ./config/php-fpm/www.conf /etc/php7/php-fpm.d/
COPY ./config/php-fpm/php.ini /usr/local/etc/php/
COPY ./config/php-fpm/entrypoint.sh /usr/local/bin/wp-entrypoint

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp-entrypoint

COPY ./config/nginx/nginx.conf /etc/nginx/conf.d/default.conf

ENV PHP_DEBUG=$PHP_DEBUG

RUN sed -i "s/{PHP_DEBUG}/${PHP_DEBUG}/g" /etc/php7/php-fpm.d/www.conf
RUN sed -i "s/{PHP_DEBUG}/${PHP_DEBUG}/g" /usr/local/etc/php/php.ini

RUN rm -rf /var/www/html/*
RUN mkdir -p /var/www/html

RUN chown -Rf docker-user /var/www/html
RUN chmod -Rf 775 /var/www/html


WORKDIR /var/www/html

VOLUME [ "/var/www/html" ]

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php-fpm"]
