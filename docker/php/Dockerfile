# Pull composer binary via a dedicated stage
FROM docker.io/composer:latest AS composer-stage

# Final FrankenPHP image
FROM docker.io/dunglas/frankenphp:php8.4-alpine

RUN install-php-extensions \
    pdo_mysql \
    mbstring \
    exif \
    pcntl \
    bcmath \
    gd \
    zip \
    intl \
    opcache \
    redis

# Copy composer from the dedicated stage
COPY --from=composer-stage /usr/bin/composer /usr/bin/composer

WORKDIR /app

COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts --no-autoloader

COPY . .

RUN composer dump-autoload --optimize --no-dev

RUN chown -R www-data:www-data /app \
    && chmod -R 775 storage bootstrap/cache

COPY docker/php/Caddyfile /etc/caddy/Caddyfile
COPY docker/php/php.ini /usr/local/etc/php/conf.d/99-custom.ini

EXPOSE 80 443 443/udp

CMD ["frankenphp", "run", "--config", "/etc/caddy/Caddyfile"]
