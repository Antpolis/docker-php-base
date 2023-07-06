FROM php:7.4.29-fpm-alpine3.16

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
    shadow

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

RUN install-php-extensions gd xdebug mbstring @composer bz2 csv exif imagick mcrypt mysqli redis soap tidy xsl yaml zip

COPY ./zz-dailyvanity.conf /usr/local/etc/php-fpm.d/
COPY ./php.ini /usr/local/etc/php/

WORKDIR /var/www/html

RUN usermod -u 1000 www-data && groupmod -g 1000 www-data

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php-fpm"]
