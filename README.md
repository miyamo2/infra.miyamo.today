# infra.miyamo.today

Cloud infrastructure for `miyamo.today`.

## Prerequirements

1. Prepare Kubernetes Cluster
2. Install ArgoCD on Cluster
3. Install Cloudflare Tunnel Ingress Controller on Cluster
4. Install longhorn on Cluster
5. Create namespace, user, role and rolebinding on Cluster
6. Install kubectl on your machine
7. Install xc on your machine
8. Install goose on your machine

## Setup

```sh
scp <username>@<kubernetes server>:<path to cluster certificate authority data> ./
scp <username>@<kubernetes server>:<path to certificate certificated by the csr signer> ./
scp <username>@<kubernetes server>:<path to public key> ./

kubectl config set-cluster <any-cluster-name> --server=https://<kubernetes server ip>:6443 --certificate-authority=<path to cluster certificate authority data> --embed-certs=true
kubectl config set-credentials <any-user-name> --client-key=<path to public key> --client-certificate=<path to certificate certificated by the csr signer> --embed-certs=true
kubectl config set-context <any-context-name> --cluster=<any-cluster-name> --namespace=<namespace> --user=<user-name>
```

## Tasks

We recommend that this section be run with [xc](https://github.com/joerdav/xc)

### tf:init

Inputs: BUCKET_NAME,STATE_KEY

```sh
terraform init -backend-config="bucket=$BUCKET_NAME" -backend-config="key=$STATE_KEY/terraform.tfstate" -upgrade
```

### tf:fmt

```sh
cd ./terraform
terraform fmt --recursive
```

### tf:plan

```sh
cd ./terraform
terraform plan \
-var-file=tfvars.json
```

### tf:apply

```sh
cd ./terraform
terraform apply \
-var-file=tfvars.json \
-auto-approve
```

### 

### migrate:user-and-db

Inputs: KUBE_CONTEXT, KUBE_NAMESPACE
Env: KUBE_NAMESPACE=blog
Env: KUBE_CONTEXT=blogapi-miyamo-today

```sh
kubectl apply --context $KUBE_CONTEXT -n $KUBE_NAMESPACE -f ./migration/client-secure.yaml
kubectl exec --context $KUBE_CONTEXT -n $KUBE_NAMESPACE -it cockroachdb-client-secure -- ./cockroach sql --host=cockroachdb-public --insecure \
-e "CREATE USER IF NOT EXISTS goose_user WITH MODIFYCLUSTERSETTING;" \
-e "CREATE USER IF NOT EXISTS miyamo2;" \
-e "CREATE DATABASE IF NOT EXISTS article;" \
-e "CREATE DATABASE IF NOT EXISTS tag;" \
-e "GRANT ALL ON DATABASE article TO goose_user WITH GRANT OPTION;" \
-e "GRANT ALL ON DATABASE tag TO goose_user WITH GRANT OPTION;" 
```

### migrate:port-forward

Inputs: KUBE_CONTEXT, KUBE_NAMESPACE
Env: KUBE_NAMESPACE=blog
Env: KUBE_CONTEXT=blogapi-miyamo-today

```sh 
nohup kubectl port-forward service/cockroachdb-public 26257:26257 --context $KUBE_CONTEXT -n $KUBE_NAMESPACE &
```

### migrate:article

Inputs: KUBE_CONTEXT, KUBE_NAMESPACE, GOOSE_DRIVER, GOOSE_DBSTRING
Env: KUBE_NAMESPACE=blog
Env: KUBE_CONTEXT=blogapi-miyamo-today
Env: GOOSE_DRIVER=postgres
Env: GOOSE_DBSTRING=postgresql://goose_user@localhost:26257/article?sslmode=disable

```sh
nohup kubectl port-forward service/cockroachdb-public 26257:26257 --context $KUBE_CONTEXT -n $KUBE_NAMESPACE &
cd ./migration/article
goose up -dir ./
```

### migrate:tag

Inputs: KUBE_CONTEXT, KUBE_NAMESPACE, GOOSE_DRIVER, GOOSE_DBSTRING
Env: KUBE_NAMESPACE=blog
Env: KUBE_CONTEXT=blogapi-miyamo-today
Env: GOOSE_DRIVER=postgres
Env: GOOSE_DBSTRING=postgresql://goose_user@localhost:26257/tag?sslmode=disable

```sh
nohup kubectl port-forward service/cockroachdb-public 26257:26257 --context=$KUBE_CONTEXT -n $KUBE_NAMESPACE &
cd ./migration/tag
goose up -dir ./
```