# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Scope

Terraform root module + submodules for `miyamo.today` infra. See `../CLAUDE.md` for repo-wide context (xc, migrations, CI).

## Versions

- Terraform `>= 1.11.0`
- Providers pinned in `main.tf`: `aws 5.87.0`, `kubernetes 2.31.0`, `helm 2.14.0`
- AWS region: `ap-northeast-1`

## Layout

Single root module at `terraform/` composes everything in `main.tf`. Modules under `modules/` split by provider:

- `aws/dynamodb` — `blogging_events-<env>` table, streams enabled (`NEW_AND_OLD_IMAGES`)
- `aws/sqs` — `blogging_event_queue-<env>` + dead-letter queue
- `aws/eventbridge` — EventBridge **Pipes** wiring DynamoDB Streams → SQS, filtered to `INSERT` events only
- `aws/iam`, `aws/s3` (images bucket), `aws/cognito` (user pool for federator auth)
- `k8s/cockroachdb` — deploys CockroachDB via Helm chart (`cockroachdb/cockroachdb`) with TLS **disabled** and Longhorn-backed PVs
- `k8s/secret` — creates `kubernetes_secret` resources consumed by the app deployments (`article-service`, `tag-service`, `blogging-event-service`, `federator`, `read-model-updater`)

## Backend & invocation

Backend is S3 (`ap-northeast-1`); `bucket` and `key` are supplied only at `init` time via `-backend-config`. `tfvars.json` is gitignored (sensitive).

**Caveat:** `tf:init` runs from the repo root, while `tf:fmt` / `tf:plan` / `tf:apply` all `cd ./terraform` first. When invoking `terraform init` manually, stay at the repo root — do not `cd ./terraform` for it.

## Variables

Sensitive keys live in `tfvars.json`. Required values include: `kubeconfig_context`, `kubernetes_namespace`, `gh_token`, `cdn_host`, `blog_publish_endpoint`, `s3_bucket_for_images`, `new_relic_config_license_key`, `new_relic_config_app_name_*` (5 variants — articles / tags / blogging_event / federator / read_model_updater).

Defaults worth knowing: `environment=dev`, `kubeconfig_path=~/.kube/config`, `cockroach_sql_user_name=maxroach`.

## Secret-rollout contract

`k8s/secret` pairs each `kubernetes_secret` with a `terraform_data` trigger that runs `kubectl rollout restart` via `local-exec` whenever secret data changes, so the matching deployment picks up new values without a manual restart. Keep this contract intact when adding new secrets.
