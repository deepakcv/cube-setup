-- Slowly-changing dimension (SCD type 2 lite) for product cost.
-- Exactly one row per product has effective_to = NULL (the current cost).
CREATE TABLE IF NOT EXISTS product_costs (
    product_cost_id BIGSERIAL      PRIMARY KEY,
    product_id      BIGINT         NOT NULL,
    unit_cost       NUMERIC(12, 2) NOT NULL,
    effective_from  DATE           NOT NULL,
    effective_to    DATE,
    created_at      TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    CONSTRAINT product_costs_product_fk
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT product_costs_unit_cost_non_negative CHECK (unit_cost >= 0),
    CONSTRAINT product_costs_window_valid           CHECK (effective_to IS NULL OR effective_to >= effective_from)
);

-- Enforce "one current cost per product" without locking out historical rows.
CREATE UNIQUE INDEX IF NOT EXISTS uq_product_costs_current
    ON product_costs (product_id)
    WHERE effective_to IS NULL;

CREATE INDEX IF NOT EXISTS idx_product_costs_product_id     ON product_costs(product_id);
CREATE INDEX IF NOT EXISTS idx_product_costs_effective_from ON product_costs(effective_from);

COMMENT ON TABLE product_costs IS
    'History of product unit costs. The row with effective_to IS NULL is the current cost.';
