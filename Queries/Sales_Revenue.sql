--Sales and Revenue anlaysis

/*1. İl üzrə ümumi gəlir
2. Ay-il üzrə gəlir trendi
3. Kateqoriya üzrə gəlir
4. Geliri ən yüksək 10 məhsul
5. Orta sifariş dəyəri (AOV) — ümumi və il üzrə
6. Ölkə üzrə gəlir
7. Ödəniş metodu üzrə gəlir paylanması
8. Sifariş statusu paylanması
9. Endirimlərin gəlirə təsiri
10. Mövsümilik — ay üzrə sifariş sayı

*/




--1. İl üzrə ümumi gəlir

SELECT EXTRACT(YEAR FROM order_date) AS order_year,
       ROUND(SUM(oi.line_total), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status != 'CANCELLED'
GROUP BY EXTRACT(YEAR FROM order_date)
ORDER BY order_year;



--2. Ay-il üzrə gəlir trendi

SELECT TO_CHAR(o.order_date, 'YYYY-MM') AS year_month,
       ROUND(SUM(oi.line_total), 2) AS total_revenue
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status != 'CANCELLED'
GROUP BY TO_CHAR(o.order_date, 'YYYY-MM')
ORDER BY year_month;



--3. Kateqoriya üzrə gəlir

SELECT c.category_name,
       ROUND(SUM(oi.line_total), 2) AS total_revenue
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN categories c ON c.category_id = p.category_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status != 'CANCELLED'
GROUP BY c.category_name
ORDER BY total_revenue DESC;


--4. Geliri ən yüksək 10 məhsul

SELECT p.product_id, p.product_name,
       ROUND(SUM(oi.line_total), 2) AS total_revenue,
       SUM(oi.quantity) AS total_units
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status != 'CANCELLED'
GROUP BY p.product_id, p.product_name
ORDER BY total_revenue DESC
FETCH FIRST 10 ROWS ONLY;

--5. Orta sifariş dəyəri (AOV) — ümumi və il üzrə

SELECT ROUND(SUM(oi.line_total) / COUNT(DISTINCT o.order_id), 2) AS overall_aov
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status != 'CANCELLED';

--ilk once yoxladiq


SELECT EXTRACT(YEAR FROM o.order_date) AS order_year,
       ROUND(SUM(oi.line_total) / COUNT(DISTINCT o.order_id), 2) AS aov
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status != 'CANCELLED'
GROUP BY EXTRACT(YEAR FROM o.order_date)
ORDER BY order_year;


--6. Ölkə üzrə gəlir

SELECT cu.country,
       ROUND(SUM(oi.line_total), 2) AS total_revenue
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
JOIN customers cu ON cu.customer_id = o.customer_id
WHERE o.status != 'CANCELLED'
GROUP BY cu.country
ORDER BY total_revenue DESC;


--7. Ödəniş metodu üzrə gəlir paylanması


SELECT NVL(o.payment_method, 'UNKNOWN') AS payment_method,
       ROUND(SUM(oi.line_total), 2) AS total_revenue,
       COUNT(DISTINCT o.order_id) AS order_count
FROM orders o
JOIN order_items oi ON oi.order_id = o.order_id
WHERE o.status != 'CANCELLED'
GROUP BY NVL(o.payment_method, 'UNKNOWN')
ORDER BY total_revenue DESC;


--8. Sifariş statusu paylanması

SELECT status,
       COUNT(*) AS order_count,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2)||'%' AS pct_of_total
FROM orders
GROUP BY status
ORDER BY order_count DESC;


--9. Endirimlərin gəlirə təsiri

SELECT ROUND(SUM(oi.unit_price * oi.quantity - oi.line_total), 2) AS total_discount_amount,
       ROUND(SUM(oi.line_total), 2) AS net_revenue,
       ROUND(100 * SUM(oi.unit_price * oi.quantity - oi.line_total)
             / NULLIF(SUM(oi.unit_price * oi.quantity), 0), 2)||'%' AS discount_pct_of_gross
FROM order_items oi
JOIN orders o ON o.order_id = oi.order_id
WHERE o.status != 'CANCELLED';



--10. Mövsümilik — ay üzrə sifariş sayı

SELECT EXTRACT(MONTH FROM order_date) AS order_month,
       COUNT(*) AS order_count
FROM orders
GROUP BY EXTRACT(MONTH FROM order_date)
ORDER BY order_month;


