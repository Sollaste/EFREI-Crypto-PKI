# !/bin/sh

set -e

./1_generate_root_ca.sh
./2_generate_intermediate_ca.sh
./3_create_role.sh
./4_emission_cert.sh

echo "Toutes les étapes ce sont terminées"