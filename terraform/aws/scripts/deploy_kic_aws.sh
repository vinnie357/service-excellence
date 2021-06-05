function deploy_kic_aws {
  version=${1:-"1.9.0"}
  clusterName=${2:-"services-gke"}
  secretName=${3:-"services-nginx-secret"}
  dir=${PWD}
  aws ecr get-login-password --region us-west-2 | docker login --username AWS --password-stdin ecrRepositoryURL
  aws eks --region us-west-2 update-kubeconfig --name kubernetesClusterName
  aws ec2 create-tags \
   --resources publicSubnetAZ1 publicSubnetAZ2 \
   --tags Key=kubernetes.io/cluster/kubernetesClusterName,Value=shared   Key=kubernetes.io/role/elb,Value=1
   git clone https://github.com/nginxinc/kubernetes-ingress.git
  cd kubernetes-ingress
  git checkout tags/v${version}

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

make DOCKERFILE=DockerfileForPlus PREFIX=RegistryURL

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

# deploy kic and dashboard
kubectl apply -f ./nginx-ingress-install.yml
# add dashboard
kubectl apply -f ./nginx-ingress-dashboard.yml

kubectl -n nginx-ingress get pods -o wide
kubectl get svc --namespace=nginx-ingress
export dashboard_nginx_ingress=$(kubectl get svc dashboard-nginx-ingress --namespace=nginx-ingress | tr -s " " | cut -d' ' -f4 | grep -v "EXTERNAL-IP")
export nginx_ingress=$(kubectl get svc nginx-ingress --namespace=nginx-ingress | tr -s " " | cut -d' ' -f4 | grep -v "EXTERNAL-IP")

}
