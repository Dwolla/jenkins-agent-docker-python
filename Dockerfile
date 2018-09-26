FROM dwolla/jenkins-agent-core
MAINTAINER Dwolla Dev <dev+jenkins-python@dwolla.com>
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-python"

USER root
RUN apk add --update python py-pip python-dev jq make git zip && \
    pip install --upgrade pip && \
    pip install --upgrade setuptools && \
    pip install awscli virtualenv && \
    rm -rf /var/cache/apk/*

USER jenkins
