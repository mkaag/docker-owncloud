FROM mkaag/phpfpm:latest
MAINTAINER Maurice Kaag <mkaag@me.com>

# -----------------------------------------------------------------------------
# Environment variables
# -----------------------------------------------------------------------------
ENV OWNCLOUD_VERSION 8.0.2

# -----------------------------------------------------------------------------
# Pre-install
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# Install
# -----------------------------------------------------------------------------
WORKDIR /opt
RUN \
  curl -s -o owncloud.tar.bz2 https://download.owncloud.org/community/owncloud-$OWNCLOUD_VERSION.tar.bz2 && \
  tar jxf owncloud.tar.bz2 && \
  rm -f owncloud.tar.bz2 && \
  chown -R www-data:www-data owncloud/ && \
  rm -fr /var/www && \
  ln -s /opt/owncloud /var/www

# -----------------------------------------------------------------------------
# Post-install
# -----------------------------------------------------------------------------
ADD build/autoconfig.php /var/www/owncloud/config/autoconfig.php

EXPOSE 9000
VOLUME ["/var/www"]

CMD ["/sbin/my_init"]
CMD ["/usr/sbin/php5-fpm", "-c /etc/php5/fpm"]

# -----------------------------------------------------------------------------
# Clean up
# -----------------------------------------------------------------------------
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*