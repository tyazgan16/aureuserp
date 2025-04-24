FROM php:8.2-fpm

# Sisteme gerekli araç ve kütüphaneleri kur
RUN apt-get update && apt-get install -y \
    build-essential \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    zip \
    unzip \
    curl \
    git \
    libicu-dev \
    libxml2-dev \
    vim \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd pdo pdo_mysql zip intl

# Composer'ı indir
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Projeyi container içine kopyala
COPY . .

# Laravel ortamı için cache'leri hazırla
RUN composer install --optimize-autoloader --no-dev --no-scripts
RUN php artisan config:clear
RUN php artisan config:cache
RUN php artisan route:cache
RUN php artisan view:cache

# Uygulamanın kök dizinini tanımla
WORKDIR /var/www/html

CMD ["php-fpm"]
