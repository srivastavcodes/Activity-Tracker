CREATE TABLE IF NOT EXISTS book
(
    book_id        BINARY(16) PRIMARY KEY                                          NOT NULL,
    created_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP                             NOT NULL,
    updated_at     TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP NOT NULL,
    name           VARCHAR(255)                                                    NOT NULL,
    author         VARCHAR(255),
    published_date DATE,
    status         ENUM ('Complete', 'Reading', 'Paused', 'Maybe', 'LiteralTrash'),
    total_pages    SMALLINT UNSIGNED                                               NOT NULL,
    pages_read     SMALLINT UNSIGNED                                               NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS book_genres
(
    book_id BINARY(16)   NOT NULL,
    genre   VARCHAR(100) NOT NULL,
    PRIMARY KEY (book_id, genre),
    FOREIGN KEY (book_id) REFERENCES book (book_id) ON DELETE CASCADE
);

CREATE INDEX idx_book_name ON book (name);

CREATE INDEX idx_book_status ON book (status);

CREATE INDEX idx_book_genre ON book_genres (genre);
