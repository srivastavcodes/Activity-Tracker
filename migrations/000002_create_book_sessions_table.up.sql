CREATE TABLE IF NOT EXISTS book_sessions
(
    session_id   BINARY(16) PRIMARY KEY              NOT NULL,
    book_id      BINARY(16)                          NOT NULL,
    started_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    ended_at     TIMESTAMP                           NOT NULL,
    duration_min INT UNSIGNED                        NOT NULL,
    pages_read   SMALLINT UNSIGNED                   NOT NULL,
    note         TEXT,
    FOREIGN KEY (book_id) REFERENCES book (book_id) ON DELETE CASCADE
);

CREATE INDEX idx_book_sessions_book_id ON book_sessions (book_id);

CREATE INDEX idx_book_sessions_pages_read ON book_sessions (pages_read);
