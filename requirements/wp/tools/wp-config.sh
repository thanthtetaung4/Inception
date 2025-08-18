#!/bin/bash
set -e

# Wait for DB to be ready
until mariadb -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" "$WORDPRESS_DB_NAME" -e "SELECT 1;" >/dev/null 2>&1; do
  echo "Waiting for database..."
  sleep 2
done

cd /var/www/html

# Generate wp-config.php if not exists
if [ ! -f wp-config.php ]; then
  wp config create \
    --dbname="$WORDPRESS_DB_NAME" \
    --dbuser="$WORDPRESS_DB_USER" \
    --dbpass="$WORDPRESS_DB_PASSWORD" \
    --dbhost="$WORDPRESS_DB_HOST" \
    --path=/var/www/html \
    --allow-root
fi

# Install WordPress if not installed
if ! wp core is-installed --allow-root; then
  wp core install \
    --url="https://taung.42.fr" \
    --title="My WordPress Site" \
    --admin_user="admin" \
    --admin_password="adminpass" \
    --admin_email="admin@localhost" \
    --skip-email \
    --allow-root
fi

# Set correct permissions
chown -R www-data:www-data /var/www/html

# Start PHP-FPM
exec php-fpm -F
