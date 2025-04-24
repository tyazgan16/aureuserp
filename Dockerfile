FROM php:8.2-fpm

# Sistem bağımlılıklarını yükle
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim unzip git curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    && docker-php-ext-install pdo pdo_mysql mbstring zip exif pcntl gd

# Composer kurulumu
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Proje dosyalarını kopyala
COPY . /var/www

WORKDIR /var/www

# Gerekli PHP izinleri ve kullanıcı yetkileri
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage

# COMPOSER_ROOT_VERSION ve COMPOSER_ALLOW_SUPERUSER
ENV COMPOSER_ALLOW_SUPERUSER=1

# Composer ile bağımlılıkları yükle
RUN composer install --prefer-dist --no-dev --no-interaction --ignore-platform-reqs

# NOT: Artisan önbellek komutları kaldırıldı çünkü sınıf hatası var
# RUN php artisan config:clear && php artisan config:cache && php artisan route:cache
