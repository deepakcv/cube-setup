INSERT INTO salesmen (salesman_id, first_name, last_name, email, phone, department_id, hired_at, is_active) VALUES
    (1, 'Aarav',  'Sharma',  'aarav.sharma@retail.local',  '+91-90000-00001', 1, DATE '2022-04-12', TRUE),
    (2, 'Diya',   'Patel',   'diya.patel@retail.local',    '+91-90000-00002', 1, DATE '2023-01-05', TRUE),
    (3, 'Vikram', 'Iyer',    'vikram.iyer@retail.local',   '+91-90000-00003', 2, DATE '2021-09-30', TRUE),
    (4, 'Priya',  'Singh',   'priya.singh@retail.local',   '+91-90000-00004', 2, DATE '2022-11-18', TRUE),
    (5, 'Rohan',  'Mehta',   'rohan.mehta@retail.local',   '+91-90000-00005', 3, DATE '2023-06-01', TRUE),
    (6, 'Anika',  'Rao',     'anika.rao@retail.local',     '+91-90000-00006', 4, DATE '2021-02-15', TRUE),
    (7, 'Karan',  'Joshi',   'karan.joshi@retail.local',   '+91-90000-00007', 4, DATE '2024-03-22', TRUE),
    (8, 'Meera',  'Nair',    'meera.nair@retail.local',    '+91-90000-00008', 5, DATE '2023-08-10', TRUE)
ON CONFLICT (salesman_id) DO NOTHING;

SELECT setval(
    pg_get_serial_sequence('salesmen', 'salesman_id'),
    (SELECT MAX(salesman_id) FROM salesmen)
);
