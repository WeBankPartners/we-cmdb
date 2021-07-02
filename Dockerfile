FROM alpine

ENV BASE_HOME=/app/cmdb

RUN mkdir -p $BASE_HOME $BASE_HOME/conf $BASE_HOME/logs $BASE_HOME/public/wecmdb/fonts

ADD build/start.sh $BASE_HOME/
ADD build/stop.sh $BASE_HOME/
ADD build/default.json $BASE_HOME/conf/
ADD build/menu-api-map.json $BASE_HOME/conf/
ADD cmdb-server/cmdb-server $BASE_HOME/
ADD cmdb-ui/dist $BASE_HOME/public

WORKDIR $BASE_HOME
ENTRYPOINT ["/bin/sh", "start.sh"]