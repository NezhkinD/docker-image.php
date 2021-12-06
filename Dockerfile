FROM php:7.4.24-fpm

WORKDIR /

###> Install dependencies ###
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    nano
###< Install dependencies ###

###> Install PHP drivers ###
RUN apt-get update && apt-get install -y libpq-dev && docker-php-ext-install pdo pdo_pgsql                ### Install PDO driver psql
RUN docker-php-ext-install mysqli pdo pdo_mysql                                                           ### Install PHP drivers
RUN apt-get install -y libcurl4-openssl-dev pkg-config libssl-dev                                         ### Install MongoDb driver
RUN pecl install mongodb && docker-php-ext-enable mongodb                                                 ### Install MongoDb driver
RUN apt-get clean && rm -rf /var/lib/apt/lists/*                                                          ### Clear cache
RUN docker-php-ext-configure gd --with-freetype --with-jpeg                                               ### Install GD-extension
RUN docker-php-ext-install sockets                                                                        ### Install sockets
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer  ### Install composer
###< Install PHP drivers ###

###> Install PHP Redis ###
ENV PHPREDIS_VERSION 5.0.0
RUN mkdir -p /usr/src/php/ext/redis \
    && curl -L https://github.com/phpredis/phpredis/archive/$PHPREDIS_VERSION.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 \
    && echo 'redis' >> /usr/src/php-available-exts \
     && docker-php-ext-install redis
###< Install PHP Redis ###

###> Скачиваем файл install-php-extensions из репозитория mlocati/docker-php-extension-installer ###
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/
###< Скачиваем файл install-php-extensions из репозитория mlocati/docker-php-extension-installer ###

###> Запускаем файл install-php-extensions и устанавливаем php-extension amqp ###
RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions amqp && \
    install-php-extensions imap && \
    install-php-extensions mailparse
###< Запускаем файл install-php-extensions и устанавливаем php-extension amqp ###

###> Install fish, symfony cli ###
RUN apt update && apt install fish -y
RUN apt-get update && apt-get install wget && \
    wget https://get.symfony.com/cli/installer -O - | bash && \
    mv /root/.symfony/bin/symfony /usr/local/bin/symfony
###< Install fish, symfony cli ###

###> Install supervisor 4 ###
RUN apt-get update && apt-get install python3-pip -y && \
    pip install supervisor && \
    > /tmp/supervisor.sock
RUN mkdir /var/log/supervisor/
RUN echo_supervisord_conf > /etc/supervisord.conf
###< Install supervisor 4 ###

EXPOSE 9000
CMD ["php-fpm"]