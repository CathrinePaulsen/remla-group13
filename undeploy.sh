#!/bin/bash

SCRIPT_NAME=$0
COLOR=$(echo "$1" | tr '[:upper:]' '[:lower:]')  # Convert input to lowercase

DEPLOYMENT_FILE=k8s/$COLOR-deployment.yml
USAGE=$(cat <<-END
usage: ${SCRIPT_NAME}    <deployment>

arguments:
    <deployment>    green or blue

description:
    This script undeploys the given deployment to free up system resources.
    Deployment must be either blue or green.
END
)

case "$COLOR" in
	green) ;;
	blue) ;;
	*) echo "$USAGE"; exit 1;
esac

echo "Undeploying deployment $COLOR..."

kubectl delete -f $DEPLOYMENT_FILE

echo "Done."
