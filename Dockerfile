FROM ubuntu:14.10

EXPOSE 80

RUN apt-get update \
    && apt-get install -y \
      nano \
      wget \
      curl \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*


RUN apt-get update && \
    apt-get install -y \
      libapache2-mod-php5 \
      php5-gd \
      php5-mcrypt \
      php5-mysql \
      php5-intl \
      php5-curl \
      php5-json \
      php5-xdebug \
      php5-xhprof \
      php5-memcache \
      php5-mongo \
      curl \
      git \
      drush && \
    (curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin)

ADD 000-default.conf /etc/apache2/sites-available/000-default.conf
ADD envvars /etc/apache2/envvars
ADD php-tweaks.ini /etc/php5/mods-available/php-tweaks.ini
ADD xdebug.ini /etc/php5/mods-available/xdebug.ini

RUN a2ensite 000-default && \
    a2enmod php5 && \
    a2enmod rewrite && \
    php5enmod php-tweaks && \
    php5enmod xdebug && \
    useradd -d /home/user -G users,www-data -m -o -s /bin/bash -u 1000 user

CMD /usr/sbin/apache2ctl -f /etc/apache2/apache2.conf -DFOREGROUND

