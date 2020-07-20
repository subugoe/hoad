#!/usr/bin/env bash
set -e

SUBSCRIPTION_ID="f0dd3a37-0a4e-4e7f-9c9b-cb9f60146edc"
RESOURCE_GROUP="hoad"
WEBAPP_NAME="hoad"
IMAGE_TAG="azure"

# script to set up privilege json, stored on GitHub as a AZURE_CREDENTIALS secret
# https://github.com/Azure/login
# here are instructions for minimally scoped auth https://github.com/Azure/webapps-container-deploy
# az ad sp create-for-rbac \
#   --name "https://github.com/subugoe/hoad" \
#   --role contributor \
#   --scopes /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP \
#   --sdk-auth

echo "Setting defaults ..."
az account set --subscription $SUBSCRIPTION_ID
az configure \
  --defaults group=$RESOURCE_GROUP web=$WEBAPP_NAME

echo "Enabling arr client affinity ..."
# for some reason, this is not part of the webapp config, though it is on portal.azure.com
az webapp update \
  --client-affinity-enabled true

echo "Setting web app configuration ..."
az webapp config set \
  --always-on true \
  --ftps-state disabled \
  --web-sockets-enabled true \
  --http20-enabled false \
  --startup-file init.sh

echo "Setting container configuration ..."
az webapp config container set \
  --docker-custom-image-name docker.pkg.github.com/subugoe/hoad/hoad-dev:$IMAGE_TAG \
  --docker-registry-server-url https://docker.pkg.github.com \
  --docker-registry-server-user maxheld83 \
  --enable-app-service-storage false
# DOCKER_REGISTRY_SERVER_PASSWORD is a GH PAT set on portal.azure.com

echo "Disable Docker CI ..."
# weirdly this cannot be set in the above
az webapp config appsettings set \
  --settings DOCKER_ENABLE_CI=false

# TODO might not be necessary
echo "Restarting web app ..."
az webapp restart
