# service-excellence
demos with k8s, nginx kic/service mesh , and hasicorp waypoint.

---

devcontainer includes:
- pre-commit
- go
- docker
- terraform
- terraform-docs
- waypoint cli
- gcloud cli
- aws cli
- azure cli
- kubectl
- helm

## running

  - [gcp](./terraform/gcp/readme.md)
  - [azure](./terraform/azure/readme.md)
  - [aws](./terraform/aws/readme.md)

## Development

don't forget to add your git user config

```bash
git config --global user.name "myuser"
git config --global user.email "myuser@domain.com"
```
---

checking for secrets as well as linting is performed by git pre-commit with the module requirements handled in the devcontainer.

testing pre-commit hooks:
  ```bash
  # test pre commit manually
  pre-commit run -a -v
  ```
---
