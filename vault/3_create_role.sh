# !/bin/sh

vault write pki_int/roles/efrei-dot-lan \
  issuer_ref="$(vault read -field=default pki_int/config/issuers)" \
  allowed_domains="efrei.lan" \
  allow_subdomains=true \
  max_ttl="720h"