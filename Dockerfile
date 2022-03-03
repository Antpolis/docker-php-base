FROM php:7.4.27-fpm-alpine3.14

RUN apk --update add \
    openssl \
    ca-certificates \
    git \
    wget \
    nodejs \
    npm \ 
    build-base \ 
    libstdc++ \ 
    bash   

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

RUN install-php-extensions gd xdebug mbstring @composer bz2 csv exif imagick mcrypt mysqli redis soap tidy xsl yaml zip

COPY ./www.conf /etc/php7/php-fpm.d/
COPY ./php.ini /usr/local/etc/php/

WORKDIR /var/www/html

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php-fpm"]