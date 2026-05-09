#!/usr/bin/env bash
# Mint a short-lived JWT for hitting the Cube API in non-dev mode.
# Requires Python 3 (preinstalled on macOS) – avoids extra dependencies.
set -Eeuo pipefail

cd "$(dirname "$0")/.."

if [[ -f .env ]]; then
    set -a; source .env; set +a
fi

: "${CUBEJS_API_SECRET:?CUBEJS_API_SECRET must be set in .env}"

EXPIRY_SECONDS="${1:-3600}"

python3 - "$CUBEJS_API_SECRET" "$EXPIRY_SECONDS" <<'PY'
import base64, hashlib, hmac, json, sys, time

secret = sys.argv[1].encode("utf-8")
expiry = int(sys.argv[2])

def b64url(data: bytes) -> str:
    return base64.urlsafe_b64encode(data).rstrip(b"=").decode("ascii")

header  = b64url(json.dumps({"alg": "HS256", "typ": "JWT"}, separators=(",", ":")).encode())
payload = b64url(json.dumps({"iat": int(time.time()), "exp": int(time.time()) + expiry},
                            separators=(",", ":")).encode())
signing_input = f"{header}.{payload}".encode()
signature = b64url(hmac.new(secret, signing_input, hashlib.sha256).digest())
print(f"{header}.{payload}.{signature}")
PY
