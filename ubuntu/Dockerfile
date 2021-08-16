FROM dwolla/jenkins-agent-core:ubuntu
LABEL maintainer="Dwolla Dev <dev+jenkins-agent-core@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-python"

USER root

RUN set -ex && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install git -y && \
    apt-get install -y \
        python3 \
        python3-pip \
        python3-venv \
        unixodbc-dev
RUN ln -s /usr/bin/python3 /usr/bin/python

USER jenkins
