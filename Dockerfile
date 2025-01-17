FROM ccr.ccs.tencentyun.com/webankpartners/alpine-base:v1.0

ENV BASE_HOME=/app/cmdb

RUN mkdir -p $BASE_HOME $BASE_HOME/conf $BASE_HOME/logs $BASE_HOME/public/wecmdb/fonts $BASE_HOME/conf/i18n

ADD build/start.sh $BASE_HOME/
ADD build/stop.sh $BASE_HOME/
ADD build/default.json $BASE_HOME/conf/
ADD cmdb-server/conf/i18n $BASE_HOME/conf/i18n/
ADD cmdb-server/conf/menu-api-map.json $BASE_HOME/conf/
ADD cmdb-server/cmdb-server $BASE_HOME/
ADD cmdb-ui/dist $BASE_HOME/public

WORKDIR $BASE_HOME
RUN addgroup -S apps -g 6000 && adduser -S app -u 6001 -G apps
RUN chown -R app:apps $BASE_HOME && chmod -R 755 $BASE_HOME
USER app
ENTRYPOINT ["/bin/sh", "start.sh"]