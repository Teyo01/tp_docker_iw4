FROM php:fpm

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
WORKDIR /usr/share/nginx
COPY ./laravel /usr/share/nginx/

ARG COMPOSER_ALLOW_SUPERUSER=1

RUN composer install
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql