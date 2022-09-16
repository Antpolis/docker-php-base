FROM php:7.4.30-fpm-alpine3.16

ARG PHP_DEBUG="on"

RUN apk --update add \
    openssl \
    ca-certificates \
    git \
    wget \
    nodejs \
    npm \ 
    build-base \ 
    libstdc++ \ 
    bash \
    openssh

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

RUN install-php-extensions gd xdebug mbstring @composer bz2 csv exif imagick mcrypt mysqli redis soap tidy xsl yaml zip

COPY ./www.conf /etc/php7/php-fpm.d/
COPY ./php.ini /usr/local/etc/php/
COPY ./entrypoint.sh /usr/local/bin/wp-entrypoint

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
RUN chmod +x /usr/local/bin/wp-entrypoint

WORKDIR /var/www/html

ENV PHP_DEBUG=$PHP_DEBUG

RUN sed -i "s/{PHP_DEBUG}/${PHP_DEBUG}/g" /etc/php7/php-fpm.d/www.conf
RUN sed -i "s/{PHP_DEBUG}/${PHP_DEBUG}/g" /usr/local/etc/php/php.ini

RUN rm -rf /var/www/html/*

WORKDIR /var/www/html

ENTRYPOINT ["wp-entrypoint"]