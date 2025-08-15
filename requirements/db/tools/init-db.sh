#!/bin/bash
# Exit on errors
set -e

# Source environment variables
DB_ROOT_PASSWORD=${DB_ROOT_PASSWORD:-root}
DB_NAME=${DB_NAME:-wordpress}
DB_USER=${DB_USER:-wp_user}
DB_PASSWORD=${DB_PASSWORD:-wp_password}

echo "Starting MariaDB for initialization..."
mysqld_safe --user=mysql &

# Wait for server to start
sleep 5

echo "Creating database and user..."
mysql -u root <<MYSQL_SCRIPT
ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASSWORD}';
GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${DB_USER}'@'%';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Stop temporary MariaDB instance
mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown

echo "Database ${DB_NAME} and user ${DB_USER} created."
