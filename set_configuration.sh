#!/bin/bash

set -x

docker exec -u www-data nextcloud-app php occ --no-warnings app:install onlyoffice

docker exec -u www-data nextcloud-app php occ --no-warnings config:system:set onlyoffice DocumentServerUrl --value="https://nextcloud.example.com/ds-vpath/"
docker exec -u www-data nextcloud-app php occ --no-warnings config:system:set onlyoffice DocumentServerInternalUrl --value="http://onlyoffice-document-server/"
docker exec -u www-data nextcloud-app php occ --no-warnings config:system:set onlyoffice StorageUrl --value="http://nextcloud-app/"

docker exec -u www-data nextcloud-app php occ --no-warnings config:system:set allow_local_remote_servers --value=true
docker exec -u www-data nextcloud-app php occ config:system:set trusted_domains 2 --value=nextcloud-app
docker exec -u www-data nextcloud-app php occ config:system:set overwriteprotocol --value="https" # fix ssl error with nextcloud ios/android apps

docker exec -u www-data nextcloud-app php occ config:system:set skeletondirectory --value='' # remove default files

JWT_SECRET=$(docker exec onlyoffice-document-server /var/www/onlyoffice/documentserver/npm/json -f /etc/onlyoffice/documentserver/local.json 'services.CoAuthoring.secret.session.string')
docker exec -u www-data nextcloud-app php occ --no-warnings config:system:set onlyoffice jwt_secret --value=$JWT_SECRET
docker exec -u www-data nextcloud-app php occ --no-warnings config:system:set onlyoffice jwt_header --value="AuthorizationJwt"