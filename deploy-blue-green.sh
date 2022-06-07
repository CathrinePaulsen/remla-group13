#!/bin/bash

SCRIPT_NAME=$0
COLOR=${1,,}  # Convert input to lowercase
TAG=$2

IMAGE=ghcr.io/cathrinepaulsen/remla-group13
DEPLOYMENT_FILE=k8s/$COLOR-deployment.yml
USAGE=$(cat <<-END
usage: ${SCRIPT_NAME}    <deployment>    [tag_name]

arguments:
    <deployment>    green or blue
    [tag_name]      optional: tag name of the new image, i.e. version

description:
    This script updates the version for either the blue or green deployment to the given tag name.
    If no tag name is given, it will deploy the deployment with its existing image.
    Deployment must be either blue or green.
END
)

case "$COLOR" in
	green) ;;
	blue) ;;
	*) echo "$USAGE"; exit 1;
esac

if [ "$#" -eq 1 ]; then
	echo "Deploying $COLOR..."

elif [ "$#" -eq 2 ]; then
	echo "Deploying version $TAG to file $DEPLOYMENT_FILE..."
	sed -i "s?${IMAGE}:.*?${IMAGE}:${TAG}?g" $DEPLOYMENT_FILE
fi

kubectl apply -f $DEPLOYMENT_FILE
echo "Done."
