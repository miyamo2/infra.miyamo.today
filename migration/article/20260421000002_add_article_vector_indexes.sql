-- +goose Up
-- +goose StatementBegin
ALTER TABLE articles ADD COLUMN IF NOT EXISTS embedding VECTOR(1536);
CREATE VECTOR INDEX IF NOT EXISTS idx_articles_embedding ON articles (embedding) WITH (min_partition_size = 16, max_partition_size = 512);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS idx_articles_embedding;
ALTER TABLE articles DROP COLUMN IF EXISTS embedding;
-- +goose StatementEnd
