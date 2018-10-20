set -euo pipefail

rm -f tags.txt

repository="jenkins/jenkins"

function download_page() {
  url=$1

  echo "[Download] $url"
  curl -s $url -o tags.raw.json
  cat tags.raw.json | jq -cMr '.results[].name' >> tags.txt
}

download_page "https://hub.docker.com/v2/repositories/$repository/tags/"
next=$(cat tags.raw.json | jq -cMr .next)
page=1

while [ "$next" != "null" ] && [ "${MAX_PAGES:-"50"}" -gt "$page" ]
do
  download_page $next
  page=$((page+1))
  next=$(cat tags.raw.json | jq -cMr .next)
done


rm -f tags.raw.json

echo "$repository tags updated :"
cat tags.txt

echo ""
echo "Summary:"
echo " - Pages fetched   : $page"
echo " - Tags discovered : $(wc -l tags.txt)"
