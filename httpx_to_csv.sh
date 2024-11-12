FILENAME=$1

jq -r '[.host, .url, .title, .status_code, (.tech | join(", ")), .webserver] | @csv' "$FILENAME"
