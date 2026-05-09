#!/usr/bin/env bash
# Hit the Cube GraphQL endpoint with a representative sales-analytics query.
# In dev mode (CUBEJS_DEV_MODE=true) auth is not enforced; in prod, this
# script uses ./scripts/cube-token.sh to mint a JWT.
set -Eeuo pipefail

cd "$(dirname "$0")/.."

if [[ -f .env ]]; then
    set -a; source .env; set +a
fi

PORT="${CUBE_PORT:-4000}"
URL="http://localhost:${PORT}/cubejs-api/graphql"

AUTH_HEADER=()
if [[ "${CUBEJS_DEV_MODE:-true}" != "true" ]]; then
    TOKEN="$(./scripts/cube-token.sh 600)"
    AUTH_HEADER=(-H "Authorization: ${TOKEN}")
fi

read -r -d '' QUERY <<'GRAPHQL' || true
{
  cube(
    where: { sales_analytics: { sale_date: { inDateRange: ["30 days ago", "today"] } } }
    orderBy: { sales_analytics: { sale_date: asc } }
    limit: 10
  ) {
    sales_analytics {
      sale_date { day }
      salesman_department_name
      gross_revenue
      gross_profit
      total_quantity
    }
  }
}
GRAPHQL

curl --silent --show-error \
     --request POST "$URL" \
     --header "Content-Type: application/json" \
     "${AUTH_HEADER[@]}" \
     --data "$(python3 -c 'import json,sys; print(json.dumps({"query": sys.stdin.read()}))' <<<"$QUERY")" \
| python3 -m json.tool
