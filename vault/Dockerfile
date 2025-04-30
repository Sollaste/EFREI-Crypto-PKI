FROM hashicorp/vault

RUN apk update && apk add jq

COPY ./1_generate_root_ca.sh /vault/scripts/1_generate_root_ca.sh
COPY ./2_generate_intermediate_ca.sh /vault/scripts/2_generate_intermediate_ca.sh
COPY ./3_create_role.sh /vault/scripts/3_create_role.sh
COPY ./4_emission_cert.sh /vault/scripts/4_emission_cert.sh
COPY ./X_all_in_generator.sh /vault/scripts/X_all_in_generator.sh

RUN chmod +x /vault/scripts/*.sh