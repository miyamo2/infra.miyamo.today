# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository purpose

Infrastructure-as-Code for `miyamo.today` — a personal blog platform backed by a home-run Kubernetes cluster plus AWS-hosted event/storage services. Despite living under `go/src/...`, this repo contains **no Go code**: only Terraform (`terraform/`) and goose SQL migrations (`migration/`).

Application services live in a separate repo; this repo only provisions infra + secrets.

For Terraform-specific module layout, providers, variables, and invocation caveats, see `terraform/CLAUDE.md`.

## Task runner: xc

Common tasks are declared as fenced code blocks under `## Tasks` in `README.md` and run via [`xc`](https://github.com/joerdav/xc) (e.g. `xc tf:plan`, `xc migrate:article`). When adding a new workflow, add it there — don't create scripts elsewhere. Env vars and inputs are declared inline in each task block and are what `xc` feeds to the shell.

Key tasks: `tf:init` / `tf:fmt` / `tf:plan` / `tf:apply`, `migrate:enable-client-secure`, `migrate:user-and-db`, `migrate:article`, `migrate:tag`.

## Migrations

SQL migrations live under `migration/` (two independent CockroachDB databases: `article` and `tag`). See `migration/CLAUDE.md` for the apply flow, port-forward gotchas, file-naming rules, and migration-authoring notes before touching anything there.

## CI

`.github/workflows/validate_iac.yaml` runs `terraform init` + `terraform validate` on branches prefixed `feat/`, `refactor/`, `bugfix/`, `hotfix/`, and on PRs to `main`. No `terraform plan`/`apply` in CI — all applies are operator-driven via `xc`.
