#!/usr/bin/env bash
# Upload semua foto contoh ke bucket Storage `photos`.
# Jalankan dari root project:
#   SUPABASE_SERVICE_ROLE_KEY=... ./supabase/upload-assets.sh
set -euo pipefail

SUPABASE_URL="${SUPABASE_URL:-https://yjmhqpsovlhanglpepmz.supabase.co}"
: "${SUPABASE_SERVICE_ROLE_KEY:?Set SUPABASE_SERVICE_ROLE_KEY (Settings > API > service_role)}"
BUCKET="${BUCKET:-photos}"

# Buat bucket kalau belum ada (abaikan error "already exists").
curl -sS -X POST "$SUPABASE_URL/storage/v1/bucket" \
  -H "Authorization: Bearer $SUPABASE_SERVICE_ROLE_KEY" \
  -H "Content-Type: application/json" \
  -d "{\"id\":\"$BUCKET\",\"name\":\"$BUCKET\",\"public\":true}" >/dev/null || true

for file in lib/assets/*.jpg; do
  name="$(basename "$file")"
  code="$(curl -sS -o /dev/null -w '%{http_code}' -X POST \
    "$SUPABASE_URL/storage/v1/object/$BUCKET/$name" \
    -H "Authorization: Bearer $SUPABASE_SERVICE_ROLE_KEY" \
    -H "Content-Type: image/jpeg" \
    -H "x-upsert: true" \
    --data-binary "@$file")"
  if [ "$code" != "200" ]; then
    echo "GAGAL $name (HTTP $code)" >&2
    exit 1
  fi
  echo "ok $name"
done

echo "Selesai. URL publik: $SUPABASE_URL/storage/v1/object/public/$BUCKET/<nama-file>"
