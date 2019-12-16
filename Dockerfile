FROM openjdk:8-jdk-alpine

ARG UID=1000
ARG GID=1000

ENV NIFI_C2_ENABLE=true
ENV MINIFI_AGENT_CLASS=dummyAgentClass
ENV NIFI_C2_REST_URL=http://localhost:10080/efm/api/c2-protocol/heartbeat
ENV NIFI_C2_REST_URL_ACK=http://localhost:10080/efm/api/c2-protocol/acknowledge
ENV MINIFI_VERSION=0.6.0.1.0.0.0-54


ENV MINIFI_BASE_DIR /opt/minifi
ENV MINIFI_SCRIPTS /opt/scripts
ENV MINIFI_HOME $MINIFI_BASE_DIR/minifi-$MINIFI_VERSION

RUN apk add --no-cache bash wget

# Setup MiNiFi user
RUN addgroup -g $GID minifi || groupmod -n minifi `getent group $GID | cut -d: -f1`
RUN adduser -S -H -G minifi minifi
RUN mkdir -p $MINIFI_BASE_DIR
RUN mkdir -p $MINIFI_SCRIPTS


ADD ./scripts $MINIFI_SCRIPTS

RUN wget https://sunileman1.s3-us-west-2.amazonaws.com/CEM/JAVA/minifi-$MINIFI_VERSION-bin.tar.gz -P $MINIFI_BASE_DIR

run tar -xzf $MINIFI_BASE_DIR/minifi-$MINIFI_VERSION-bin.tar.gz -C $MINIFI_BASE_DIR

run rm -f $MINIFI_BASE_DIR/minifi-$MINIFI_VERSION-bin.tar.gz


RUN chown -R minifi:minifi $MINIFI_BASE_DIR
RUN chown -R minifi:minifi $MINIFI_SCRIPTS

USER minifi

RUN ["chmod", "+x", "/opt/scripts/config.sh"]
RUN ["chmod", "+x", "/opt/scripts/start.sh"]

CMD ${MINIFI_SCRIPTS}/start.sh
