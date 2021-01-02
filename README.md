# Docker php

### Описание
Docker-файл для сборки контейнера php-fpm.
Образ автоматически собирается на docker hub.

### Технические сведения
Образ содержит в себе:

- PHP
- Драйверы psql и mysql
- Поддержку sockets
- Redis
- Прочие пакеты


### Тестирование образа

- Для сборки образа используется команда:

`docker build -t php_fpm_image - < Dockerfile`

- Для запуска контейнера:

`docker run -it --name php_fpm -d php_fpm_image`

- Для остановки контейнера:

`docker stop php_fpm`