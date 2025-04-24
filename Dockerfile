FROM php:8.2-fpm

# Sistem güncelle ve bağımlılıkları kur
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip unzip curl git \
    libzip-dev libonig-dev \
    libxml2-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libpq-dev \
    && docker-php-ext-configure zip \
    && docker-php-ext-install pdo pdo_mysql zip gd

# Composer kurulumu
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

WORKDIR /var/www

COPY . .

RUN composer install --optimize-autoloader --no-dev --no-interaction || true

RUN php artisan config:cache || true
RUN php artisan route:cache || true

# Laravel uygulaması 80 portundan yayın yapacak
EXPOSE 80

CMD ["php", "-S", "0.0.0.0:80", "-t", "public"]
