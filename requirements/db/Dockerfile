FROM debian:bookworm

# Install MariaDB server and utils
RUN apt-get update && apt-get install -y \
    mariadb-server mariadb-client \
    && apt-get clean

# Create data directory and set permissions
RUN mkdir -p /var/lib/mysql /run/mysqld && \
    chown -R mysql:mysql /var/lib/mysql /run/mysqld

# Copy entrypoint script
COPY tools/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

RUN sed -i "s/127.0.0.1/0.0.0.0/" /etc/mysql/mariadb.conf.d/50-server.cnf

# Expose default MariaDB port
EXPOSE 3306

# Use custom entrypoint
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

CMD ["mysqld", "--user=mysql", "--console"]
