ARG DOCKER_VERSION_OVERRIDE=18.06.0-ce
ARG DOCKER_COMPOSE_VERSION_OVERRIDE=1.23.1
From alpine:3.8

LABEL com.circleci.preserve-entrypoint=true

RUN apk update
RUN apk add --no-cache bash curl git openssh tar gzip ca-certificates python

# INSTALL docker client / docker-compose
RUN curl -L -o /tmp/docker-$DOCKER_VERSION_OVERRIDE.tgz https://download.docker.com/linux/static/edge/x86_64/docker-$DOCKER_VERSION_OVERRIDE.tgz; \
    tar -xz -C /tmp -f /tmp/docker-$DOCKER_VERSION_OVERRIDE.tgz; \
    mv /tmp/docker/* /usr/bin; \
    curl -L https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION_OVERRIDE/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose; \
    chmod +x /usr/local/bin/docker-compose;

# INSTALL awscli
RUN  curl https://bootstrap.pypa.io/get-pip.py -o get-pip.py; \
    python get-pip.py; \
    pip install awscli --upgrade;

ENTRYPOINT bash
