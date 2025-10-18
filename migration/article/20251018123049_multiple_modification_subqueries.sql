-- +goose NO TRANSACTION
-- +goose Up
SET CLUSTER SETTING sql.multiple_modifications_of_table.enabled = true;

-- +goose Down
SET CLUSTER SETTING sql.multiple_modifications_of_table.enabled = false;