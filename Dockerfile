FROM ruby:2.3.3

RUN apt-get update -qq && apt-get upgrade -y && apt-get install -y \
    vim \
    curl \
    wget \
    git \
    build-essential \
    gcc \
    g++ \
    flex \
    bison \
    gperf \
    perl \
    libsqlite3-dev \
    libfontconfig1-dev \
    libicu-dev \
    libfreetype6 \
    libssl-dev \
    libpng-dev \
    libjpeg-dev \
    libqt5webkit5-dev \
    supervisor && \
    mkdir -p /var/log/supervisor

RUN curl --output /usr/local/bin/phantomjs https://s3.amazonaws.com/circle-downloads/phantomjs-2.1.1 && \
    chmod +x /usr/local/bin/phantomjs

RUN apt-key adv --keyserver keyserver.ubuntu.com --recv 7F0CEB10
RUN echo 'deb http://downloads-distro.mongodb.org/repo/debian-sysvinit dist 10gen' | tee /etc/apt/sources.list.d/mongodb.list
RUN apt-get update
RUN mkdir -p /data/db
RUN apt-get install -y adduser mongodb-org-server mongodb-org-shell

RUN wget -O cf.tgz "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" && \
    tar xvf cf.tgz && \
    mv cf /usr/local/bin/ && \
    rm cf.tgz

RUN apt-get update && apt-get install -y parallel

COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /app
ONBUILD ADD . /app

CMD /usr/bin/supervisord && bash
