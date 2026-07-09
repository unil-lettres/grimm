#!/usr/bin/env sh#!/cd "$(dirname "$0")/.." && pwd)"
EXIST_URL="http://localhost:8080/exist"
REPO_UPLOAD_URL="$EXIST_URL/rest/db/system/repo/init.xar"
DEPLOY_XPATH='repo:install-and-deploy-from-db("/db/system/repo/init.xar")'

echo "[init] Waiting for eXist-db…"
until curl -fs "$EXIST_URL/rest/db" >/dev/null 2>&1; do
  sleep 2
done
echo "[init] eXist-db is up."

cd "$PROJECT_ROOT"

echo "[init] Running ant…"
ant

# If no XARs exist, avoid looping on the literal pattern
set +e
ls build/*.xar >/dev/null 2>&1
HAS_XARS=$?
set -e

if [ "$HAS_XARS" -ne 0 ]; then
  echo "[init] No XARs found in build/*.xar — nothing to deploy."
  exit 0
fi

for XAR in build/*.xar; do
  echo "[init] Installing $XAR"
  curl -fs --upload-file "$XAR" -u 'admin:' "$REPO_UPLOAD_URL"
  curl -fs -u 'admin:' "$EXIST_URL/rest/db?_xpath=$DEPLOY_XPATH"
done

echo "[init] Done."
set -eu