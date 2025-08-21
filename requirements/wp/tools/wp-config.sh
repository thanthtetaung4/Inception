#!/bin/bash
set -e

echo "Starting WordPress initialization..."

# Wait for DB to be ready with more robust checking
echo "Waiting for database connection..."
DB_READY=false
for i in {1..60}; do
    if mariadb -h"$WORDPRESS_DB_HOST" -u"$WORDPRESS_DB_USER" -p"$WORDPRESS_DB_PASSWORD" "$WORDPRESS_DB_NAME" -e "SELECT 1;" >/dev/null 2>&1; then
        echo "Database connection established!"
        DB_READY=true
        break
    fi
    echo "Attempt $i/60: Database not ready, waiting..."
    sleep 2
done


if [ "$DB_READY" = false ]; then
    echo "ERROR: Could not connect to database after 120 seconds"
    echo "Connection details:"
    echo "  Host: $WORDPRESS_DB_HOST"
    echo "  User: $WORDPRESS_DB_USER"
    echo "  Database: $WORDPRESS_DB_NAME"
    exit 1
fi

cd /var/www/html

# Generate wp-config.php if not exists
if [ ! -f wp-config.php ]; then
    echo "Creating wp-config.php..."
    wp config create \
        --dbname="$WORDPRESS_DB_NAME" \
        --dbuser="$WORDPRESS_DB_USER" \
        --dbpass="$WORDPRESS_DB_PASSWORD" \
        --dbhost="$WORDPRESS_DB_HOST" \
        --path=/var/www/html \
        --allow-root \
        --force

    if [ $? -eq 0 ]; then
        echo "wp-config.php created successfully"
    else
        echo "ERROR: Failed to create wp-config.php"
        exit 1
    fi
fi

# Install WordPress if not installed
echo "Checking if WordPress is installed..."
if ! wp core is-installed --allow-root 2>/dev/null; then
    echo "Installing WordPress..."
    wp core install \
        --url="https://taung.42.fr" \
        --title="My WordPress Site" \
        --admin_user="admin" \
        --admin_password="adminpass" \
        --admin_email="admin@gmail.com" \
        --skip-email \
        --allow-root

    if [ $? -eq 0 ]; then
        echo "WordPress installed successfully"
    else
        echo "ERROR: WordPress installation failed"
        exit 1
    fi
else
    echo "WordPress is already installed"
fi

# Set correct permissions
echo "Setting file permissions..."
chown -R www-data:www-data /var/www/html
chmod -R 755 /var/www/html

echo "WordPress initialization completed successfully!"

# Start PHP-FPM
echo "Starting PHP-FPM..."
exec php-fpm -F
