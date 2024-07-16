-- +goose Up
-- +goose StatementBegin
CREATE TABLE
    gallleries (
        id SERIAL PRIMARY KEY,
        user_id INT REFERENCES users (id),
        title TEXT
    );

-- +goose StatementEnd
-- +goose Down
-- +goose StatementBegin
DROP TABLE galleries;

-- +goose StatementEnd