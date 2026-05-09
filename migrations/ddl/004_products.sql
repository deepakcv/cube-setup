-- Catalog of products. unit_price is the *current* retail price; the historical
-- price actually charged is snapshot on the sales row to keep the fact immutable.
CREATE TABLE IF NOT EXISTS products (
    product_id      BIGSERIAL      PRIMARY KEY,
    sku             CITEXT         NOT NULL,
    name            VARCHAR(160)   NOT NULL,
    description     VARCHAR(500),
    department_id   BIGINT         NOT NULL,
    unit_price      NUMERIC(12, 2) NOT NULL,
    is_active       BOOLEAN        NOT NULL DEFAULT TRUE,
    created_at      TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    updated_at      TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    CONSTRAINT products_sku_unique UNIQUE (sku),
    CONSTRAINT products_department_fk
        FOREIGN KEY (department_id) REFERENCES departments(department_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT products_unit_price_non_negative CHECK (unit_price >= 0),
    CONSTRAINT products_name_not_blank          CHECK (length(btrim(name)) > 0)
);

CREATE INDEX IF NOT EXISTS idx_products_department_id ON products(department_id);
CREATE INDEX IF NOT EXISTS idx_products_is_active     ON products(is_active);

COMMENT ON TABLE products IS 'Catalog of sellable items.';
