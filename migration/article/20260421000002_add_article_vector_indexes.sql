-- +goose Up
-- +goose StatementBegin
ALTER TABLE articles ADD COLUMN IF NOT EXISTS title_embedding VECTOR(1536);
ALTER TABLE articles ADD COLUMN IF NOT EXISTS body_embedding VECTOR(1536);
CREATE VECTOR INDEX IF NOT EXISTS idx_articles_title_embedding ON articles (title_embedding) WITH (min_partition_size = 16, max_partition_size = 512);
CREATE VECTOR INDEX IF NOT EXISTS idx_articles_body_embedding ON articles (body_embedding) WITH (min_partition_size = 16, max_partition_size = 512);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS idx_articles_body_embedding;
DROP INDEX IF EXISTS idx_articles_title_embedding;
ALTER TABLE articles DROP COLUMN IF EXISTS body_embedding;
ALTER TABLE articles DROP COLUMN IF EXISTS title_embedding;
-- +goose StatementEnd
