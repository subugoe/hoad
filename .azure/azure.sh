SUBSCRIPTION_ID="f0dd3a37-0a4e-4e7f-9c9b-cb9f60146edc"
RESOURCE_GROUP="hoad"

# script to set up privilege json, stored on GitHub as a AZURE_CREDENTIALS secret
# https://github.com/Azure/login
# here are instructions for minimally scoped auth https://github.com/Azure/webapps-container-deploy
az ad sp create-for-rbac \
  --name "https://github.com/subugoe/hoad" \
  --role contributor \
  --scopes /subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP \
  --sdk-auth
