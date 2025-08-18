# requirements/db/Dockerfile
FROM debian:bookworm

# Install MariaDB server and utils
RUN apt-get update && apt-get install -y \
    mariadb-server mariadb-client \
    && apt-get clean

# Create data directory (ensure persistence)
RUN mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql

# Copy initialization script
COPY tools/init-db.sh /docker-entrypoint-initdb.d/init-db.sh
RUN chmod +x /docker-entrypoint-initdb.d/init-db.sh

RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# Expose default MariaDB port
EXPOSE 3306

# Switch to mysql user and run MariaDB server in foreground
CMD ["mysqld", "--user=mysql", "--console"]
