FROM mkaag/phpfpm:latest
MAINTAINER Maurice Kaag <mkaag@me.com>

# -----------------------------------------------------------------------------
# Environment variables
# -----------------------------------------------------------------------------
ENV OWNCLOUD_VERSION 8.0.2

# -----------------------------------------------------------------------------
# Pre-install
# -----------------------------------------------------------------------------
RUN \
    sed -i 's/^# \(.*-backports\s\)/\1/g' /etc/apt/sources.list && \
    wget -O - http://nginx.org/keys/nginx_signing.key | apt-key add - && \
    wget -O - https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    echo "deb http://nginx.org/packages/ubuntu/ trusty nginx" > /etc/apt/sources.list.d/nginx.list && \
    echo "deb-src http://nginx.org/packages/ubuntu/ trusty nginx" >> /etc/apt/sources.list.d/nginx.list && \
    echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list && \
    apt-get update -qqy

# -----------------------------------------------------------------------------
# Install
# -----------------------------------------------------------------------------
RUN \
    apt-get install -qqy \
        php5-pgsql \
        nginx-common \
        nginx-extras \
        nginx-nr-agent \
        newrelic-sysmond

WORKDIR /opt
RUN \
    curl -s -o owncloud.tar.bz2 https://download.owncloud.org/community/owncloud-$OWNCLOUD_VERSION.tar.bz2 && \
    tar jxf owncloud.tar.bz2 && \
    rm -f owncloud.tar.bz2 && \
    chown -R www-data:www-data owncloud/

# -----------------------------------------------------------------------------
# Post-install
# -----------------------------------------------------------------------------
RUN \
  sed -i "s/\/var\/www/\/opt\/owncloud/" /etc/php5/fpm/php.ini && \
  rm /etc/nginx/sites-enabled/default

ADD build/nginx.conf /etc/nginx/nginx.conf
ADD build/status.conf /etc/nginx/conf.d/status.conf
ADD build/autoconfig.php /opt/owncloud/config/autoconfig.php

EXPOSE 9000
VOLUME ["/opt/owncloud/apps"]
VOLUME ["/opt/owncloud/config"]
VOLUME ["/opt/owncloud/data"]

CMD ["/sbin/my_init"]
CMD ["/usr/sbin/php5-fpm", "-c /etc/php5/fpm"]

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
