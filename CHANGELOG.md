## v0.3.0 (2022-06-21)

### Feat

- **metrics**: Add alert for slow responses
- **metrics**: Add alert for empty responses
- allow any alert to trigger rollback
- add first working MVP of user_satisfaction automatically triggering traffic switch
- add first working MVP of user_satisfaction automatically triggering traffic switch
- implement user satisfaction prompt
- add user satisfaction metric to prediction page

### Fix

- **alert_actor**: allow alert_actor to switch both ways (blue<=>green)
- add quotes around string variable
- handle firing alerts only

### Refactor

- separate Kubernetes manifests into their own files

## v0.2.5 (2022-06-11)

### Fix

- put version.py in src folder
- rename __version.py in all files
- try to fix broken docker build
- renamed _version.py to version.py
- remove empty statement from release-image.yml
- remove empty change in _version.py
- merge conflicts browser-interactions and version-tag

## v0.2.4 (2022-06-08)

### Fix

- release image echo command

## v0.2.3 (2022-06-07)

### Fix

- fix commitizen errors
- reverse changes in actions, keep release tag in release-image

### Feat

- add version tag to endpoint
- **serve_model**: Add endpoint for the landing page
- **k8s**: Add ingress access to Grafana dashboard, finetune automatic local deployment

### Refactor

- separate Kubernetes manifests into their own files
- change version.py to _version.py
- add version.py
- add pretty-printed, human-readable tags

## v0.2.2 (2022-06-05)

### Fix

- Remove quotes around boolean in equals comparison
- Fix docker image not finding tfidf_vectorizer.pkl necessary for the /predict endpoint
- change ghcr repo name to all lowercase
