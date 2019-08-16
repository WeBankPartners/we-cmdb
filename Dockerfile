from platten/alpine-oracle-jre8-docker
LABEL maintainer = "Webank CTB Team"
ADD cmdb-core/target/cmdb-core-0.0.1-SNAPSHOT.jar   /home/cmdb-core.jar
ADD build/start.sh /start.sh
RUN chmod +x /start.sh
CMD ["/bin/sh","-c","/start.sh"]

