# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Scope

goose SQL migrations for the `article` and `tag` CockroachDB databases. See `../CLAUDE.md` for repo-wide context (xc, Terraform, CI).

## Versions

- CockroachDB `v25.3.2` (image pinned in `client-secure.yaml`)
- `goose` driver: `postgres` (CockroachDB speaks the Postgres wire protocol)
- TLS is disabled cluster-side (`terraform/modules/k8s/cockroachdb`), so `GOOSE_DBSTRING` uses `sslmode=disable`

## Layout

Two databases, each with its own migration directory and independent `goose_db_version` table:

- `article/` — `articles`, `tags` (article-scoped tag rows)
- `tag/` — the read-model tag table

Sets are versioned independently; `goose up` in one directory does not affect the other.

## Apply flow

Migrations run from the host through `goose` → `kubectl port-forward` → `cockroachdb-public` service inside the cluster. The wrapper tasks live in the root `README.md`; run them via `xc`:

1. `xc migrate:enable-client-secure` — applies `client-secure.yaml` and waits for the pod (only needed for `user-and-db`; not required by `migrate:article`/`migrate:tag`)
2. `xc migrate:user-and-db` — creates `goose_user`, the two databases, and grants (idempotent)
3. `xc migrate:article` / `xc migrate:tag` — starts `kubectl port-forward service/cockroachdb-public 26257:26257 &`, then runs `goose up -dir ./`

Required ordering on a fresh environment: `enable-client-secure` → `user-and-db` → `article` / `tag`. Only `migrate:user-and-db` declares its prerequisite via `Required:` in `README.md`; the per-DB tasks assume step 2 has already been done.

`GOOSE_DBSTRING` targets `localhost:26257` precisely because of the port-forward — do not try to connect directly to CockroachDB from outside the cluster.

**Port-forward cleanup:** the `&` backgrounds `kubectl port-forward` but the task does not reap it. After `goose up` completes, kill the lingering process manually (e.g. `pkill -f "port-forward service/cockroachdb-public"`) before running the other DB's migration, otherwise the second `port-forward` will fight for port `26257`.

## Adding a new migration

Generate files with `goose create <name> sql` so they get a `YYYYMMDDHHMMSS_<name>.sql` prefix. The legacy `001_create_table.sql` in each directory predates that convention — do **not** imitate its sequential numbering for new migrations.

Authoring rules:

- Every file needs both `-- +goose Up` and `-- +goose Down` sections.
- Wrap multi-statement DDL in `-- +goose StatementBegin` / `-- +goose StatementEnd` (see `001_create_table.sql`).
- DDL that cannot run inside a transaction (e.g. `SET CLUSTER SETTING`, `SET enable_experimental_*`) must be prefixed with `-- +goose NO TRANSACTION` at the top of the file. See `20251018062804_enable_temp_table.sql` and `20251018123049_multiple_modification_subqueries.sql` for examples.
- When a later migration depends on a cluster setting, enable it in its own migration first (the `enable_temp_table` / `multiple_modification_subqueries` migrations exist for this reason).

## client-secure.yaml

Vendored from the CockroachDB Helm chart templates; the file banner says "Generated, do not edit." If the CockroachDB image tag needs to move, regenerate from the chart rather than hand-editing, and keep the `namespace: blog` / `serviceAccountName: cockroachdb` values — the xc tasks rely on them.
