ARG JENKINS_VERSION

FROM jenkins/jenkins:${JENKINS_VERSION}

COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt

USER jenkins
