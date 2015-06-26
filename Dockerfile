FROM mkaag/phpfpm:latest
MAINTAINER Maurice Kaag <mkaag@me.com>

# -----------------------------------------------------------------------------
# Environment variables
# -----------------------------------------------------------------------------
ENV OWNCLOUD_VERSION 8.0.4

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
        php5-mysql \
        nginx-common \
        nginx-extras \
        nginx-nr-agent \
        newrelic-sysmond

WORKDIR /opt
RUN \
  curl -s -o owncloud.tar.bz2 https://download.owncloud.org/community/owncloud-${OWNCLOUD_VERSION}.tar.bz2 && \
  tar jxf owncloud.tar.bz2 && \
  rm -f owncloud.tar.bz2 && \
  chown -R www-data:www-data owncloud/

# -----------------------------------------------------------------------------
# Post-install
# -----------------------------------------------------------------------------
RUN \
  for i in /etc/php5/*/php.ini; do \
      sed -i '/always_populate_raw_post_data/s/^;//' $i; \
      sed -i '/^output_buffering/s/4096/0/' $i; \
      sed -i '/^expose_php/s/Off/On/' $i; \
      sed -i '/^post_max_size/s/8M/16G/' $i; \
      sed -i '/^upload_max_filesize/s/2M/16G/' $i; \
      sed -i '/^max_execution_time/s/[0-9][0-9]*/3600/' $i; \
      sed -i '/^max_input_time/s/[0-9][0-9]*/3600/' $i; \
  done

ADD build/phpfpm.sh /etc/my_init.d/13_phpfpm.sh
ADD build/nginx.sh /etc/my_init.d/14_nginx.sh
ADD build/nginx.conf /etc/nginx/sites-enabled/owncloud
ADD build/status.conf /etc/nginx/conf.d/status.conf
ADD build/autoconfig.php /var/www/owncloud/config/autoconfig.php

RUN \
    sed -i "s/\/var\/www/\/opt\/owncloud/" /etc/php5/fpm/php.ini && \
    rm /etc/nginx/sites-enabled/default && \
    chmod +x /etc/my_init.d/13_phpfpm.sh && \
    chmod +x /etc/my_init.d/14_nginx.sh

EXPOSE 80 443
VOLUME ["/opt/owncloud/apps", "/opt/owncloud/config", "/opt/owncloud/data"]

CMD ["/sbin/my_init"]

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
