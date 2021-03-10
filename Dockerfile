FROM dwolla/jenkins-agent-core:alpine
MAINTAINER Dwolla Dev <dev+jenkins-python@dwolla.com>
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-python"

USER root
RUN apk add --update \
        python \
        python3 \
        py-pip \
        py3-pip \
        python-dev \
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
    pip list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip install --no-cache-dir -U \
        && \
    pip install --upgrade \
        pip \
        setuptools \
        virtualenv && \
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 pip3 install --no-cache-dir -U \
        && \
    pip3 install --upgrade --no-cache-dir \
        pip \
        setuptools \
        && \
    rm -rf /var/cache/apk/* && \
    chown -R jenkins /usr/lib/python2.7/site-packages

USER jenkins
