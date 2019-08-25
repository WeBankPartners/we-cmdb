FROM mysql:5.6
COPY database /docker-entrypoint-initdb.d
COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

EXPOSE 3306
ENTRYPOINT ["docker-entrypoint.sh"]

