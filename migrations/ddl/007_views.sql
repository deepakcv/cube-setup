-- Convenience views for ad-hoc SQL exploration. Cube does not depend on these;
-- it composes its own SQL from the data model. Drop them safely if undesired.

CREATE OR REPLACE VIEW vw_daily_sales AS
SELECT
    DATE_TRUNC('day', s.sale_date)::date          AS sale_day,
    s.salesman_id,
    sm.department_id                              AS salesman_department_id,
    s.product_id,
    p.department_id                               AS product_department_id,
    SUM(s.quantity)                               AS units_sold,
    SUM(s.total_amount)                           AS gross_revenue,
    SUM(s.discount_amount)                        AS total_discount,
    SUM(s.quantity * s.unit_cost)                 AS total_cost,
    SUM(s.total_amount - s.quantity * s.unit_cost) AS gross_profit,
    COUNT(*)                                      AS line_item_count
FROM sales        s
JOIN salesmen     sm ON sm.salesman_id  = s.salesman_id
JOIN products     p  ON p.product_id    = s.product_id
GROUP BY 1, 2, 3, 4, 5;

COMMENT ON VIEW vw_daily_sales IS
    'Pre-aggregated daily slice intended for quick spot checks; production analytics flow through Cube.';
