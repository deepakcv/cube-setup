-- Current cost ~ 60-70% of retail. A few products carry a historical cost row
-- to demonstrate cost-over-time tracking (effective_to set to a past date).

-- Closed (historical) cost rows for a couple of products.
INSERT INTO product_costs (product_id, unit_cost, effective_from, effective_to) VALUES
    ( 1,  72.00, DATE '2024-01-01', DATE '2025-06-30'),
    ( 3, 140.00, DATE '2024-01-01', DATE '2025-09-30'),
    (14,  74.00, DATE '2024-01-01', DATE '2025-04-30');

-- Current cost rows (effective_to IS NULL) for every product.
INSERT INTO product_costs (product_id, unit_cost, effective_from, effective_to) VALUES
    ( 1,  78.00, DATE '2025-07-01', NULL),
    ( 2,  53.70, DATE '2025-01-01', NULL),
    ( 3, 155.00, DATE '2025-10-01', NULL),
    ( 4,  23.99, DATE '2025-01-01', NULL),
    ( 5,  35.97, DATE '2025-01-01', NULL),
    ( 6,   8.99, DATE '2025-01-01', NULL),
    ( 7,  27.00, DATE '2025-01-01', NULL),
    ( 8,  47.70, DATE '2025-01-01', NULL),
    ( 9,  41.99, DATE '2025-01-01', NULL),
    (10,  14.99, DATE '2025-01-01', NULL),
    (11,  13.50, DATE '2025-01-01', NULL),
    (12,  39.00, DATE '2025-01-01', NULL),
    (13,  20.97, DATE '2025-01-01', NULL),
    (14,  82.00, DATE '2025-05-01', NULL),
    (15,  11.25, DATE '2025-01-01', NULL),
    (16,   8.70, DATE '2025-01-01', NULL),
    (17,   7.19, DATE '2025-01-01', NULL),
    (18,   5.39, DATE '2025-01-01', NULL),
    (19,   4.50, DATE '2025-01-01', NULL),
    (20,   7.35, DATE '2025-01-01', NULL),
    (21,  17.99, DATE '2025-01-01', NULL),
    (22,  27.00, DATE '2025-01-01', NULL),
    (23,  53.97, DATE '2025-01-01', NULL),
    (24,  71.40, DATE '2025-01-01', NULL),
    (25,  32.70, DATE '2025-01-01', NULL);
