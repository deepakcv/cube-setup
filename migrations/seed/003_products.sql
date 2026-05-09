INSERT INTO products (product_id, sku, name, description, department_id, unit_price, is_active) VALUES
    -- Electronics
    ( 1, 'ELEC-001', 'Wireless Earbuds Pro', 'Active noise cancelling earbuds',          1, 129.99, TRUE),
    ( 2, 'ELEC-002', 'Smart Home Hub',       'Voice-controlled smart home hub',          1,  89.50, TRUE),
    ( 3, 'ELEC-003', '4K Action Camera',     'Waterproof 4K action camera',              1, 249.00, TRUE),
    ( 4, 'ELEC-004', 'USB-C Charging Dock',  '7-in-1 USB-C dock with PD',                1,  39.99, TRUE),
    ( 5, 'ELEC-005', 'Bluetooth Speaker',    'Portable IPX7 bluetooth speaker',          1,  59.95, TRUE),
    -- Apparel
    ( 6, 'APP-001',  'Cotton T-Shirt',       'Premium combed-cotton t-shirt',            2,  14.99, TRUE),
    ( 7, 'APP-002',  'Slim Fit Jeans',       'Stretch denim slim fit jeans',             2,  45.00, TRUE),
    ( 8, 'APP-003',  'Running Sneakers',     'Lightweight running sneakers',             2,  79.50, TRUE),
    ( 9, 'APP-004',  'Wool Sweater',         'Merino wool crew-neck sweater',            2,  69.99, TRUE),
    (10, 'APP-005',  'Leather Belt',         'Full-grain leather belt',                  2,  24.99, TRUE),
    -- Home & Garden
    (11, 'HOME-001', 'Ceramic Mug Set',      'Set of 4 ceramic mugs',                    3,  22.50, TRUE),
    (12, 'HOME-002', 'LED Floor Lamp',       'Adjustable LED floor lamp',                3,  65.00, TRUE),
    (13, 'HOME-003', 'Garden Hose 50ft',     'Expandable garden hose 50ft',              3,  34.95, TRUE),
    (14, 'HOME-004', 'Cookware Set 5pc',     'Non-stick cookware set, 5 pieces',         3, 129.00, TRUE),
    (15, 'HOME-005', 'Indoor Plant Pot',     'Self-watering indoor plant pot',           3,  18.75, TRUE),
    -- Groceries
    (16, 'GROC-001', 'Organic Coffee 1lb',   'Single-origin organic coffee, 1lb',        4,  14.50, TRUE),
    (17, 'GROC-002', 'Olive Oil 500ml',      'Extra virgin olive oil, 500ml',            4,  11.99, TRUE),
    (18, 'GROC-003', 'Chocolate Box',        'Assorted dark chocolate box',              4,   8.99, TRUE),
    (19, 'GROC-004', 'Honey 250g',           'Raw multi-flora honey, 250g',              4,   7.50, TRUE),
    (20, 'GROC-005', 'Tea Variety Pack',     '40-bag tea variety pack',                  4,  12.25, TRUE),
    -- Sports & Outdoors
    (21, 'SPORT-001','Yoga Mat',             'Eco-friendly yoga mat, 6mm',               5,  29.99, TRUE),
    (22, 'SPORT-002','Dumbbells 10kg',       'Pair of rubber-coated dumbbells, 10kg',    5,  45.00, TRUE),
    (23, 'SPORT-003','Trail Running Shoes',  'Trail running shoes with grip sole',       5,  89.95, TRUE),
    (24, 'SPORT-004','Tennis Racket',        'Graphite frame tennis racket',             5, 119.00, TRUE),
    (25, 'SPORT-005','Backpack 30L',         'Waterproof daypack, 30L',                  5,  54.50, TRUE)
ON CONFLICT (product_id) DO NOTHING;

SELECT setval(
    pg_get_serial_sequence('products', 'product_id'),
    (SELECT MAX(product_id) FROM products)
);
