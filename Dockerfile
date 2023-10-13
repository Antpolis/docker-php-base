FROM php:8.1.24-fpm-alpine3.18

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

RUN mkdir -p /var/www/html

WORKDIR /var/www/html

RUN addgroup -g 2000 docker-user
RUN adduser -D -u 2000 -G docker-user docker-user

RUN chown -Rf docker-user /var/www/html
RUN chmod -Rf 775 /var/www/html

ENTRYPOINT ["docker-php-entrypoint"]
CMD ["php-fpm"]
