From alpine:3.9
ARG DOCKER_VERSION_OVERRIDE=18.06.0-ce
ARG DOCKER_COMPOSE_OVERRIDE=1.23.1

LABEL com.circleci.preserve-entrypoint=true

ENV DOCKER_VERSION_OVERRIDE=$DOCKER_VERSION_OVERRIDE
ENV DOCKER_COMPOSE_OVERRIDE=$DOCKER_COMPOSE_OVERRIDE

COPY bashrc /root/.bashrc

RUN apk --no-cache add --update bash curl git openssh openssl tar gzip ca-certificates gettext python py-pip php php-mbstring php-json php-openssl

# INSTALL docker client / docker-compose
RUN curl -L -o /tmp/docker-$DOCKER_VERSION_OVERRIDE.tgz https://download.docker.com/linux/static/edge/x86_64/docker-$DOCKER_VERSION_OVERRIDE.tgz; \
    tar -xz -C /tmp -f /tmp/docker-$DOCKER_VERSION_OVERRIDE.tgz; \
    mv /tmp/docker/* /usr/bin; \
    rm -rf /tmp/*

# Python packages awscli docker-compose runscope
RUN pip --no-cache-dir install --upgrade pip \
    && pip --no-cache-dir install awscli "docker-compose==$DOCKER_COMPOSE_OVERRIDE" --upgrade \
    && pip --no-cache-dir install -r https://raw.githubusercontent.com/Runscope/python-trigger-sample/master/requirements.txt \
    && wget -O /usr/bin/runscope.py https://raw.githubusercontent.com/Runscope/python-trigger-sample/master/app.py

ENTRYPOINT bash
