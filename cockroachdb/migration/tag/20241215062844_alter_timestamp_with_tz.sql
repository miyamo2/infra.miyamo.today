-- +goose Up
-- +goose StatementBegin
SET enable_experimental_alter_column_type_general = true;

ALTER TABLE articles
    ALTER COLUMN created_at SET DATA TYPE TIMESTAMP WITH TIME ZONE USING created_at AT TIME ZONE 'UTC';

ALTER TABLE articles
    ALTER COLUMN updated_at SET DATA TYPE TIMESTAMP WITH TIME ZONE USING updated_at AT TIME ZONE 'UTC';

ALTER TABLE tags
    ALTER COLUMN created_at SET DATA TYPE TIMESTAMP WITH TIME ZONE USING created_at AT TIME ZONE 'UTC';

ALTER TABLE tags
    ALTER COLUMN updated_at SET DATA TYPE TIMESTAMP WITH TIME ZONE USING updated_at AT TIME ZONE 'UTC';
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
SET enable_experimental_alter_column_type_general = true;

ALTER TABLE articles
    ALTER COLUMN created_at SET DATA TYPE TIMESTAMP WITHOUT TIME ZONE;

ALTER TABLE articles
    ALTER COLUMN updated_at SET DATA TYPE TIMESTAMP WITHOUT TIME ZONE;

ALTER TABLE tags
    ALTER COLUMN created_at SET DATA TYPE TIMESTAMP WITHOUT TIME ZONE;

ALTER TABLE tags
    ALTER COLUMN updated_at SET DATA TYPE TIMESTAMP WITHOUT TIME ZONE;
-- +goose StatementEnd
