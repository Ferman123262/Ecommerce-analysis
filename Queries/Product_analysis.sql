--Product Analytics 
/*
21. Ən çox satılan 10 məhsul (miqdara görə)
22. Ən az satılan (aktiv) 10 məhsul
23. Kateqoriya performansı
24. Yüksək reytinqli amma az satılan məhsullar
25. Aşağı reytinqli məhsullar (rating <  3)
26. Stok riski — az stoku olan amma çox satılan məhsullar
27. Məhsul üzrə mənfəət marjı
28. Təchizatçı performansı
29. Heç vaxt sifariş olunmamış məhsullar
30. Qiymət aralığına görə orta reytinq*/


--21. Ən çox satılan 10 məhsul (miqdara görə)

SELECT p.product_id, p.product_name,
       SUM(oi.quantity) AS total_units_sold
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status != 'CANCELLED'
GROUP BY p.product_id, p.product_name
ORDER BY total_units_sold DESC
FETCH FIRST 10 ROWS ONLY;


--22. Ən az satılan (aktiv) 10 məhsul

SELECT p.product_id, p.product_name,
       NVL(SUM(oi.quantity), 0) AS total_units_sold
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
LEFT JOIN orders o ON o.order_id = oi.order_id AND o.status != 'CANCELLED'
WHERE p.active_flag = 'Y'
GROUP BY p.product_id, p.product_name
ORDER BY total_units_sold asc
FETCH FIRST 10 ROWS ONLY;


--23. Kateqoriya performansı

SELECT c.category_name,
       SUM(oi.quantity) AS units_sold,
       ROUND(SUM(oi.line_total), 2) AS revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN categories c ON c.category_id = p.category_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status != 'CANCELLED'
GROUP BY c.category_name
ORDER BY revenue DESC;


--24. Yüksək reytinqli amma az satılan məhsullar

SELECT p.product_id, p.product_name, p.rating,
       NVL(SUM(oi.quantity), 0) AS units_sold
FROM products p
LEFT JOIN order_items oi ON oi.product_id = p.product_id
LEFT JOIN orders o ON o.order_id = oi.order_id AND o.status != 'CANCELLED'
WHERE p.rating >= 4.5
GROUP BY p.product_id, p.product_name, p.rating
HAVING NVL(SUM(oi.quantity), 0) < 10
ORDER BY p.rating DESC;


--25. Aşağı reytinqli məhsullar (rating <  3)
SELECT product_id, product_name, rating, stock_quantity
FROM products
WHERE rating IS NOT NULL AND rating < 3
ORDER BY rating ASC;



--26. Stok riski — az stoku olan amma çox satılan məhsullar

SELECT p.product_id, p.product_name, p.stock_quantity,
       SUM(oi.quantity) AS units_sold_last_period
FROM products p
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status != 'CANCELLED'
GROUP BY p.product_id, p.product_name, p.stock_quantity
HAVING p.stock_quantity < 20
ORDER BY units_sold_last_period DESC;


--27. Məhsul üzrə mənfəət marjı

SELECT product_id, product_name, unit_price, cost_price,
       ROUND(unit_price - cost_price, 2) AS margin_amount,
       ROUND(100 * (unit_price - cost_price) / NULLIF(unit_price, 0), 2) AS margin_pct
FROM products
ORDER BY margin_pct DESC
FETCH FIRST 20 ROWS ONLY;


--28. Təchizatçı performansı

SELECT s.supplier_id, s.supplier_name, s.country,
       ROUND(SUM(oi.line_total), 2) AS total_revenue
FROM suppliers s
JOIN products p ON p.supplier_id = s.supplier_id
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status != 'CANCELLED'
GROUP BY s.supplier_id, s.supplier_name, s.country
ORDER BY total_revenue DESC
FETCH FIRST 20 ROWS ONLY;


--29. Heç vaxt sifariş olunmamış məhsullar

SELECT p.product_id, p.product_name
FROM products p
WHERE NOT EXISTS (
    SELECT 1 FROM order_items oi WHERE oi.product_id = p.product_id
);


--Qiymet araligina gore orta reytinq (qiymet vs reytinq elaqesi)
SELECT CASE
         WHEN unit_price < 25 THEN '0-25'
         WHEN unit_price BETWEEN 25 AND 99.99 THEN '25-100'
         WHEN unit_price BETWEEN 100 AND 299.99 THEN '100-300'
         ELSE '300+'
       END AS price_band,
       ROUND(AVG(rating), 2) AS avg_rating,
       COUNT(*) AS product_count
FROM products
WHERE rating IS NOT NULL
GROUP BY CASE
           WHEN unit_price < 25 THEN '0-25'
           WHEN unit_price BETWEEN 25 AND 99.99 THEN '25-100'
           WHEN unit_price BETWEEN 100 AND 299.99 THEN '100-300'
           ELSE '300+'
         END
ORDER BY price_band;