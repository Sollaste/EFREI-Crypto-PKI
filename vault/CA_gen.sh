# !/bin/sh

# Generate Root CA
vault secrets enable pki
vault secrets tune -max-lease-ttl=87600h pki
vault write -field=certificate pki/root/generate/internal common_name="efrei.lan" issuer_name="root-2025" ttl=87600h > root_2025_ca.crt
vault write pki/roles/2025-servers allow_any_name=true
vault write pki/config/urls issuing_certificates="$VAULT_ADDR/v1/pki/ca" crl_distribution_points="$VAULT_ADDR/v1/pki/crl"

# Generate intermediate CA
vault secrets enable -path=pki_int pki
vault secrets tune -max-lease-ttl=43800h pki_int
vault write -format=json pki_int/intermediate/generate/internal common_name="efrei.lan Intermediate Authority" issuer_name="efrei-dot-lan-intermediate" | jq -r '.data.csr' > pki_intermediate.csr # Generate intermediate
vault write -format=json pki/root/sign-intermediate issuer_ref="root-2025" csr=@pki_intermediate.csr format=pem_bundle ttl="43800h" | jq -r '.data.certificate' > intermediate.cert.pem # Sign intermediate with root CA
vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem # Import to vault

# Create role
vault write pki_int/roles/efrei-dot-lan issuer_ref="$(vault read -field=default pki_int/config/issuers)" allowed_domains="efrei.lan" allow_subdomains=true max_ttl="720h"

# Request Cert
vault write pki_int/issue/efrei-dot-lan common_name="ca.efrei.lan" ttl="24h"