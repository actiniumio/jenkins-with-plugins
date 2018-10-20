set -euo pipefail

function download_page() {
  url=$1

  echo "[Download] $url"
  curl -s $url -o tags.raw.json
  cat tags.raw.json | jq -cMr '.results[].name' | grep -v alpine >> tags.txt || true
}

function download_tags() {
  repository=$1
  tags_file="tags_$(echo $repository | sed 's|/|_|').txt"

  rm -rf $tags_file

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
  mv tags.txt $tags_file

  echo "========================================="
  echo "Tags for repository $repository"
  echo "========================================="
  cat $tags_file
  echo "========================================="
  echo "Summary:"
  echo " - Repository      : $repository"
  echo " - Pages fetched   : $page"
  echo " - Tags discovered : $(wc -l $tags_file | cut -d' ' -f1)"
  echo "========================================="
}

download_tags "jenkins/jenkins"
download_tags "jenkins/jnlp-slave"
