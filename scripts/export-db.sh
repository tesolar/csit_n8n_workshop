#!/usr/bin/env bash
# Export the full n8n Postgres database (n8n's own tables — users, workflows,
# credentials, settings — plus the workshop's exam_results / knowledge_documents
# tables) into init-db/01-init.sql.
#
# Why this matters: Postgres only runs files in init-db/ automatically when its
# data volume is completely empty (first-ever start). So after running this,
# copying the repo (with .env) to another machine and running
# `docker compose up -d` on a fresh volume there reproduces this exact
# instance — same login account, same workflows, same data. Re-run this
# script any time after making changes in n8n that you want captured.
set -euo pipefail
cd "$(dirname "$0")/.."

set -a
source .env
set +a

CONTAINER="${COMPOSE_PROJECT_NAME:-csit_n8n}_postgres"
OUT="init-db/01-init.sql"

if ! docker inspect -f '{{.State.Running}}' "$CONTAINER" >/dev/null 2>&1; then
  echo "Error: container '$CONTAINER' is not running. Start it with: docker compose up -d" >&2
  exit 1
fi

docker exec "$CONTAINER" pg_dump \
  -U "${POSTGRES_USER:-n8n}" \
  -d "${POSTGRES_DB:-n8n}" \
  --clean --if-exists --no-owner --no-privileges \
  > "$OUT"

echo "Exported database to $OUT ($(du -h "$OUT" | cut -f1))"
