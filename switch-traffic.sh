#!/bin/bash

SCRIPT_NAME=$0
COLOR=$(echo "$1" | tr '[:upper:]' '[:lower:]')  # Convert input to lowercase

SERVICE_FILE=k8s/services.yml
COLOR_SELECTOR=color: 
DEPLOYMENT_FILE=k8s/$COLOR-deployment.yml
USAGE=$(cat <<-END
usage: ${SCRIPT_NAME}    <deployment>

arguments:
    <deployment>    green or blue

description:
    This script updates the service to route all traffic to the given deployment.
    Deployment must be either blue or green.
END
)

case "$COLOR" in
	green) ;;
	blue) ;;
	*) echo "$USAGE"; exit 1;
esac

echo "Routing all traffic of $SERVICE_FILE to deployment $COLOR..."

sed -i.bak "s?${COLOR_SELECTOR}.*?${COLOR_SELECTOR} ${COLOR}?g" $SERVICE_FILE
kubectl apply -f $SERVICE_FILE
rm $SERVICE_FILE.bak  # Clean up temporary file used by sed

echo "Done."
