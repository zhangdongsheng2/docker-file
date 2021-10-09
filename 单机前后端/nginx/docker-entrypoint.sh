#!/bin/sh

set -xe
: "${COMPANY_NAME_SHORT?enviroment is required}"
: "${IFRAME_BASE_URL?enviroment is required}"
set +x

COMPANY_NAME_SHORT=$COMPANY_NAME_SHORT
IFRAME_BASE_URL=$IFRAME_BASE_URL

sed -i \
 -e "s/DOCKER_ENV_COMPANY_NAME_SHORT_REPLACE/${COMPANY_NAME_SHORT/\//\\\//}/g" \
 -e "s+DOCKER_ENV_IFRAME_BASE_URL_REPLACE+$IFRAME_BASE_URL+g" \
 /usr/share/nginx/html/assets/docker_enviroment.js

