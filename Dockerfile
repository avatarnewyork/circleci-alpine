From alpine:3.8
ARG DOCKER_VERSION_OVERRIDE=18.06.0-ce

LABEL com.circleci.preserve-entrypoint=true

ENV DOCKER_VERSION_OVERRIDE=$DOCKER_VERSION_OVERRIDE

RUN apk --no-cache add --update bash curl git openssh tar gzip ca-certificates python py-pip

# INSTALL docker client / docker-compose
RUN curl -L -o /usr/bin/docker-$DOCKER_VERSION_OVERRIDE.tar.gz https://download.docker.com/linux/static/edge/x86_64/docker-$DOCKER_VERSION_OVERRIDE.tgz && tar xvfz /usr/bin/docker-$DOCKER_VERSION_OVERRIDE.tar.gz; rm /usr/bin/docker-$DOCKER_VERSION_OVERRIDE.tar.gz

# Python packages awscli docker-compose
RUN pip install awscli docker-compose --upgrade;

ENTRYPOINT bash
