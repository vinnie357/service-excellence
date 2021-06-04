#https://learn.hashicorp.com/tutorials/waypoint/get-started-kubernetes

```bash
git clone https://github.com/hashicorp/waypoint-examples.git

cd waypoint-examples/kubernetes/nodejs

waypoint install --platform=kubernetes -accept-tos

## if issues
# get your service ip
kubectl  get svc waypoint -o json | jq -r .status.loadBalancer.ingress[0].ip
waypointserver=$(kubectl get svc waypoint -o json | jq -r .status.loadBalancer.ingress[0].ip)
waypoint server config-set -advertise-addr=$waypointserver:9701

# set your project in example
GCP_PROJECT=$(gcloud config get-value project)

sed -i "s/image = \"example-nodejs\"/image = \"gcr.io\/${GCP_PROJECT}\/example-nodejs\"/g" ./waypoint.hcl
# initlize waypoint
waypoint init

waypoint up

# make a change
vi views/pages/index.ejs

waypoint up

# add a hostname to waypoint.hcl
  url {
    auto_hostname = true
  }
waypoint init

waypoint up

waypoint destroy -auto-approve
```
