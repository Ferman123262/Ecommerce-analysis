CREATE TABLE categories (
    category_id VARCHAR2(10) PRIMARY KEY,
    category_name VARCHAR2(100) NOT NULL,
    department VARCHAR2(100) NOT NULL
);

CREATE TABLE suppliers (
    supplier_id NUMBER PRIMARY KEY,
    supplier_name VARCHAR2(150) NOT NULL,
    country VARCHAR2(80),
    supplier_rating NUMBER(3,2),
    active_flag CHAR(1)
);

CREATE TABLE products (
    product_id NUMBER PRIMARY KEY,
    product_name VARCHAR2(200) NOT NULL,
    category_id VARCHAR2(10) NOT NULL,
    supplier_id NUMBER NOT NULL,
    unit_price NUMBER(12,2),
    cost_price NUMBER(12,2),
    stock_quantity NUMBER,
    rating NUMBER(3,2),
    active_flag CHAR(1),
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(category_id),
    CONSTRAINT fk_products_supplier FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(100),
    last_name VARCHAR2(100),
    email VARCHAR2(200),
    gender VARCHAR2(20),
    age NUMBER,
    country VARCHAR2(80),
    city VARCHAR2(80),
    signup_date DATE,
    customer_segment VARCHAR2(30)
);

CREATE TABLE addresses (
    address_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    address_type VARCHAR2(30),
    postal_code VARCHAR2(20),
    street_address VARCHAR2(200),
    country VARCHAR2(80),
    city VARCHAR2(80),
    CONSTRAINT fk_addresses_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE orders (
    order_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    order_date DATE,
    status VARCHAR2(30),
    payment_method VARCHAR2(50),
    shipping_method VARCHAR2(30),
    discount_percent NUMBER(5,2),
    CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id NUMBER PRIMARY KEY,
    order_id NUMBER NOT NULL,
    product_id NUMBER NOT NULL,
    quantity NUMBER,
    unit_price NUMBER(12,2),
    discount_percent NUMBER(5,2),
    line_total NUMBER(14,2),
    CONSTRAINT fk_items_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_items_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE payments (
    payment_id NUMBER PRIMARY KEY,
    order_id NUMBER NOT NULL,
    payment_date DATE,
    payment_method VARCHAR2(50),
    amount NUMBER(14,2),
    payment_status VARCHAR2(30),
    CONSTRAINT fk_payments_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE shipments (
    shipment_id NUMBER PRIMARY KEY,
    order_id NUMBER NOT NULL,
    shipped_date DATE,
    delivery_date DATE,
    shipping_method VARCHAR2(30),
    shipment_status VARCHAR2(30),
    CONSTRAINT fk_shipments_order FOREIGN KEY (order_id) REFERENCES orders(order_id)
);

CREATE TABLE reviews (
    review_id NUMBER PRIMARY KEY,
    order_id NUMBER NOT NULL,
    customer_id NUMBER NOT NULL,
    rating NUMBER(1),
    review_date DATE,
    review_text VARCHAR2(500),
    CONSTRAINT fk_reviews_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_reviews_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE returns (
    return_id NUMBER PRIMARY KEY,
    order_id NUMBER NOT NULL,
    customer_id NUMBER NOT NULL,
    return_date DATE,
    reason VARCHAR2(100),
    refund_amount NUMBER(14,2),
    return_status VARCHAR2(30),
    CONSTRAINT fk_returns_order FOREIGN KEY (order_id) REFERENCES orders(order_id),
    CONSTRAINT fk_returns_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE discounts (
    discount_id NUMBER PRIMARY KEY,
    product_id NUMBER NOT NULL,
    discount_code VARCHAR2(50),
    discount_percent NUMBER(5,2),
    start_date DATE,
    end_date DATE,
    CONSTRAINT fk_discounts_product FOREIGN KEY (product_id) REFERENCES products(product_id)
);

CREATE TABLE marketing_campaigns (
    campaign_id NUMBER PRIMARY KEY,
    campaign_name VARCHAR2(150),
    channel VARCHAR2(50),
    start_date DATE,
    budget NUMBER(14,2),
    target_segment VARCHAR2(30)
);

CREATE TABLE support_tickets (
    ticket_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    created_date DATE,
    category VARCHAR2(50),
    priority VARCHAR2(30),
    status VARCHAR2(30),
    resolution_hours NUMBER(10,1),
    CONSTRAINT fk_tickets_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

COMMIT;






SELECT 'categories' , COUNT(*) cnt FROM categories
UNION ALL SELECT 'suppliers', COUNT(*) FROM suppliers
UNION ALL SELECT 'products', COUNT(*) FROM products
UNION ALL SELECT 'customers', COUNT(*) FROM customers
UNION ALL SELECT 'addresses', COUNT(*) FROM addresses
UNION ALL SELECT 'orders', COUNT(*) FROM orders
UNION ALL SELECT 'order_items', COUNT(*) FROM order_items
UNION ALL SELECT 'payments', COUNT(*) FROM payments
UNION ALL SELECT 'shipments', COUNT(*) FROM shipments
UNION ALL SELECT 'reviews', COUNT(*) FROM reviews
UNION ALL SELECT 'returns', COUNT(*) FROM returns
UNION ALL SELECT 'discounts', COUNT(*) FROM discounts
UNION ALL SELECT 'marketing_campaigns', COUNT(*) FROM marketing_campaigns
UNION ALL SELECT 'support_tickets', COUNT(*) FROM support_tickets;

