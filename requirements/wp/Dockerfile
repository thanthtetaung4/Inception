FROM debian:bookworm

# Install dependencies
RUN apt-get update && apt-get install -y \
    php-fpm php-mysql php-xml php-curl php-gd php-mbstring php-zip php-soap php-intl \
    wget unzip curl mariadb-client \
    && apt-get clean

# Download and extract WordPress
RUN mkdir -p /var/www/html && \
    curl -O https://wordpress.org/latest.tar.gz && \
    tar -xzf latest.tar.gz && \
    mv wordpress/* /var/www/html/ && \
    rm -rf wordpress latest.tar.gz

# Set correct permissions
RUN chown -R www-data:www-data /var/www/html && \
    chmod -R 755 /var/www/html

# Ensure PHP-FPM uses TCP instead of socket
RUN sed -i 's|^listen = .*|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf

# RUN php --version

# Install WP-CLI
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

RUN ln -s /usr/sbin/php-fpm8.2 /usr/local/bin/php-fpm

EXPOSE 9000

COPY tools/wp-config.sh /usr/local/bin/wp-config.sh

RUN chmod +x /usr/local/bin/wp-config.sh

CMD ["/usr/local/bin/wp-config.sh"]
