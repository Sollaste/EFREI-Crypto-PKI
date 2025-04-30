#!/bin/sh
set -e

vault secrets enable -path=pki_int pki

vault secrets tune -max-lease-ttl=43800h pki_int

vault write -format=json pki_int/intermediate/generate/internal \
    common_name="efrei.lan Intermediate Authority" \
    issuer_name="efrei-dot-lan-intermediate" \
    | jq -r '.data.csr' > pki_intermediate.csr

vault write -format=json pki/root/sign-intermediate \
    issuer_ref="Root-CA-EFREI-LAN" \
    csr=@pki_intermediate.csr format=pem_bundle ttl="43800h" \
    | jq -r '.data.certificate' > intermediate.cert.pem

vault write pki_int/config/urls \
  issuing_certificates="$VAULT_ADDR/v1/pki_int/ca" \
  crl_distribution_points="$VAULT_ADDR/v1/pki_int/crl"

vault write pki_int/intermediate/set-signed certificate=@intermediate.cert.pem