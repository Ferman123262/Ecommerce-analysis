--Data cleaning


/*## Data Cleaning (`sql/00_data_cleaning.sql`)
- C1: Customers.city sütununda qeyri-ardıcıl böyük/kiçik hərf
- C2: Products.rating sütununda boş dəyərlər
- C3: Orders.payment_method sütununda boş dəyərlər
- C4: Support_tickets.priority sütununda qeyri-ardıcıl böyük/kiçik hərf
- C5: Əlavə ümumi keyfiyyət yoxlamaları (dublikatlar, mənfi qiymətlər və s.)
*/



-- C1: Customers.city sütununda qeyri-ardıcıl böyük/kiçik hərfrf
SELECT COUNT(*) AS before_fix_count
FROM customers
WHERE city != INITCAP(TRIM(city));

--1000 dene problemli sutun var

UPDATE customers
SET city = INITCAP(TRIM(city))
WHERE city != INITCAP(TRIM(city));

commit;

SELECT COUNT(*) AS after_fix_count
FROM customers
WHERE city != INITCAP(TRIM(city));


--Artiq netice 0 dir problem hell oldu




--- C2: Products.rating sütununda boş dəyərlər

SELECT COUNT(*) AS before_fix_count
FROM products
WHERE rating IS NULL;

--500 dene null deyer var bizde bunu oz kategoriyasinin ortlamasi ile doldururuq
UPDATE products p
SET rating = (
    SELECT ROUND(AVG(p2.rating), 2)
    FROM products p2
    WHERE p2.category_id = p.category_id
      AND p2.rating IS NOT NULL
)
WHERE rating IS NULL;
commit;

SELECT COUNT(*) AS after_fix_count
FROM products
WHERE rating IS NULL;


--- C3: Orders.payment_method sütununda boş dəyərlər

select * from  orders;


SELECT COUNT(*) AS before_fix_count
FROM orders
WHERE payment_method IS NULL;


--Demeli 1000 deyerimizde odenisin  nece olundugu haqda melumat yoxdur
--Biz bu deyerleri unknown ile evez edeceyik

UPDATE orders
SET payment_method = 'UNKNOWN'
WHERE payment_method IS NULL;


SELECT COUNT(*) AS before_fix_count
FROM orders
WHERE payment_method IS NULL;





-- C4: Support_tickets.priority sütununda qeyri-ardıcıl böyük/kiçik hərf
select * from support_tickets;

SELECT COUNT(*) AS before_fix_count
FROM support_tickets
WHERE priority != UPPER(TRIM(priority));


UPDATE support_tickets
SET priority = UPPER(TRIM(priority))
WHERE priority != UPPER(TRIM(priority));

commit;


SELECT COUNT(*) AS before_fix_count
FROM support_tickets
WHERE priority != UPPER(TRIM(priority));



- C5: Əlavə ümumi keyfiyyət yoxlamaları (dublikatlar, mənfi qiymətlər və s.)

-- Dublikat email unvanlari
SELECT email, COUNT(*) cnt
FROM customers
GROUP BY email
HAVING COUNT(*) > 1;

--Email sutunun da sublikat deyer yoxdur

-- Menfi ve ya sifir qiymetli mehsullar
SELECT product_id, product_name, unit_price
FROM products
WHERE unit_price <= 0;

--Burdada her sey qaydasindadir


-- Cost_price > unit_price olan mehsullar (zererle satilan)
SELECT product_id, product_name, unit_price, cost_price
FROM products
WHERE cost_price > unit_price;

--Burdada her sey qaydasindadir


-- Teslim tarixi gonderim tarixinden evvel olan sehv shipment qeydleri
SELECT shipment_id, order_id, shipped_date, delivery_date
FROM shipments
WHERE delivery_date < shipped_date;


--Datada her sey mentiqe uygundur
