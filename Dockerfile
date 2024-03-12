ARG CORE_TAG

FROM dwolla/jenkins-agent-core:${CORE_TAG}
LABEL maintainer="Dwolla Dev <dev+jenkins-agent-core@dwolla.com>"
LABEL org.label-schema.vcs-url="https://github.com/Dwolla/jenkins-agent-docker-python"

USER root

RUN set -ex && \
    apt-get update -y && \
    apt-get upgrade -y && \
    apt-get install git -y && \
    apt-get install -y \
        build-essential \
        libssl-dev \
        zlib1g-dev \
        libbz2-dev \
        libreadline-dev \
        libsqlite3-dev \
        libffi-dev \
        liblzma-dev \
        default-libmysqlclient-dev

RUN chown -R jenkins ${JENKINS_HOME}

ENV PYENV_ROOT $JENKINS_HOME/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH

RUN curl https://pyenv.run | bash && \
    eval "$(pyenv init --path)" && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> "${JENKINS_HOME}/.bashrc"

RUN chown -R jenkins:jenkins "${JENKINS_HOME}/.pyenv"

USER jenkins

RUN pyenv install 3.9

RUN pyenv global 3.9
