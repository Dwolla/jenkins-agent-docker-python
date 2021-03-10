FROM dwolla/jenkins-agent-core:alpine
MAINTAINER Dwolla Dev <dev+jenkins-python@dwolla.com>
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-python"

USER root
RUN apk add --update \
        python3 \
        py3-pip \
        python3-dev \
        jq \ 
        make \
        git \
        zip \
        gcc \
        g++ \
        musl-dev \
        libffi-dev \
        openssl-dev \
        unixodbc-dev \
        && \
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install --no-cache-dir -U \
        && \
    pip3 install --upgrade --no-cache-dir \
        pip \
        setuptools \
        && \
    rm -rf /var/cache/apk/*

USER jenkins
