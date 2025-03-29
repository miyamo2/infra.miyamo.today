# infra.miyamo.today

Cloud infrastructure for `miyamo.today`.

## Setup


### Install components

```sh 
gcloud components install gke-gcloud-auth-plugin
```

### Login

```sh
gcloud auth application-default login
```

### Create a new project

```sh
gcloud projects create <PROJECT_ID>
gcloud config set project <PROJECT_ID>
```

### Enable billing

#### see available billing account

```sh
gcloud billing accounts list
# output
ACCOUNT_ID: <BILLING_ACCOUNT_ID>
NAME: <BILLING_ACCOUNT_NAME>
OPEN: <TRUE|FALSE>
MASTER_ACCOUNT_ID: <MASTER_ACCOUNT_ID>
```

#### link billing account to the project

```sh
gcloud alpha billing projects link <PROJECT_ID> --billing-account="<BILLING_ACCOUNT_ID>"
```

#### enable api

```sh
gcloud services enable iam.googleapis.com container.googleapis.com compute.googleapis.com artifactregistry.googleapis.com 
```

### terraform init

```sh
terraform init -backend-config="bucket=<BUCKET_NAME>" -backend-config="key=<KEY>/terraform.tfstate"
```