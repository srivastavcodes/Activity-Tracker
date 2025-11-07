ALTER TABLE book
    ADD CONSTRAINT chk_updated_at CHECK ( updated_at >= created_at );

ALTER TABLE book
    ADD CONSTRAINT chk_total_pages CHECK ( total_pages >= pages_read );
