#!/bin/bash

# 1. 大元フォルダ作成(フォルダ名こちらで決める)
if [ -z "$1" ]; then
  echo "使用方法: $0 フォルダ名"
  exit 1
fi

ROOT_FOLDER=$1
mkdir "$ROOT_FOLDER"

# 2. ↑に移動
cd "$ROOT_FOLDER" || exit

# 3. docker-compose.ymlファイルの作成
touch docker-compose.yml

# 4. docker-compose.ymlのコード記入
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
        - 3306:3306
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