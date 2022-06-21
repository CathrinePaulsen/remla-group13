# Automated blue-green deployment of REMLA-app
This repository contains the necessary files and deployments scripts to deploy REMLA-app in a Kubernetes/Minikube setting and perform automated blue-green deployment.

#### What is REMLA-app?
REMLA-app is a machine learning application that predicts tags for titles of StackOverflow posts using multilabel classification.
The application provides a simple web interface where users can provide a title and get the model's predicted tags back. 
Users can then provide feedback on the quality of the predicted tags.

The application is based on the jupyter notebook provided by [luiscruz/remla-baseline-project](https://github.com/luiscruz/remla-baseline-project).

## Setup guide
The REMLA-app can be deployed in two ways: singular deployment or blue-green deployment.
#### Deployments requirements:
* Helm v3.9
* Minikube v1.25

### Singular deployment
To deploy only one instance ("blue") of REMLA-app using Minikube:
* Run `./deploy-simple.sh`
* Access the web interface at `<ingress_ip>/`

### Automated blue-green deployment
To deploy two instances ("blue" and "green") of REMLA-app using Minikube:
* First perform singular deployment.
* Run `./deploy-bg.sh green <version>`
* Install the alert_actor, e.g. run `pip install -e alert_actor` from the project root
* Run `alert_actor` from the project root
* Access the web interface at `<ingress_ip>/`

The automated blue-green deployment will switch traffic to the green deployment.
Once one of the metrics used in `k8s/alert_rules.yml` drops below their specified thresholds, a Prometheus alert will fire which will trigger the alert_actor to switch traffic back to the old version.

## Script overview
Descriptions of the scripts' usage is also found by running `./<script_name> --help`.
### `deploy-simple.sh`: 
Deploys a singular deployment. 
This script will set up a Minikube cluster and deploy only the blue version of REMLA-app.
The image version used by blue is kept up-to-date in this repository with the latest released image version.

**Note**: When running the script for the first time, you will be prompted to set a password for the Grafana dashboard.

### `deploy-bg.sh <color> <version>`: 
Deploys the given color deployment with the given version.
The script will wait until the deployment is successful, then switch traffic to the newly deployed version.

### `switch-traffic.sh <color>`: 
Switches traffic to the given color deployment.
This script is used by the alert_actor.

### `undeploy.sh <color>`:
Undeploys/deletes the deployment of the given deployment; used to free up resources when you no longer need a stand-by version.

## The alert_actor
Listens for specific alerts on `localhost:8081/webhook`. 
When it receives an alert labeled `rollback="true"`, it switches traffic to the color deployment that is on stand-by (i.e. not currently running in production).
The alert_actor needs access to the Kubernetes manifest containing the service used to access REMLA-app. 
The given default path is `k8s/services.yml` but a different file path can also be given by running `alert_actor <path_to_service_yml>`.

## How to find the ingress ip?
* On MacOS: run `minikube tunnel`. The `<ingress_ip>` is then `localhost`.
* Otherwise: run `minikube service list`. The `<ingress_ip>` can be found in the “URL” column of `ingress-nginx-controller`.

## How can I reuse the automated blue-green deployment for my own application?
You will need the following:
* Scripts: `deploy-bg.sh` and `switch-traffic.sh`. Modify the variables at the top of the scripts to match your environment. The other scripts may also be used for convenience.
* The `alert_actor/` directory to enable automatic alert-based switching between blue-green.
* The `k8s/` directory. Modify the manifests to point to your own application images.
* Implement your own Prometheus alert(s). Modify `k8s/alert_rules.yml` to match your desired alert(s) configuration and add `rollback: "true"` to the labels of all alerts that should initiate rollbacks.

## Grafana dashboard
The Grafana dashboard is accessible on `<ingress_ip>/dashboard`.

We provide a custom dashboard that displays our application-specific metrics (`user_satisfaction`, `num_pred`) which is stored in `k8s/grafana-dashboards/metrics_dashboard.json`.

Log in to the Grafana dashboard with username `admin` and the password you set when running `deploy-simple.sh` for the first time.

To import the dashboard go to Create -> Import and copy-paste the json in `k8s/grafana-dashboards/metrics_dashboard.json`.

## Contributing
To prepare your local environment for development, install all requirements using `pip install -r requirements.txt`. 
We make use of the conventional commits specification for our commit messages, checkout [Conventional Commits](https://www.conventionalcommits.org/en/v1.0.0/#summary) for format. 
We've got checks on CI that enforce this specification. 
To help you, we've defined a git hook that runs these checks after every commit. 
You can configure it by running `pre-commit install`.
