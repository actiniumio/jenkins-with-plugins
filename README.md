## Allspark Jenkins image

[![CircleCI](https://circleci.com/gh/actiniumio/jenkins-with-plugins/tree/master.svg?style=svg)](https://circleci.com/gh/actiniumio/jenkins-with-plugins/tree/master)

This image is destinated to be used by the [Allspark](https://github.com/actiniumio/allspark)
project. The build is configured to mirror `jenkins/jenkins` and `jenkins/jnlp-slave` debian images, so you can use any version available on the official images (as long as it is not an `alpine` version).

This `jnlp-slave` image contains docker, as it is intended to be used to provision developers
defined build containers. The Docker socket must be mounted in the container for
this feature to work.
Keep in mind that this is unsecure, as it gives root access to anyone with
the permissions to create a job.

### Usage

```sh
# Master
docker run \
  -it \
  -p 8080:8080 \
  --name jenkins \
  actiniumio/jenkins

# Slave
docker run \
  -it \
  --name jenkins_slave \
  actiniumio/jnlp-slave
```

> With docker socket mount

```sh
# Slave
docker run \
  -it \
  -p 8080:8080 \
  --name jenkins_slave \
  -u jenkins:$(getent group docker | cut -d: -f3) \
  -v /var/run/docker.sock:/var/run/docker.sock \
  actiniumio/jnlp-slave
```

## Build

> To build one version of jenkins :

```sh
# You can use any debian version available at https://hub.docker.com/r/jenkins/jenkins/tags/
# List available tags:
./download_tags

# Build with the latest versions
version=latest

docker build  \
  -t jenkins \
  --build-arg JENKINS_VERSION=$version \
  -f jenkins.Dockerfile \
  .

docker build  \
  -t jenkins \
  --build-arg JENKINS_SLAVE_VERSION=$version \
  -f jnlp-slave.Dockerfile \
  .

```

> Gotta build 'em all
> You need to have [jq](https://stedolan.github.io/jq/) installed.

```sh
# Default max pages to 50
MAX_PAGES=5 ./download_tags.sh && ./build_images.sh
```
