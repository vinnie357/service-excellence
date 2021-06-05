function cleanup_gcp {
#!/bin/bash
echo "destroying demo service-excellence gcp"
read -r -p "Are you sure? [y/N] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
then
    terraform destroy --auto-approve
    rm ./nginx-ingress-install.yml
    rm ./nginx-ingress-dashboard.yml
    rm ./arcadia.yml
else
    echo "canceling"
fi
}
