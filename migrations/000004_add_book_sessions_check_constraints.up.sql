ALTER TABLE book_sessions
    ADD CONSTRAINT chk_ended_at CHECK ( ended_at > started_at );
