#!/bin/bash

# ce qui est configurable : https://github.com/bryangerlach/rdgen/blob/master/rdgenerator/views.py
# les actions à faire : https://github.com/bryangerlach/rdgen/blob/master/.github/workflows/generator-windows.yml
PASSWORD="toto"
CUSTOM='{"override-settings":{"allow-remote-config-modification": "Y"},"password":"'${PASSWORD}'"}'
                                                                          # si nécessaire il faut (en Python) :
                                                                          # - string_bytes = decodedCustomJson.encode("ascii")
CUSTOM=$(echo ${CUSTOM} | base64)                                         # - base64_bytes = base64.b64encode(string_bytes)
                                                                          # - encodedCustom = base64_bytes.decode("ascii")


RENDEZVOUS_SERVERS="rs-ny.rustdesk.com"
RENDEZVOUS_PORT="21116"
RELAY_PORT="21117"
KEY="OeVuKk5nlHiXp+APNn0Y3pC1Iwpwn44JGqrQCsWqmBw="


if [ "$1" == "custom.txt" ]; then 
  echo -n "${CUSTOM}" | cat > ./rustdesk/custom.txt
else
  sed -i -e 's|rs-ny.rustdesk.com|'${RENDEZVOUS_SERVER}'|' ./libs/hbb_common/src/config.rs
  sed -i -e 's|21116|'${RENDEZVOUS_PORT}'|' ./libs/hbb_common/src/config.rs
  sed -i -e 's|21117|'${RELAY_PORT}'|' ./libs/hbb_common/src/config.rs
  sed -i -e 's|OeVuKk5nlHiXp+APNn0Y3pC1Iwpwn44JGqrQCsWqmBw=|'${KEY}'|' ./libs/hbb_common/src/config.rs
  git apply patches/common.rs.diff
  git apply patches/connection_page.dart.diff
fi


