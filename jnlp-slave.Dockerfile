ARG JENKINS_SLAVE_VERSION

FROM jenkins/jnlp-slave:${JENKINS_SLAVE_VERSION}

USER root
RUN apt update -y \
  && apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
  && curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - \
  && add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu bionic stable" \
  && apt update -y \
  && apt install -y \
    docker-ce \
  && apt clean

USER jenkins
