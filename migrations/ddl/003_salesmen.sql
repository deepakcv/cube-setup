-- Salesmen working in a department. Soft-delete via is_active rather than DELETE
-- to preserve referential integrity with historical sales.
CREATE TABLE IF NOT EXISTS salesmen (
    salesman_id     BIGSERIAL    PRIMARY KEY,
    first_name      VARCHAR(80)  NOT NULL,
    last_name       VARCHAR(80)  NOT NULL,
    email           CITEXT       NOT NULL,
    phone           VARCHAR(32),
    department_id   BIGINT       NOT NULL,
    hired_at        DATE         NOT NULL,
    is_active       BOOLEAN      NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT salesmen_email_unique UNIQUE (email),
    CONSTRAINT salesmen_department_fk
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT salesmen_first_name_not_blank CHECK (length(btrim(first_name)) > 0),
    CONSTRAINT salesmen_last_name_not_blank  CHECK (length(btrim(last_name))  > 0)
);

CREATE INDEX IF NOT EXISTS idx_salesmen_department_id ON salesmen(department_id);
CREATE INDEX IF NOT EXISTS idx_salesmen_is_active     ON salesmen(is_active);

COMMENT ON TABLE salesmen IS 'Sales associates assigned to a department.';
