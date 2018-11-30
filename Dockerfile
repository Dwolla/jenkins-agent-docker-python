FROM dwolla/jenkins-agent-core
MAINTAINER Dwolla Dev <dev+jenkins-python@dwolla.com>
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-python"

USER root
RUN apk add --update \
        python \
        python3 \
        py-pip \
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
    pip install --upgrade pip && \
    pip install --upgrade setuptools && \
    pip install awscli virtualenv && \
    rm -rf /var/cache/apk/* && \
    chown -R jenkins /usr/lib/python2.7/site-packages

USER jenkins
