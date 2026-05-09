-- Generate ~600 line-item sales spread across the last 90 days so the analytics
-- layer has enough breadth for daily / weekly / monthly aggregations.
--
-- The output is deterministic across runs because we seed the RNG.
SELECT setseed(0.42);

INSERT INTO sales (sale_date, salesman_id, product_id, quantity, unit_price, unit_cost, discount_amount)
SELECT
    -- Spread each ticket across realistic store hours (08:00 - 19:59).
    ((CURRENT_DATE - d.day_offset)::timestamp
        + (8 + floor(random() * 12))::int * INTERVAL '1 hour'
        + floor(random() * 60)::int       * INTERVAL '1 minute'
    ) AT TIME ZONE 'UTC'                                           AS sale_date,
    pick.salesman_id,
    pick.product_id,
    1 + floor(random() * 4)::int                                   AS quantity,
    pick.unit_price                                                AS unit_price,
    pick.unit_cost                                                 AS unit_cost,
    -- 15% of tickets carry a 10% line discount.
    CASE
        WHEN random() < 0.15
        THEN ROUND((pick.unit_price * 0.10)::numeric, 2)
        ELSE 0
    END                                                            AS discount_amount
FROM
    generate_series(0, 89)               AS d(day_offset),
    LATERAL generate_series(1, 4 + floor(random() * 6)::int) AS t(ticket),
    LATERAL (
        SELECT s.salesman_id, p.product_id, p.unit_price, pc.unit_cost
        FROM   products      p
        JOIN   product_costs pc
               ON pc.product_id = p.product_id
              AND pc.effective_to IS NULL
        JOIN   salesmen      s
               ON s.is_active
        ORDER BY random()
        LIMIT 1
    ) AS pick;

-- Quick sanity report so devs can spot empty seeds in container logs.
DO $$
DECLARE
    sale_count BIGINT;
    earliest   DATE;
    latest     DATE;
BEGIN
    SELECT COUNT(*), MIN(sale_date)::date, MAX(sale_date)::date
      INTO sale_count, earliest, latest
      FROM sales;
    RAISE NOTICE 'Seeded sales: % rows, range % to %', sale_count, earliest, latest;
END $$;
