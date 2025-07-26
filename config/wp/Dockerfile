# Dockerfile
FROM debian:bookworm

# Install dependencies
RUN apt-get update && apt-get install -y \
    php-fpm php-mysql php-xml php-curl php-gd php-mbstring php-zip php-soap php-intl \
    wget unzip curl mariadb-client \
    && apt-get clean

# Download and extract WordPress
RUN mkdir -p /var/www/html &&\
	curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress /var/www/html && \
    rm latest.tar.gz

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

RUN php --version

RUN ln -s /usr/sbin/php-fpm8.2 /usr/local/bin/php-fpm

# Expose PHP-FPM port (default 9000)
EXPOSE 9000

# Run PHP-FPM in the foreground
CMD ["php-fpm", "-F"]
