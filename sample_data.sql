-- ============================================================
-- Product Management Database - Sample Data
-- Reconstructed to match the outputs shown in the project
-- documentation (Product_Management_Database_Simple.pdf)
-- ============================================================

USE product_management_db;

-- categories
INSERT INTO categories (category_id, category_name, description) VALUES
(1, 'Electronics', 'Electronic gadgets and accessories'),
(2, 'Groceries', 'Everyday grocery items'),
(3, 'Stationery', 'Office and school stationery'),
(4, 'Furniture', 'Home and office furniture'),
(5, 'Clothing', 'Apparel for men and women');

-- suppliers
INSERT INTO suppliers (supplier_id, supplier_name, contact_person, phone, email, address) VALUES
(1, 'Tech World Pvt Ltd', 'Ankit Sharma', '9000000001', 'contact@techworld.example.com', 'Hyderabad, Telangana'),
(2, 'Fresh Basket Suppliers', 'Priya Menon', '9000000002', 'contact@freshbasket.example.com', 'Hyderabad, Telangana'),
(3, 'Office Mart', 'Suresh Kumar', '9000000003', 'contact@officemart.example.com', 'Hyderabad, Telangana'),
(4, 'Home Comfort Furnitures', 'Divya Rao', '9000000004', 'contact@homecomfort.example.com', 'Hyderabad, Telangana'),
(5, 'StyleHub Apparels', 'Karan Malhotra', '9000000005', 'contact@stylehub.example.com', 'Hyderabad, Telangana');

-- customers
INSERT INTO customers (customer_id, first_name, last_name, email, phone, city, registered_on) VALUES
(1, 'Moon', 'Sao', 'moon.sao@example.com', '8269630245', 'Hyderabad', '2026-01-01'),
(2, 'Rahul', 'Verma', 'rahul.verma@example.com', '9898900001', 'Pune', '2026-01-01'),
(3, 'Sneha', 'Reddy', 'sneha.reddy@example.com', '9898989898', 'Hyderabad', '2026-01-01'),
(4, 'Arjun', 'Nair', 'arjun.nair@example.com', '9898900002', 'Kochi', '2026-01-01'),
(5, 'Kavya', 'Iyer', 'kavya.iyer@example.com', '9898900003', 'Chennai', '2026-01-01');

-- products
INSERT INTO products (product_id, product_name, category_id, supplier_id, price, unit, created_at) VALUES
(1,  'Wireless Mouse',        1, 1, 499.00,  'pcs',    '2026-01-01'),
(2,  'Bluetooth Headphones',  1, 1, 1499.00, 'pcs',    '2026-01-01'),
(3,  'Basmati Rice 5kg',      2, 2, 650.00,  'bag',    '2026-01-01'),
(4,  'Sunflower Oil 1L',      2, 2, 150.00,  'bottle', '2026-01-01'),
(5,  'A4 Notebook',           3, 3, 60.00,   'pcs',    '2026-01-01'),
(6,  'Ballpoint Pen Pack',    3, 3, 40.00,   'pack',   '2026-01-01'),
(7,  'Office Chair',          4, 4, 4500.00, 'pcs',    '2026-01-01'),
(8,  'Study Table',           4, 4, 3200.00, 'pcs',    '2026-01-01'),
(9,  'Men Cotton T-Shirt',    5, 5, 399.00,  'pcs',    '2026-01-01'),
(10, 'Women Kurti',           5, 5, 799.00,  'pcs',    '2026-01-01');

-- inventory (all products above reorder level, matching the
-- "no low/out-of-stock rows" result in the documentation)
INSERT INTO inventory (product_id, quantity_in_stock, reorder_level) VALUES
(1, 40, 10),
(2, 25, 10),
(3, 60, 15),
(4, 55, 15),
(5, 100, 20),
(6, 90, 20),
(7, 15, 5),
(8, 20, 5),
(9, 70, 15),
(10, 50, 15);

-- orders
INSERT INTO orders (order_id, customer_id, order_date, status) VALUES
(1, 1, '2026-08-01', 'Delivered'),
(2, 2, '2026-08-05', 'Shipped'),
(3, 3, '2026-08-10', 'Pending'),
(4, 1, '2026-08-15', 'Delivered'),
(5, 4, '2026-08-20', 'Cancelled'),
(6, 5, '2026-08-25', 'Pending');

-- order_items (quantities/prices reconstructed to reproduce the
-- revenue, average line value and running-total figures in the docs)
INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 2, 499.00),   -- Wireless Mouse
(1, 5, 3, 60.00),    -- A4 Notebook
(2, 3, 1, 650.00),   -- Basmati Rice 5kg
(2, 4, 2, 150.00),   -- Sunflower Oil 1L
(3, 7, 1, 4500.00),  -- Office Chair
(4, 9, 2, 399.00),   -- Men Cotton T-Shirt
(4, 10, 1, 799.00),  -- Women Kurti
(5, 2, 1, 1499.00),  -- Bluetooth Headphones
(6, 6, 4, 40.00);    -- Ballpoint Pen Pack
