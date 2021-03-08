FROM dwolla/jenkins-agent-core:alpine
MAINTAINER Dwolla Dev <dev+jenkins-python@dwolla.com>
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-python"

USER root
RUN apk add --update \
        build-base \
        freetype-dev \
        git \
        gcc \
        gfortran \
        g++ \
        jq \ 
        libffi-dev \
        make \
        musl-dev \
        openssl-dev \
        openblas-dev \
        pkgconfig \
        py-pip \
        python \
        python3 \
        python-dev \
        python3-dev \
        unixodbc-dev \
        zip \
        && \
    pip install --upgrade \
        pip \
        setuptools \
        virtualenv \
        && \
    pip3 install --upgrade \
        pip \
        scipy \
        setuptools \
        virtualenv \
        && \
    rm -rf /var/cache/apk/* && \
    chown -R jenkins /usr/lib/python2.7/site-packages

USER jenkins
