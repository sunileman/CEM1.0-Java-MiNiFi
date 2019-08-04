FROM openjdk:8-jdk-alpine



ARG UID=1000
ARG GID=1000
ARG MINIFI_AGENT_CLASS=dummyAgentClass
ARG NIFI_C2_REST_URL=http://localhost:10080/efm/api/c2-protocol/heartbeat
ARG NIFI_C2_REST_URL_ACK=http://localhost:10080/efm/api/c2-protocol/acknowledge
ARG MINIFI_VERSION=0.6.0.1.0.0.0-54


ENV MINIFI_BASE_DIR /opt/minifi
ENV MINIFI_SCRIPTS /opt/scripts
ENV MINIFI_HOME $MINIFI_BASE_DIR/minifi-$MINIFI_VERSION


# Setup MiNiFi user
RUN addgroup -g $GID minifi || groupmod -n minifi `getent group $GID | cut -d: -f1`
RUN adduser -S -H -G minifi minifi
RUN mkdir -p $MINIFI_BASE_DIR
RUN mkdir -p $MINIFI_SCRIPTS


ADD ./scripts $MINIFI_SCRIPTS


ADD ./target/minifi-*-bin.tar.gz $MINIFI_BASE_DIR

RUN ls $MINIFI_BASE_DIR

RUN chown -R minifi:minifi $MINIFI_BASE_DIR
RUN chown -R minifi:minifi $MINIFI_SCRIPTS

USER minifi


# Default to binding to any interface
RUN sed -i -e "s|^#nifi.c2.enable=.*$|nifi.c2.enable=true|" $MINIFI_HOME'/conf/bootstrap.conf'
RUN sed -i -e "s|^#nifi.c2.agent.class=.*$|nifi.c2.agent.class=$MINIFI_AGENT_CLASS|" $MINIFI_HOME'/conf/bootstrap.conf'
RUN sed -i -e "s|^#nifi.c2.rest.url=.*$|nifi.c2.rest.url=$NIFI_C2_REST_URL|" $MINIFI_HOME'/conf/bootstrap.conf'
RUN sed -i -e "s|^#nifi.c2.rest.url.ack=.*$|nifi.c2.rest.url.ack=$NIFI_C2_REST_URL_ACK|" $MINIFI_HOME'/conf/bootstrap.conf'
RUN sed -i -e "s|^#nifi.c2.agent.heartbeat.period=.*$|nifi.c2.agent.heartbeat.period=1000|" $MINIFI_HOME'/conf/bootstrap.conf'




RUN ["chmod", "+x", "/opt/scripts/config.sh"]
RUN ["chmod", "+x", "/opt/scripts/start.sh"]

CMD ${MINIFI_SCRIPTS}/config.sh
CMD ${MINIFI_SCRIPTS}/start.sh