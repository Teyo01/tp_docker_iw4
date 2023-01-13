FROM php:8.0.2-fpm AS builder

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer
WORKDIR /usr/share/nginx
COPY ./laravel /usr/share/nginx

ARG COMPOSER_ALLOW_SUPERUSER=1

RUN apt update
RUN apt install -y git

RUN apt-get install -y \
    libzip-dev \
    zip \
    && docker-php-ext-install zip

RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql mysqli pdo

RUN composer update
RUN composer install

RUN chmod -R 777 .

COPY .env .
RUN php artisan key:generate

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash - &&\
    apt-get install -y nodejs

RUN npm install
RUN npm run build


FROM nginx AS server
COPY nginx.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/share/nginx /usr/share/nginx

FROM nginx AS server2
COPY nginx2.conf /etc/nginx/nginx.conf
COPY --from=builder /usr/share/nginx /usr/share/nginx