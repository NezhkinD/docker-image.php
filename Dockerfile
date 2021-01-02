FROM php:7.4.13-fpm-alpine3.12

# Install dependencies
RUN apk update && apk add --no-cache curl \
    zip \
    unzip \
    git \
    libpq \
    redis \
    composer \
    bash \
    nano \
    libpng \
    jpegoptim \
    gifsicle \
    pngquant \
    optipng \
    php7-pecl-redis

# Install PDO driver mysql
RUN docker-php-ext-install mysqli

# Install PDO driver psql
RUN set -ex \
  && apk --no-cache add \
    postgresql-dev

RUN docker-php-ext-install pdo pdo_pgsql

# Install sockets
RUN docker-php-ext-install sockets

# Delete cache folder
RUN rm -rf /var/cache/apk/*

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]