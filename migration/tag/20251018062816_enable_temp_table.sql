-- +goose NO TRANSACTION
-- +goose Up
SET CLUSTER SETTING enable_experimental_alter_column_type_general = on;

-- +goose Down
SET CLUSTER SETTING enable_experimental_alter_column_type_general = on;
