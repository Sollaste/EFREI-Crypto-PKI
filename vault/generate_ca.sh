# !/bin/sh
# Generate Root CA

vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki
vault write -field=certificate pki/root/generate/internal common_name="efrei.lan" issuer_name="root-2025" ttl=87600h > root_2025_ca.crt
vault write pki/roles/2025-servers allow_any_name=true
vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl"