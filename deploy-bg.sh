#!/bin/bash

SCRIPT_NAME=$0
COLOR=$(echo "$1" | tr '[:upper:]' '[:lower:]')  # Convert input to lowercase
TAG=$2
NO_DEPLOY=$3

IMAGE=ghcr.io/cathrinepaulsen/remla-group13
DEPLOYMENT_FILE=k8s/$COLOR-deployment.yml
USAGE=$(cat <<-END
usage: ${SCRIPT_NAME}    <deployment>    [tag_name]   [no-deploy]

arguments:
    <deployment>    green or blue
    [tag_name]      optional: tag name of the new image, i.e. version
    [no-deploy]     optional: if no-deploy=true then the manifest is only changed, not deployed.

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

if [ "$#" -eq 3 ]; then
	case "$NO_DEPLOY" in
		no-deploy=true) ;;
		no-deploy=false) ;;
		*) echo "$USAGE"; exit 1;
	esac
fi



if [ "$#" -eq 1 ]; then
	echo "Deploying $COLOR..."

elif [ "$#" -ge 2 ]; then
	echo "Changing image version $TAG in file $DEPLOYMENT_FILE..."
	sed -i.bak "s?${IMAGE}:.*?${IMAGE}:${TAG}?g" $DEPLOYMENT_FILE
	rm $DEPLOYMENT_FILE.bak  # Clean up temporary file used by sed
fi

if [ "$#" -eq 2 ] || [ "$NO_DEPLOY" != "no-deploy=false" ]; then
    echo "Deploying $COLOR with image version $TAG..."
	kubectl apply -f $DEPLOYMENT_FILE

    echo "Waiting for $COLOR to fully deploy..."
    while [[ $(kubectl get pods -l color=$COLOR -o 'jsonpath={..status.conditions[?(@.type=="Ready")].status}') != "True" ]]; do
        sleep 1
    done

    echo "$COLOR is fully deployed, switching traffic..."
    ./switch-traffic.sh $COLOR
fi

echo "Done."
