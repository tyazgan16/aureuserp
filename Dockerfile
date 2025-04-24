FROM php:8.2-fpm

# Sistemi güncelle ve gerekli paketleri kur
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    locales \
    zip \
    jpegoptim optipng pngquant gifsicle \
    vim \
    unzip \
    git \
    curl \
    libonig-dev \
    libxml2-dev \
    libzip-dev

# PHP yapılandırmaları
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip

# Composer kurulum
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Proje dosyalarını konteynıra kopyala
COPY . /var/www

# Çalışma dizini
WORKDIR /var/www

# Composer ile bağımlılıkları yükle (artisan cache komutları kaldırıldı)
RUN composer install --optimize-autoloader --no-dev --no-scripts

# Autoload dosyalarını yeniden oluştur
RUN composer dump-autoload

# Laravel izin düzeltmesi (opsiyonel, kullanmak istersen açabilirsin)
# RUN chown -R www-data:www-data /var/www

# Laravel environment dosyasını kopyala (varsa)
# COPY .env.example .env

# Giriş noktası
CMD ["php-fpm"]
