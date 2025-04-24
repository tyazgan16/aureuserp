FROM php:8.2-fpm

# Sistem paketleri
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    vim

# PHP Uzantıları
RUN docker-php-ext-configure zip
RUN docker-php-ext-install pdo_mysql mbstring zip exif pcntl bcmath gd

# Composer kurulumu
COPY --from=composer:2.6 /usr/bin/composer /usr/bin/composer

# Proje dosyalarını kopyala
COPY . /var/www
WORKDIR /var/www

# Yetkilendirme
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www

# Composer kurulumları (script'leri atlıyoruz)
RUN composer install --prefer-dist --no-dev --no-interaction --ignore-platform-reqs --no-scripts

# Laravel key üretme (ilk çalıştırmada artisan ile yapılmalı)
# RUN php artisan key:generate

CMD php-fpm
