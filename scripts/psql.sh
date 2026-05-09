#!/usr/bin/env bash
# Open an interactive psql session against the running database.
set -Eeuo pipefail

cd "$(dirname "$0")/.."

# Source .env so credentials don't have to be exported manually.
if [[ -f .env ]]; then
    set -a; source .env; set +a
fi

exec docker compose exec -it postgres \
    psql -U "${POSTGRES_USER:-retail}" -d "${POSTGRES_DB:-retail}"
