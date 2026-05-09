INSERT INTO departments (department_id, name, description) VALUES
    (1, 'Electronics',     'Consumer electronics, audio, and accessories'),
    (2, 'Apparel',         'Clothing, footwear, and fashion accessories'),
    (3, 'Home & Garden',   'Home goods, decor, kitchenware, and gardening supplies'),
    (4, 'Groceries',       'Packaged food and beverages'),
    (5, 'Sports & Outdoors','Fitness, sports gear, and outdoor equipment')
ON CONFLICT (department_id) DO NOTHING;

-- Re-align the sequence after explicit ID inserts.
SELECT setval(
    pg_get_serial_sequence('departments', 'department_id'),
    (SELECT MAX(department_id) FROM departments)
);
