-- Fact table: one row per line-item sold. We snapshot unit_price and unit_cost
-- so historical reporting stays correct even when catalog prices change later.
-- total_amount is GENERATED to eliminate update anomalies.
CREATE TABLE IF NOT EXISTS sales (
    sale_id         BIGSERIAL      PRIMARY KEY,
    sale_date       TIMESTAMPTZ    NOT NULL,
    salesman_id     BIGINT         NOT NULL,
    product_id      BIGINT         NOT NULL,
    quantity        INTEGER        NOT NULL,
    unit_price      NUMERIC(12, 2) NOT NULL,
    unit_cost       NUMERIC(12, 2) NOT NULL,
    discount_amount NUMERIC(12, 2) NOT NULL DEFAULT 0,
    total_amount    NUMERIC(14, 2) GENERATED ALWAYS AS
                        (quantity * unit_price - discount_amount) STORED,
    created_at      TIMESTAMPTZ    NOT NULL DEFAULT NOW(),
    CONSTRAINT sales_salesman_fk
        FOREIGN KEY (salesman_id) REFERENCES salesmen(salesman_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT sales_product_fk
        FOREIGN KEY (product_id) REFERENCES products(product_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT sales_quantity_positive        CHECK (quantity > 0),
    CONSTRAINT sales_unit_price_non_negative  CHECK (unit_price >= 0),
    CONSTRAINT sales_unit_cost_non_negative   CHECK (unit_cost  >= 0),
    CONSTRAINT sales_discount_non_negative    CHECK (discount_amount >= 0),
    CONSTRAINT sales_discount_lte_gross       CHECK (discount_amount <= quantity * unit_price)
);

-- Indexes tuned for the typical analytical access patterns.
CREATE INDEX IF NOT EXISTS idx_sales_sale_date              ON sales(sale_date);
CREATE INDEX IF NOT EXISTS idx_sales_salesman_id            ON sales(salesman_id);
CREATE INDEX IF NOT EXISTS idx_sales_product_id             ON sales(product_id);
CREATE INDEX IF NOT EXISTS idx_sales_sale_date_salesman     ON sales(sale_date, salesman_id);
CREATE INDEX IF NOT EXISTS idx_sales_sale_date_product      ON sales(sale_date, product_id);

COMMENT ON TABLE  sales IS 'Line-item granularity sales fact table.';
COMMENT ON COLUMN sales.total_amount IS 'Computed: quantity * unit_price - discount_amount.';
