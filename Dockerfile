FROM php:8.2-fpm

# Sistem araçları ve PHP uzantılarını yükle
RUN apt-get update && apt-get install -y \
    git curl zip unzip libzip-dev libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install pdo pdo_mysql zip

# Composer yükle
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Proje dosyalarını kopyala
COPY . /var/www

WORKDIR /var/www

# Composer işlemlerini çalıştır
RUN composer install --no-dev --no-interaction --prefer-dist

# Laravel için bazı önbellek ayarlarını çalıştır
RUN php artisan config:clear \
 && php artisan cache:clear \
 && php artisan route:clear \
 && php artisan view:clear \
 && php artisan config:cache \
 && php artisan route:cache \
 && php artisan view:cache

# Web sunucusu başlatma komutu
CMD ["php-fpm"]
