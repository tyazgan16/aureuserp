FROM php:8.2-fpm

# Sistem bağımlılıklarını yükle
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    git \
    libonig-dev \
    libxml2-dev \
    libmcrypt-dev \
    libicu-dev \
    libpq-dev \
    libxslt1-dev \
    libmagickwand-dev --no-install-recommends

# PHP uzantılarını yükle
RUN docker-php-ext-install pdo pdo_mysql zip gd exif pcntl bcmath opcache intl

# Composer'ı indir
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Çalışma dizinini ayarla
WORKDIR /var/www

# Projeyi kopyala
COPY . .

# Laravel için composer kurulumunu yap
RUN composer install --prefer-dist --no-dev --no-interaction --ignore-platform-reqs

# Laravel önbellek işlemleri
RUN php artisan config:clear && php artisan config:cache && php artisan route:cache

# Haklar
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage /var/www/bootstrap/cache

EXPOSE 9000
CMD ["php-fpm"]
