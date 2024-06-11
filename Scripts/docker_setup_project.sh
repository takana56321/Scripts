#!/bin/bash

# 1. C:\xampp\htdocs\laravel3に移動
cd /c/xampp/htdocs/laravel3 || exit

# 2. 大元フォルダ作成(フォルダ名こちらで決める)
if [ -z "$1" ]; then
  echo "使用方法: $0 フォルダ名"
  exit 1
fi

ROOT_FOLDER=$1
mkdir "$ROOT_FOLDER"

# 3. ↑に移動
cd "$ROOT_FOLDER" || exit

# 4. docker-compose.ymlファイルの作成
touch docker-compose.yml

# 5. docker-compose.ymlのコード記入
cat <<EOL > docker-compose.yml
version: '3.8'
services:
  app:
    container_name: docker_my_project
    build: ./docker/php
    volumes:
      - .:/var/www
  db:
    image: mysql:8.0.29
    container_name: "mysql_test"
    environment:
        MYSQL_ROOT_PASSWORD: root
        MYSQL_DATABASE: mysql_test_db
        MYSQL_USER: admin
        MYSQL_PASSWORD: secret
        TZ: 'Asia/Tokyo'
    ports:
        - 3307:3306
    command: mysqld --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
    volumes:
      - db_data_test:/var/lib/mysql
      - db_my.cnf_test:/etc/mysql/conf.d/my.cnf
      - db_sql_test:/docker-entrypoint-initdb.d
  php:
    build: ./docker/php
    container_name: "php-fpm"
    volumes:
      - ./src:/var/www
  nginx:
    image: nginx:latest
    container_name: "nginx_test"
    ports:
      - 80:80
    volumes:
      - ./src:/var/www
      - ./docker/nginx/default.conf:/etc/nginx/conf.d/default.conf
    depends_on:
      - php
  phpmyadmin:
    image: phpmyadmin/phpmyadmin:latest
    container_name: "phpmyadmin_test"
    environment:
      - PMA_ARBITRARY=1
      - PMA_HOST=db
      - PMA_USER=admin
      - PMA_PASSWORD=secret
    links:
      - db
    ports:
      - 8080:80
    volumes:
      - ./phpmyadmin/sessions:/sessions
  node:
    image: node:14.18-alpine
    container_name: "node14.18-alpine"
    tty: true
    volumes:
      - ./src:/var/www
    working_dir: /var/www
volumes:
  db_data_test:
  db_my.cnf_test:
  db_sql_test:
EOL

# 6. dockerフォルダを作る
mkdir docker

# 7. ↑移動
cd docker || exit

# 8. phpフォルダ作る
mkdir php

# 9. ↑移動
cd php || exit

# 10. php.iniファイルの作成
touch php.ini

# 11. php.iniのコード記入
cat <<EOL > php.ini
[Date]
date.timezone = "Asia/Tokyo"
[mbstring]
mbstring.internal_encoding = "UTF-8"
mbstring.language = "Japanese"
[opcache]
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=60
opcache.fast_shutdown=1
opcache.enable_cli=1
EOL

# 12. Dockerfileファイルを作成
touch Dockerfile

# 13. Dockerfileにコードを記入
cat <<EOL > Dockerfile
# Dockerimage の指定
FROM php:8.0-fpm
COPY php.ini /usr/local/etc/php/

# Package & Library install
RUN apt-get update \
    && apt-get install -y zlib1g-dev mariadb-client vim libzip-dev \
    && docker-php-ext-install zip pdo_mysql

# Composer install
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN php composer-setup.php
RUN php -r "unlink('composer-setup.php');"
RUN mv composer.phar /usr/local/bin/composer

ENV COMPOSER_ALLOW_SUPERUSER 1
ENV COMPOSER_HOME /composer
ENV PATH \$PATH:/composer/vendor/bin

# WorkDir Path setting
WORKDIR /var/www

# Laravel Package install
RUN composer global require "laravel/installer"
EOL

# 14. dockerフォルダに移動
cd ..

# 15. nginxフォルダ作成
mkdir nginx

# 16. ↑に移動
cd nginx || exit

# 17. default.confファイル作成
touch default.conf

# 18. default.confのコード記入
cat <<EOL > default.conf
server {
    listen 80;
    server_name localhost;
    root /var/www/html;
    index index.php index.html index.htm;

    location / {
        try_files \$uri \$uri/ /index.php?\$query_string;
    }

    location ~ \.php$ {
        include snippets/fastcgi-php.conf;
        fastcgi_pass php:9000;
        fastcgi_param SCRIPT_FILENAME \$document_root\$fastcgi_script_name;
        include fastcgi_params;
    }
}
EOL

# 19. 大元フォルダに移動
cd ../../

# 20. docker-compose up -d入力
docker-compose up -d

# 21. 成功したらdocker-compose ps
if [ $? -eq 0 ]; then
  docker-compose ps
else
  echo "docker-compose up -d に失敗しました。"
fi