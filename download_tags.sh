set -xeu pipefail

rm -f tags.txt

repository="jenkins/jenkins"

function download_page() {
  url=$1

  curl -s $url -o tags.raw.json
  cat tags.raw.json | jq -cMr '.results[].name' >> tags.txt
}

download_page "https://hub.docker.com/v2/repositories/$repository/tags/"
next=$(cat tags.raw.json | jq -cMr .next)

while [ "$next" != "null" ]
do
  download_page $next
  next=$(cat tags.raw.json | jq -cMr .next)
done


rm -f tags.raw.json

echo "$repository tags updated :"
cat tags.txt
