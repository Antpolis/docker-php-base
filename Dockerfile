FROM ubuntu:16.04
MAINTAINER Chris Sim

RUN apt-get update && apt-get -y install software-properties-common python-software-properties language-pack-en
RUN export LANG=en_SG.UTF-8 && add-apt-repository -y ppa:ondrej/php

RUN apt-get update && apt-get install -y \
    php7.1 \
    php7.1-xml \
    php7.1-xsl \
    php7.1-fpm \
    php7.1-mbstring \
    php7.1-readline \
    php7.1-zip \
    php7.1-mysql \
    php7.1-phpdbg \
    php7.1-interbase \
    php7.1-sqlite3 \
    php7.1-tidy \
    php7.1-opcache \
    php7.1-json \ 
    php7.1-xmlrpc \
    php7.1-curl \
    php7.1-ldap \
    php7.1-bz2 \
    php7.1-cgi \
    php7.1-cli \
    php7.1-dev \
    php7.1-intl \
    php7.1-gmp \
    php7.1-common \
    php7.1-pgsql \
    php7.1-bcmath \
    php7.1-snmp \
    php7.1-soap \
    php7.1-mcrypt \
    php7.1-gd \
    php7.1-enchant \
    openssl \
    ca-certificates \
    git \
    curl \
    wget \
    nodejs \
    build-essential \
    nginx

    
WORKDIR /tmp

RUN curl -sL https://deb.nodesource.com/setup_8.x | bash -
RUN apt-get update && apt-get -y install nodejs

ENV GITHUBTOKEN=1f61e607aa1f81a4c978f3573e0f7487ecc7ff8d

RUN wget https://getcomposer.org/installer && php installer && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN npm install -g bower webpack gulp-cli grunt-cli

EXPOSE 80 433
RUN rm -rf /tmp/*
COPY ./default.nginx.conf /etc/apache2/sites-available/default
COPY ./init.sh /etc/bin/docker.sh
RUN chmod +x /etc/bin/docker.sh

RUN composer config --global github-oauth.github.com $GITHUBTOKEN && composer global require "fxp/composer-asset-plugin:^1.3.1"

WORKDIR /var/www/html
VOLUME /var/www/html
VOLUME /var/log

RUN apt-get clean

CMD ['sh','/etc/bin/docker.sh']
