# !/bin/sh

vault secrets enable -path=pki_int pki
vault secrets tune -max-lease-ttl=43800h pki_int
vault write -format=json pki_int/intermediate/generate/internal common_name="efrei.lan Intermediate Authority" issuer_name="efrei-dot-lan-intermediate" | jq -r '.data.csr' > pki_intermediate.csr # Generate intermediate
vault write -format=json pki/root/sign-intermediate issuer_ref="root-2025" csr=@pki_intermediate.csr format=pem_bundle ttl="43800h" | jq -r '.data.certificate' > intermediate.cert.pem # Sign intermediate with root CA
vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem # Import to vault