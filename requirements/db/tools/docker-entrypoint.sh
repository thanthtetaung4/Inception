#!/bin/bash
set -e

# Environment variables
export DB_ROOT_PASSWORD=$(cat $DB_ROOT_PASSWORD)
export WORDPRESS_DB_PASSWORD=$(cat $WORDPRESS_DB_PASSWORD)
DB_NAME=${DB_NAME:-wordpress}


# Initialize database if empty
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    echo "Starting temporary MariaDB..."
    mysqld_safe --user=mysql &
    MYSQL_PID=$!

    # Wait for DB to be ready
    for i in {30..0}; do
        if mysql -u root -e 'SELECT 1' &> /dev/null; then
            break
        fi
        echo 'MariaDB init process in progress...'
        sleep 1
    done

    echo "Creating database and user..."
    # apply new policies and create db
    if ! mysql -u root <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${DB_ROOT_PASSWORD}';
        CREATE DATABASE IF NOT EXISTS \`${DB_NAME}\` CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
        CREATE USER IF NOT EXISTS '${WORDPRESS_DB_USER}'@'%' IDENTIFIED BY '${WORDPRESS_DB_PASSWORD}';
        GRANT ALL PRIVILEGES ON \`${DB_NAME}\`.* TO '${WORDPRESS_DB_USER}'@'%';
        FLUSH PRIVILEGES;
EOSQL
    then
        echo "❌ Database setup failed!"
        exit 1
    else
        echo "✅ Database setup succeeded!"
    fi

    echo "Initialization complete."
    # Stop the temporary DB
    mysqladmin -u root -p"${DB_ROOT_PASSWORD}" shutdown
fi

echo "Starting MariaDB in foreground..."
exec mysqld --user=mysql --console
