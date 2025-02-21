FROM php:8.4-apache                                                                       

ENV DEBIAN_FRONTEND=noninteractive \
    TZ=Europe/Rome

RUN echo $TZ > /etc/timezone && \
    apt-get update && apt-get -y dist-upgrade && \
    apt-get install -y tzdata && \
    rm -rf /var/lib/apt/lists*

ENV MODULES="pdo_mysql"
RUN docker-php-ext-install -j$(nproc) $MODULES

# Enable rewrite,  ssl, info, remoteip modules
RUN a2enmod rewrite

CMD ["apache2-foreground"]

HEALTHCHECK --interval=60s --timeout=5s --start-period=60s --retries=10 CMD curl -sS localhost/server-status?auto | grep -E "ServerVersion|RestartTime|ServerUptime:" && echo "Gimme a page" || exit 1
