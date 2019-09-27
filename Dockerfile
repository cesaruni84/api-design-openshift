FROM centos:7
ENV RELEASE_PATH target/api-locations-swarm.jar
RUN yum install -y \
    java-1.8.0-openjdk-headless \
  && yum clean all

WORKDIR /opt/api-locations

ADD ${RELEASE_PATH} /opt/api-locations

RUN groupadd -r duser -g 1001 \
    && useradd -u 1001 -r -g duser -d /opt/api-locations/ -s /sbin/nologin -c "Docker image user" duser \
    && chown -R duser:duser /opt/api-locations/ \
    && chgrp -R 0 /opt/api-locations && chmod -R g=u /opt/api-locations

USER 1001


EXPOSE 8080

ENV PORT_OFFSET=0
ENV LOGGING_LEVEL=INFO

CMD java -jar /opt/api-locations/api-locations-swarm.jar \
    -Dswarm.port.offset=${PORT_OFFSET} \
    -Dswarm.logging=${LOGGING_LEVEL}
