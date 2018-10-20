## Allspark Jenkins image

This image is destinated to be used by the [Allspark](https://github.com/actiniumio/allspark)
project. The build is configured to mirror `jenkins/jenkins` repository, so you can
use any version available on the official image.

This image contains docker, as it is intended to be used to provision developers
defined build containers. The Docker socket must be mounted in the container for
this feature to work.
Keep in mind that this is unsecure, as it gives root access to anyone with
the permissions to create a job.

### Usage

```sh
docker run \
  -it \
  -p 8080:8080 \
  --name jenkins \
  actiniumio/jenkins
```

> With docker socket mount

```sh
docker run \
  -it \
  -p 8080:8080 \
  --name jenkins \
  -u jenkins:$(getent group docker | cut -d: -f3) \
  -v /var/run/docker.sock:/var/run/docker.sock \
  actiniumio/jenkins
```

## Build

> To build one version of jenkins :

```sh
# You can use any version available at https://hub.docker.com/r/jenkins/jenkins/tags/
version=latest
docker build  -t jenkins --build-arg JENKINS_VERSION=$version .
```

> Gotta build 'em all
> You need to have [jq](https://stedolan.github.io/jq/) installed.

```sh
# Default max pages to 50
MAX_PAGES=5 ./download_tags.sh && ./build_images.sh
```