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
    title VARCHAR(255) NOT NULL,
	thumbnail VARCHAR(524271),
	created_at timestamp WITHOUT TIME ZONE NOT NULL,
	updated_at timestamp WITHOUT TIME ZONE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS tag_article_categoraization (
    tag_id VARCHAR(144),
    article_id VARCHAR(26),
    created_at timestamp WITHOUT TIME ZONE NOT NULL,
    updated_at timestamp WITHOUT TIME ZONE NOT NULL,
    FOREIGN KEY (tag_id) REFERENCES tags(id),
    FOREIGN KEY (article_id) REFERENCES articles(id),
    PRIMARY KEY (tag_id, article_id)
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS tag_article_categoraization;
DROP TABLE IF EXISTS articles;
DROP TABLE IF EXISTS tags;
-- +goose StatementEnd
