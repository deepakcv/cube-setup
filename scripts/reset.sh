#!/usr/bin/env bash
# Wipe Postgres data + Cube containers and bring the stack back up clean.
# Useful when you've changed DDL/seed files and want a fresh database.
set -Eeuo pipefail

cd "$(dirname "$0")/.."

echo "[reset] Stopping stack and removing the postgres volume..."
docker compose down --volumes --remove-orphans

echo "[reset] Bringing the stack back up..."
docker compose up -d

echo "[reset] Waiting for postgres to be healthy..."
until docker compose exec -T postgres pg_isready -U "${POSTGRES_USER:-retail}" -d "${POSTGRES_DB:-retail}" >/dev/null 2>&1; do
    printf '.'
    sleep 1
done
echo

echo "[reset] Done. Cube UI: http://localhost:${CUBE_PORT:-4000}"
