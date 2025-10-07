-- +goose Up
-- +goose StatementBegin
GRANT ALL ON TABLE articles TO miyamo2;
GRANT ALL ON TABLE tags TO miyamo2;
-- +goose StatementEnd

-- +goose Down
-- +goose StatementBegin
REVOKE ALL ON TABLE articles FROM miyamo2;
REVOKE ALL ON TABLE tags FROM miyamo2;
-- +goose StatementEnd
