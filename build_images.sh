set -euo pipefail

function build_images() {
  repository=$1
  org=$(echo $repository | cut -d/ -f1)
  image=$(echo $repository | cut -d/ -f2)
  tags_file="tags_$(echo $repository | sed 's|/|_|').txt"

  echo "========================================="
  echo "Building images for $repository"
  echo "========================================="

  i=1
  mx=$(wc -l $tags_file | cut -d' ' -f1)
  while read version; do
    echo "[$i / $mx] $repository:$version"
    i=$((i+1))
    docker build \
      -q \
      -t $image \
      -f $image.Dockerfile \
      --build-arg JENKINS_VERSION=$version \
      --build-arg JENKINS_SLAVE_VERSION=$version \
      .
    docker tag $image $image:$version
    if [ $# -gt 0 ] && [ $1 == "--push" ]
    then
      docker tag $image ${DOCKER_USER}/$image:$version
      docker push $DOCKER_USER/$image:$version
    fi
  done < $tags_file
}

build_images "jenkins/jenkins"
build_images "jenkins/jnlp-slave"
