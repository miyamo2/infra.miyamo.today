-- +goose NO TRANSACTION
-- +goose Up
SET CLUSTER SETTING feature.vector_index.enabled = true;

-- +goose Down
SET CLUSTER SETTING feature.vector_index.enabled = false;
