FROM php:7.3.7-fpm-alpine3.10

RUN apk --update add \
    openssl \
    ca-certificates \
    git \
    wget \
    nodejs \
    nodejs-npm

WORKDIR /tmp

VOLUME /var/log/php
VOLUME /var/www/html
COPY ./www.conf /etc/php7/php-fpm.d/

RUN wget https://getcomposer.org/installer && php installer && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN npm install -g webpack gulp-cli grunt-cli

EXPOSE 9000
RUN mkdir /run/php && mkdir -p /var/www/html && mkdir -p /var/log/php/ && rm -rf /tmp/*

RUN composer global require "fxp/composer-asset-plugin:^1.3.1"

WORKDIR /var/www/html
CMD ["php-fpm","--allow-to-run-as-root"]