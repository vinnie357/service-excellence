# gcp

- gke
- gcr
- waypoint

## login
```bash
# authenticate
. init.sh && gcloud_auth "myproject"
# run
setup && info

```

## deploy nsm
```bash
. init.sh && install_meshctl
. init.sh && deploy_nsm
```

## deploy kic
```bash
. init.sh && deploy_kic "1.9.0"
```

## configure waypoint

  [waypoint](../waypoint/gcp/readme.md)

## deploy apps
