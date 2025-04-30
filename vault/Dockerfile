FROM hashicorp/vault

RUN apk update && apk add jq

COPY ./generate_ca.sh /vault/scripts/generate_ca.sh
COPY ./generate_intermediate_ca.sh /vault/scripts/generate_intermediate_ca.sh
COPY ./create_role.sh /vault/scripts/create_role.sh
COPY ./request_cert.sh /vault/scripts/request_cert.sh

# RUN chmod +x /vault/scripts/*.sh && export VAULT_ADDR=http://127.0.0.1:8200 && export VAULT_TOKEN=myroot