set -euo pipefail

i=1
mx=$(wc -l tags.txt | cut -d' ' -f1)
while read version; do
  echo "[$i / $mx] Building for Jenkins version : $version"
  i=$((i+1))
  docker build -q -t jenkins --build-arg JENKINS_VERSION=$version .
  docker tag jenkins ${DOCKER_USER:-"actiniumio"}/jenkins:$version
  if [ $# -gt 0 ] && [ $1 == "--push" ]
  then
    docker push $DOCKER_USER/jenkins:$version
  fi
done < tags.txt
tac tags.txt > tags_ordered.txt
mv tags_ordered.txt tags.txt
