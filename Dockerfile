ARG JENKINS_VERSION

FROM jenkins/jenkins:${JENKINS_VERSION}

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

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER jenkins
