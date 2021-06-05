function cluster_auth_gcp {
clusterName=${1:-"services-gke"}
# gke
echo "get GKE cluster info"
clusterName=$(gcloud container clusters list --filter "name:${clusterName}" --format json | jq -r .[].name)
zone=$(gcloud container clusters list --filter "name:${clusterName}" --format json | jq -r .[].zone)
clusterNodes=$(gcloud compute instances list --filter "name:${clusterName}"-clu --format json | jq -r .[].networkInterfaces[].accessConfigs[0].natIP)
# cluster creds
echo "get GKE cluster creds"
gcloud container clusters \
    get-credentials  $clusterName	 \
    --zone $zone
echo "====Done===="
}
