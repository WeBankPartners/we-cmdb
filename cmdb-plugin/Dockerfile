from platten/alpine-oracle-jre8-docker
LABEL maintainer = "Webank CTB Team"
ADD target/wecube-plugins-wecmdb-1.4.2-SNAPSHOT.jar /application/wecube-plugins-wecmdb.jar
ADD scripts/start.sh /scripts/start.sh
RUN chmod +x /scripts/start.sh
CMD ["/bin/sh","-c","/scripts/start.sh $DB_HOST $DB_PORT $DB_SCHEMA $DB_USER $DB_PWD"]
