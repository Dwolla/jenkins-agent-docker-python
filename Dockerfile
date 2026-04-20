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

# Install xmlsec C library dependencies. This needs the build script to be copied into
# the container and run as root. THIS IS TEMPORARY AND CAN BE REMOVED ONCE THESE
# PACKAGES ARE UPDATED IN LINUX AND/OR THE JENKINS IMAGE.
ARG TARGETPLATFORM
COPY scripts/build_xmlsec_3_7.sh /tmp/build_xmlsec.sh
# These only run for Linux architectures.
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] || [ "$TARGETPLATFORM" = "linux/arm64" ]; then \
    chmod +x /tmp/build_xmlsec.sh && /tmp/build_xmlsec.sh; \
    fi

RUN chown -R jenkins ${JENKINS_HOME}

ENV PYENV_ROOT $JENKINS_HOME/.pyenv
ENV PATH $PYENV_ROOT/bin:$PATH

RUN curl https://pyenv.run | bash && \
    eval "$(pyenv init --path)" && \
    echo 'eval "$(pyenv virtualenv-init -)"' >> "${JENKINS_HOME}/.bashrc"

RUN chown -R jenkins:jenkins "${JENKINS_HOME}/.pyenv"

USER jenkins

RUN pyenv install 3.11

RUN pyenv global 3.11

# Prepend shims so `python3` / `pip` use pyenv (not Debian /usr/bin/python3).
ENV PATH $PYENV_ROOT/shims:$PYENV_ROOT/bin:$PATH
