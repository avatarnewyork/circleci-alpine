From alpine:3.11.3
ARG DOCKER_VERSION_OVERRIDE=18.06.0-ce
ARG DOCKER_COMPOSE_OVERRIDE=1.23.1

LABEL com.circleci.preserve-entrypoint=true

ENV DOCKER_VERSION_OVERRIDE=$DOCKER_VERSION_OVERRIDE \
    DOCKER_COMPOSE_OVERRIDE=$DOCKER_COMPOSE_OVERRIDE \
    ALPINE_REPO_MIRROR="http://dl-cdn.alpinelinux.org/alpine/v$ALPINE_MAJOR" \
    ALPINE_TESTING_REPO_MIRROR="http://dl-cdn.alpinelinux.org/alpine/edge" 

COPY bashrc /root/.bashrc

RUN apk --no-cache add --update bash curl git openssh openssl tar gzip ca-certificates gettext python py-pip php php-mbstring php-json php-openssl php-phar jq

# INSTALL docker client / docker-compose / phpunit
RUN curl -L -o /tmp/docker-$DOCKER_VERSION_OVERRIDE.tgz https://download.docker.com/linux/static/edge/x86_64/docker-$DOCKER_VERSION_OVERRIDE.tgz; \
	tar -xz -C /tmp -f /tmp/docker-$DOCKER_VERSION_OVERRIDE.tgz; \
	mv /tmp/docker/* /usr/bin; \
	rm -rf /tmp/*; \
	wget -O /usr/bin/phpunit.phar https://phar.phpunit.de/phpunit-9.0.phar; \
	chmod +x /usr/bin/phpunit.phar; \
        cd /usr/bin; wget https://raw.githubusercontent.com/composer/getcomposer.org/76a7060ccb93902cd7576b67264ad91c8a2700e2/web/installer -O - -q | php -- --quiet;

# leave out php7-solr, php7-stats, php7-session
RUN apk upgrade --no-cache --update-cache --available && \
    apk --no-cache add --update --repository "$ALPINE_REPO_MIRROR/main" \
    icu-libs \
    patch && \
    apk --no-cache add --update \
    --repository "$ALPINE_REPO_MIRROR/community" \
    php7 \
    php7-igbinary \
    php7-bcmath \
    php7-calendar \
    php7-cli \
    php7-ctype \
    php7-curl \
    php7-common \
    php7-dom \
    php7-exif \
    php7-fileinfo \
    php7-fpm \        
    php7-ftp \
    php7-gd \
    php7-gettext \
    php7-gmp \
    php7-iconv \
    php7-imagick \
    php7-intl \
    php7-json \
    php7-mbstring \
    php7-memcached \
    php7-mcrypt \
    php7-mysqlnd \
    php7-opcache \
    php7-openssl \
    php7-pcntl \
    php7-pdo \
    php7-pdo_mysql \
    php7-pear \
    php7-phar \
    php7-posix \
    php7-pspell \
    php7-pecl-redis \
    #php7-redis \
    #php7-session \
    php7-shmop \
    php7-simplexml \
    php7-soap \
    php7-sockets \
    #php7-solr
    php7-tokenizer \
    php7-wddx \
    php7-xml \
    php7-xmlreader \
    php7-xmlwriter \
    php7-zip \
    php7-zlib \    
    php7-oauth \
    php7-mysqli \
    php7-xdebug \
    php7-xsl \
    libssh2-dev \
    shadow && \
    apk --no-cache add --update \
    --repository "$ALPINE_TESTING_REPO_MIRROR/testing" \
    #php7-stats \
    mlocate && \
    apk --no-cache add --update --repository "$ALPINE_REPO_MIRROR/main" \
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
    cyrus-sasl-plain \
    mailx \
    ncurses 


# Python packages awscli docker-compose runscope 
RUN pip --no-cache-dir install --upgrade pip \
    && pip --no-cache-dir install awscli "docker-compose==$DOCKER_COMPOSE_OVERRIDE" --upgrade \
    && pip --no-cache-dir install -r https://raw.githubusercontent.com/Runscope/python-trigger-sample/master/requirements.txt \
    && wget -O /usr/bin/runscope.py https://raw.githubusercontent.com/Runscope/python-trigger-sample/master/app.py

ENTRYPOINT bash
