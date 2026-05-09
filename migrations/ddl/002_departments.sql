-- Departments (a.k.a. categories) under which products and salesmen are grouped.
CREATE TABLE IF NOT EXISTS departments (
    department_id   BIGSERIAL    PRIMARY KEY,
    name            VARCHAR(80)  NOT NULL,
    description     VARCHAR(500),
    created_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ  NOT NULL DEFAULT NOW(),
    CONSTRAINT departments_name_unique UNIQUE (name),
    CONSTRAINT departments_name_not_blank CHECK (length(btrim(name)) > 0)
);

COMMENT ON TABLE  departments IS 'Top-level merchandising / staffing groups.';
COMMENT ON COLUMN departments.name IS 'Human readable, unique label for the department.';
