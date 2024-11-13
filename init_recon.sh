TARGET=$1

echo "[i] starting basic recon for $TARGET"

mkdir init_recon

subfinder -d "$TARGET" | rev | sort | rev > "init_recon/$TARGET.domains.all"
dnsx -l "init_recon/$TARGET.domains.all" -o "init_recon/$TARGET.domains"
httpx -l "init_recon/$TARGET.domains" -json -o "init_recon/$TARGET.webroots.json"
jq -r '[.host, .url, .title, .status_code, (.tech | join(", ")), .webserver] | @csv' "init_recon/$TARGET.webroots.json" > "init_recon/$TARGET.webroots.csv"
jq -r .url "init_recon/$TARGET.webroots.json" > "init_recon/$TARGET.webroots.txt"

dig +short $(<"init_recon/$TARGET.domains") | grep -Ev '[a-Z]' | sort | uniq | naabu -o "init_recon/$TARGET.naabu"
grep -Ev ":(80|443)$" "init_recon/$TARGET.naabu" | httpx -json -o "init_recon/$TARGET.non_standard.httpx.json"
jq -r '[.host, .url, .title, .status_code, (.tech | join(", ")), .webserver] | @csv' "init_recon/$TARGET.non_standard.httpx.json" > "init_recon/$TARGET.non_standard.httpx.csv"
