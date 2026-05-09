#!/usr/bin/env bash
# Postgres entrypoint hook: runs every DDL file then every seed file, in order,
# stopping immediately on the first error. Executed exactly once on a fresh
# data volume by the official postgres image.
set -Eeuo pipefail

readonly MIGRATIONS_ROOT="/migrations"
readonly DDL_DIR="${MIGRATIONS_ROOT}/ddl"
readonly SEED_DIR="${MIGRATIONS_ROOT}/seed"

log() { printf '[migrations] %s\n' "$*"; }

run_sql_dir() {
    local dir="$1"
    local label="$2"

    if [[ ! -d "${dir}" ]]; then
        log "WARN: ${label} directory '${dir}' not found, skipping."
        return 0
    fi

    shopt -s nullglob
    local files=("${dir}"/*.sql)
    shopt -u nullglob

    if (( ${#files[@]} == 0 )); then
        log "WARN: no .sql files in ${dir}, skipping ${label}."
        return 0
    fi

    log "Applying ${label} (${#files[@]} file(s)) from ${dir}"
    for f in "${files[@]}"; do
        log " -> $(basename "${f}")"
        psql --variable=ON_ERROR_STOP=1 \
             --no-psqlrc \
             --quiet \
             --username "${POSTGRES_USER}" \
             --dbname   "${POSTGRES_DB}" \
             --file     "${f}"
    done
}

log "Starting migration runner (db=${POSTGRES_DB} user=${POSTGRES_USER})"
run_sql_dir "${DDL_DIR}"  "DDL"
run_sql_dir "${SEED_DIR}" "seed"
log "Migrations complete."
