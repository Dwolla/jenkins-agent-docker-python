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
    pip3 install --upgrade --no-cache-dir \
        pip \
        setuptools \
        virtualenv \
        && \
    pip3 list --outdated --format=freeze | cut -d = -f 1  | xargs -r -n1 pip install --no-cache-dir -U --ignore-installed six \
        && \
    rm -rf /var/cache/apk/*

USER jenkins