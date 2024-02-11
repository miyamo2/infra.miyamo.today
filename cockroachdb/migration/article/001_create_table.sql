-- +goose Up
-- +goose StatementBegin
CREATE TABLE IF NOT EXISTS articles (
    id VARCHAR(26),
    title VARCHAR(255) NOT NULL,
	body VARCHAR(5000000) NOT NULL,
	thumbnail VARCHAR(524271),
	created_at timestamp WITHOUT TIME ZONE NOT NULL,
	updated_at timestamp WITHOUT TIME ZONE NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE IF NOT EXISTS tags (
    id VARCHAR(144),
    article_id VARCHAR(26),
    name VARCHAR(35) NOT NULL,
    created_at timestamp WITHOUT TIME ZONE NOT NULL,
    updated_at timestamp WITHOUT TIME ZONE NOT NULL,
    FOREIGN KEY (article_id) REFERENCES articles(id),
    PRIMARY KEY (id, article_id)
);
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
DROP TABLE IF EXISTS tags;
DROP TABLE IF EXISTS articles;
-- +goose StatementEnd
