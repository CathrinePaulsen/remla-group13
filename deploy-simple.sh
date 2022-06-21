#!/bin/bash

# This script can be run as-is or used as a reference
# to deploy the remla app on a fully-functioning minikube cluster.

# Install requirements: helm v3.9, minikube v1.25


# Create a new minikube cluster with ingress enabled:
minikube start
minikube addons enable ingress


# Show cluster info to verify that cluster is running:
kubectl cluster-info
# Run "minikube dashboard" for an in-browser dashboard

# Set Grafana password if running script for the first time
if [ ! -f k8s/values.yml ]; then
    echo "INFO: k8s/values.yml does not exist. This is normal if it's your first time running this script, you need to provide a Grafana password first:"
    read -sp 'Enter Grafana password: ' GRAF_PASS
    cp k8s/values.yml.dist k8s/values.yml
	sed -i.bak "s?<PLACEHOLDER>?$GRAF_PASS?g" k8s/values.yml
    rm k8s/values.yml.bak
    echo "Grafana password has been set."
fi

# Install kube-prometheus-stack used for monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install -f k8s/values.yml -f k8s/alert-rules.yml promstack prometheus-community/kube-prometheus-stack


# Create pods, services, and ingress:
kubectl apply -f k8s/blue-deployment.yml
kubectl apply -f k8s/services.yml
kubectl apply -f k8s/ingress.yml

# Make sure service always routes traffic to blue
./switch-traffic.sh blue



# Quick way to get the ip:port / urls you need to access the API
minikube service list

# Enable access to the prometheus dashboard on localhost:9090
# kubectl port-forward prometheus-promstack-kube-prometheus-prometheus-0 9090

# To access the /predict endpoint, simply access the IP of the ingress
# which is displayed by "minikube service list" with the endpoint appended,
# i.e. <ingress-ip>/predict
# Available endpoints: /predict, /metrics, /dashboard
