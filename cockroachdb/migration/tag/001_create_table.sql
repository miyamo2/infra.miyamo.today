-- +goose Up
-- +goose StatementBegin
CREATE TABLE IF NOT EXISTS tags (
    id VARCHAR(144),
    name VARCHAR(35) NOT NULL,
    created_at timestamp WITHOUT TIME ZONE NOT NULL,
    updated_at timestamp WITHOUT TIME ZONE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS articles (
    id VARCHAR(26),
    tag_id VARCHAR(144),
    title VARCHAR(255) NOT NULL,
	thumbnail VARCHAR(524271),
	created_at timestamp WITHOUT TIME ZONE NOT NULL,
	updated_at timestamp WITHOUT TIME ZONE NOT NULL,
    FOREIGN KEY (tag_id) REFERENCES tags(id),
    PRIMARY KEY (id, tag_id)
);

CREATE INDEX IF NOT EXISTS idx_articles_tag_id_idx ON articles (tag_id);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP INDEX IF EXISTS idx_articles_tag_id_idx;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS tags;
-- +goose StatementEnd
