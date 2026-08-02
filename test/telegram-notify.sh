#!/bin/bash

set -eu

root=$(cd "$(dirname "$0")/.." && pwd)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

cat >"$tmp/curl" <<'EOF'
#!/bin/bash
printf '%s\n' "$@" >"$CURL_ARGS"
cat /dev/fd/3 >"$CURL_CONFIG"
cat >"$CURL_STDIN"
exit "${CURL_STATUS:-0}"
EOF
chmod +x "$tmp/curl"

run() {
  CURL_ARGS="$tmp/args" CURL_CONFIG="$tmp/config" CURL_STDIN="$tmp/stdin" \
    PATH="$tmp:$PATH" TELEGRAM_BOT_TOKEN=secret TELEGRAM_CHAT_ID=123 \
    "$root/bin/telegram-notify" "$@"
}

run 'argument message'
grep -qx 'argument message' "$tmp/stdin"
grep -q 'botsecret/sendMessage' "$tmp/config"
! grep -q 'argument message\|secret' "$tmp/args"

printf 'stdin message' | run
grep -qx 'stdin message' "$tmp/stdin"

! env -u TELEGRAM_BOT_TOKEN TELEGRAM_CHAT_ID=123 "$root/bin/telegram-notify" message 2>/dev/null
! env TELEGRAM_BOT_TOKEN=secret TELEGRAM_CHAT_ID=123 CURL_STATUS=7 CURL_ARGS="$tmp/args" \
  CURL_CONFIG="$tmp/config" CURL_STDIN="$tmp/stdin" PATH="$tmp:$PATH" \
  "$root/bin/telegram-notify" message
