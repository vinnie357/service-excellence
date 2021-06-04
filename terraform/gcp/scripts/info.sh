function info {
echo "==== info ===="
##vars
terraform output --json | jq .
}
