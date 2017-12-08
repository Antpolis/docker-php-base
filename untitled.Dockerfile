FROM ubuntu:16.04
MAINTAINER Chris Sim <chris.sim@dailyvanity.sg>

RUN apt-get -y update && apt-get install -y python-software-properties software-properties-common

RUN apt-get install -y \
  build-essential \
  imagemagick \
  libpcre3 \
  php7.0 \
  php7.0-cli \
  php7.0-dev \
  php7.0-bcmath \
  php7.0-bz2 \
  php7.0-mysql \
  php7.0-mbstring \
  php7.0-mcrypt \
  php7.0-gd \
  php-imagick \
  php7.0-curl \
  php7.0-intl \
  php7.0-common \
  php7.0-json \
  php7.0-opcache \
  php7.0-recode \
  php7.0-soap \
  php7.0-xml \
  php7.0-zip \
  php7.0-opcache \
  php-apcu \
  php-gettext \
  git \
  rsyslog \
  curl  \
  wget \
  nano \
  vim

WORKDIR /tmp

RUN wget https://deb.nodesource.com/setup_6.x
RUN chmod +x setup_6.x
RUN ./setup_6.x
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get -y update && apt-get -y install nodejs yarn && apt-get -y upgrade

RUN curl https://getcomposer.org/installer | php -- && mv composer.phar /usr/local/bin/composer && chmod +x /usr/local/bin/composer
RUN npm install -g bower webpack gulp-cli grunt-cli

RUN apt-get  -y autoclean && apt-get  -y autoremove && apt-get -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

EXPOSE 9000

RUN mkdir /run/php

RUN sed -i 's/\;daemonize = yes/daemonize = no/' /etc/php/7.0/fpm/php-fpm.conf
COPY www.conf /etc/php/7.0/fpm/pool.d/www.conf


WORKDIR /var/www/html
VOLUME /var/www/html

CMD /usr/sbin/php-fpm7.0