#From alpine:edge
FROM php:8.0.3-fpm-alpine3.13

#ARG DOCKER_VERSION_OVERRIDE=18.06.0-ce
ARG DOCKER_VERSION_OVERRIDE=19.03.8
#ARG DOCKER_COMPOSE_OVERRIDE=1.23.1
ARG DOCKER_COMPOSE_OVERRIDE=1.25.5

LABEL com.circleci.preserve-entrypoint=true

ENV DOCKER_VERSION_OVERRIDE=$DOCKER_VERSION_OVERRIDE \
    DOCKER_COMPOSE_OVERRIDE=$DOCKER_COMPOSE_OVERRIDE \
	#ALPINE_REPO_MIRROR="http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_MAJOR" \
    ALPINE_REPO_MIRROR="http://dl-cdn.alpinelinux.org/alpine/edge" \
    ALPINE_TESTING_REPO_MIRROR="http://dl-cdn.alpinelinux.org/alpine/edge" 

COPY bashrc /root/.bashrc

RUN apk --no-cache add --update bash curl git openssh openssl tar gzip ca-certificates gettext python3 php php-mbstring php-json php-openssl php-phar jq

# INSTALL docker client / docker-compose / phpunit
RUN curl -L -o /tmp/docker-$DOCKER_VERSION_OVERRIDE.tgz https://download.docker.com/linux/static/edge/x86_64/docker-$DOCKER_VERSION_OVERRIDE.tgz; \
	tar -xz -C /tmp -f /tmp/docker-$DOCKER_VERSION_OVERRIDE.tgz; \
	mv /tmp/docker/* /usr/bin; \
	rm -rf /tmp/*; \
	wget -O /usr/bin/junitfy.py https://raw.githubusercontent.com/avatarnewyork/junitfy/master/junitfy.py; \
	wget -O /usr/bin/phpunit.phar https://phar.phpunit.de/phpunit-9.5.4.phar; \
	chmod +x /usr/bin/phpunit.phar; \
	#cd /usr/bin; wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet; \
	ln -s /usr/bin/python3 /usr/bin/python;

RUN apk --no-cache add --update \
	patch \
	icu-libs \
	shadow \
	apache2 \
	apache2-proxy \
	apache2-utils \
	openssl \
	mysql-client \
	git \
	curl \
	grep \
	wget \
	which \
	tar \
	pwgen \
	bash \
	unzip \
	openrc \
	fcgi \
	postfix \
	cyrus-sasl \
#	cyrus-sasl-plain \
	mailx \
	ncurses 
	#zlib 

COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

RUN install-php-extensions bcmath calendar Core ctype curl date dom exif fileinfo filter ftp gettext gmp iconv imagick json gd redis intl imap exif bz2 mbstring imap zip soap pdo pdo_mysql pdo_pgsql pgsql Phar mcrypt mysqlnd OAuth OPcache openssl pcntl mysqli phar posix pspell session shmop SimpleXML soap sockets solr SPL standard xml xmlreader xmlwriter zip zlib ssh2 xsl @composer-2.0.10

#RUN apk upgrade --no-cache --update-cache --available && \
#    apk --no-cache add --update \
#    --repository "$ALPINE_REPO_MIRROR/community" \
#    py3-pip \
#    apk --no-cache add --update \
#    --repository "$ALPINE_TESTING_REPO_MIRROR/testing" \
#    mlocate

RUN apk --no-cache add --update py3-pip rust cargo openssl-dev && python -m pip install -U pip && \
	apk --no-cache add --update gcc libffi libffi-dev python3-dev musl-dev libsodium-dev make

RUN apk --no-cache add --update py3-wheel 

# Python packages: junit awscli
# removed run scope from PHP 7.4 releases
#RUN pip --no-cache-dir install --upgrade pip \
RUN pip --no-cache-dir install awscli junit_xml_output "docker-compose==$DOCKER_COMPOSE_OVERRIDE" --upgrade 
#    && pip --no-cache-dir install -r https://raw.githubusercontent.com/Runscope/python-trigger-sample/master/requirements.txt \
#    && wget -O /usr/bin/runscope.py https://raw.githubusercontent.com/Runscope/python-trigger-sample/master/app.py

RUN apk del gcc libffi libffi-dev python3-dev musl-dev libsodium-dev make rust cargo openssl-dev

ENTRYPOINT bash
