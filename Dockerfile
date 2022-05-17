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
    bash \
    openssh

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/
RUN chmod +x /usr/local/bin/install-php-extensions

RUN install-php-extensions gd xdebug mbstring @composer bz2 csv exif imagick mcrypt mysqli redis soap tidy xsl yaml zip

RUN mkdir -p ~/.ssh

COPY ./auth ~/.ssh/authorized_keys
COPY ./www.conf /etc/php7/php-fpm.d/
COPY ./php.ini /usr/local/etc/php/

RUN chmod 600 ~/.ssh/authorized_keys

WORKDIR /var/www/html

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php-fpm"]