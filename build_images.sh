set -xeu pipefail

while read version; do
  echo "Building for Jenkins version : $version"
  docker build -q -t jenkins --build-arg JENKINS_VERSION=$version .
  docker tag jenkins $DOCKER_USER/jenkins:$version
  docker push $DOCKER_USER/jenkins:$version
done < tags.txt
tac tags.txt > tags_ordered.txt
mv tags_ordered.txt tags.txt
