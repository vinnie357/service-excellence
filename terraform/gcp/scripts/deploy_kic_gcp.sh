function deploy_kic_gcp {
# deploys kic with gke
# example command:
# deploy_kic
# custom:
# deploy_kic 1.9.0 nginx-gke-west mysecret
version=${1:-"1.9.0"}
clusterName=${2:-"services-gke"}
secretName=${3:-"services-nginx-secret"}
dir=${PWD}
GCP_PROJECT=$(gcloud config get-value project)
# setup kic
# authorize docker to push custom images
echo "authorize docker to push to Google Container Registry"
gcloud auth configure-docker --quiet
# build kic+image for gcp
git clone https://github.com/nginxinc/kubernetes-ingress.git
cd kubernetes-ingress
git checkout tags/v${version}
# get secrets
echo "get secrets"
secret=$(gcloud secrets list --filter "name:${secretName}" --format json | jq -r .[].name | cut -d '/' -f 4)
secrets=$(gcloud secrets versions access latest --secret="${secret}")
# install cert key
echo "setting info from Metadata secret"
# cert
cat << EOF > nginx-repo.crt
$(echo $secrets | jq -r .cert)
EOF
# key
cat << EOF > nginx-repo.key
$(echo $secrets | jq -r .key)
EOF
#cp ../nginx-plus-demos/licenses/nginx-repo.crt ../nginx-plus-demos/licenses/nginx-repo.key ./
echo "build kic container"
make DOCKERFILE=DockerfileForPlus VERSION=v${version} PREFIX=gcr.io/${GCP_PROJECT}/nginx-plus-ingress
cd $dir
# template kic files
# modify for custom registry
# backup
cp -f ./templates/kic/nginx-ingress-install.yml.tpl ./nginx-ingress-install.yml
cp -f ./templates/kic/nginx-ingress-dashboard.yml.tpl ./nginx-ingress-dashboard.yml
sed -i "s/-image-/gcr.io\/${GCP_PROJECT}\/nginx-plus-ingress:v${version}/g" ./nginx-ingress-install.yml

# default cert/key
sed -i "s/-defaultCert-/$(echo $secrets | jq -r .defaultCert | base64 -w 0)/g" ./nginx-ingress-install.yml
sed -i "s/-defaultKey-/$(echo $secrets | jq -r .defaultKey| base64 -w 0)/g" ./nginx-ingress-install.yml

# gke
echo "get GKE cluster info"
# cluster name
#gcloud container clusters list --filter "name:${clusterName}" --format json | jq .[].name
clusterName=$(gcloud container clusters list --filter "name:${clusterName}" --format json | jq -r .[].name)

# zone
#gcloud container clusters list --filter "name:${clusterName}" --format json | jq .[].zone
zone=$(gcloud container clusters list --filter "name:${clusterName}" --format json | jq -r .[].zone)

# cluster nodes
# gcloud compute instances list --filter "name:${clusterName}"-clu
# gcloud compute instances list --filter "name:${clusterName}"-clu --format json | jq .[].networkInterfaces[].accessConfigs[0].natIP
clusterNodes=$(gcloud compute instances list --filter "name:${clusterName}"-clu --format json | jq -r .[].networkInterfaces[].accessConfigs[0].natIP)

# cluster creds
echo "get GKE cluster creds"
gcloud container clusters \
    get-credentials  $clusterName	 \
    --zone $zone
# deploy kic and dashboard
kubectl apply -f ./nginx-ingress-install.yml
# add dashboard
kubectl apply -f ./nginx-ingress-dashboard.yml

# show pods
echo " show ingress pods"
sleep 30
kubectl get pods -n nginx-ingress -o wide
#kubectl logs -f -lapp=nginx-ingress -n nginx-ingress
# finished
cd $dir
# deploy apps
cp -f ./templates/kic/arcadia.yml.tpl ./arcadia.yml
kubectl apply -f ./arcadia.yml
kubectl get svc
nginx_ingress=$(kubectl get svc nginx-ingress --namespace=nginx-ingress -o json | jq -r .status.loadBalancer.ingress[0].ip)
# deploy ingress
cat << EOF | kubectl apply -f -
apiVersion: k8s.nginx.org/v1
kind: VirtualServer
metadata:
  name: arcadia
spec:
  host: $nginx_ingress
  upstreams:
  - name: arcadia-main
    service: arcadia-main
    port: 80
  - name: arcadia-app2
    service: arcadia-app2
    port: 80
  - name: arcadia-app3
    service: arcadia-app3
    port: 80
  routes:
  - path: /
    action:
      pass: arcadia-main
  - path: /app2
    action:
      pass: arcadia-app2
  - path: /app3
    action:
      pass: arcadia-app3
EOF
# done
dashboard_nginx_ingress=$(kubectl get svc dashboard-nginx-ingress --namespace=nginx-ingress -o json | jq -r .status.loadBalancer.ingress[0].ip)
echo "dashboard:"
echo "http://$dashboard_nginx_ingress/dashboard.html"
echo "app:"
echo "http://$nginx_ingress/"
echo "====Done===="
}
