FROM php:8.2-fpm

# Sistem paketlerini yükle
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip \
    git \
    curl \
    libzip-dev \
    libicu-dev \
    libxslt-dev \
    libjpeg62-turbo-dev \
    libmcrypt-dev \
    libmagickwand-dev --no-install-recommends

# PHP uzantılarını kur
RUN docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath intl gd

# Composer yükle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Uygulama dosyalarını kopyala
COPY . /var/www
WORKDIR /var/www

# Composer işlemlerini çalıştır
RUN composer install --no-interaction --prefer-dist

# Laravel önbellek işlemleri
RUN php artisan config:clear \
 && php artisan cache:clear \
 && php artisan view:clear \
 && php artisan route:clear \
 && php artisan config:cache \
 && php artisan view:cache \
 && php artisan route:cache

CMD ["php-fpm"]
