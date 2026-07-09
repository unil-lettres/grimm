#!/usr/bin/env sh
set -eu

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EXIST_URL="http://localhost:8080/exist"
REPO_UPLOAD_URL="$EXIST_URL/rest/db/system/repo/init.xar"
DEPLOY_XPATH='repo:install-and-deploy-from-db("/db/system/repo/init.xar")'

echo "[init] Waiting for eXist-db to become available…"

# Wait for eXist to respond
until curl -fs "$EXIST_URL/rest/db" >/dev/null 2>&1; do
    sleep 2
done

echo "[init] eXist-db is up."

cd "$PROJECT_ROOT"

echo "[init] Building XARs…"
ant

# Install XARs
for XAR in build/*.xar; do
    [ -f "$XAR" ] || continue
    echo "[init] Installing $(basename "$XAR")"

    curl -fs --upload-file "$XAR" \
        -u 'admin:' \
        "$REPO_UPLOAD_URL"

    curl -fs \
        -u 'admin:' \
        "$EXIST_URL/rest/db?_xpath=$DEPLOY_XPATH"
done

echo "[init] XAR deployment complete."