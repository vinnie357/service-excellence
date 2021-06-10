function deploy_nsm {
# requires
# nginx-meshctl
# example:
# deploy_nsm 1.0.0
version=${1:-"1.0.0"}
nginx-meshctl deploy --registry-server docker-registry.nginx.com/nsm --image-tag ${version}
}
