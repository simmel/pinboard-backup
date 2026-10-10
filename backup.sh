#!/bin/bash
set -euo pipefail
trap './hooks/error.sh' ERR
test -x hooks/pre.sh && ./hooks/pre.sh
chmod 0600 "$SSH_KEY"
curl -sSf -u "$USERNAME:$PASSWORD" -o pinboard-backup.xml https://api.pinboard.in/v1/posts/all
xmllint --noout --schema pinboard.xsd pinboard-backup.xml
scp -i "$SSH_KEY" -o UserKnownHostsFile=/srv/known_hosts pinboard-backup.xml "$SCP_URL"
test -x hooks/post.sh && ./hooks/post.sh
