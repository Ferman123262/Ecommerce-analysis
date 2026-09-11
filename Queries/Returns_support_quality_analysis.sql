--Returns, Support & Quality 
/*
41. Ümumi qaytarma faizi
42. Ən çox rastlanan qaytarma səbəbləri
43. Kateqoriya üzrə qaytarma faizi
44. Ümumi geri ödəniş (refund) məbləği — ay üzrə
45. Kateqoriya üzrə dəstək bilet həcmi
46. Prioritet paylanması və orta həll müddəti
47. Birdən çox dəstək bileti olan müştərilər
48. Müştəri başına qaytarma və dəstək bileti əlaqəsi
49. Rəy (review) reytinq paylanması və kateqoriya üzrə orta reytinq
*/



--41. Ümumi qaytarma faizi

SELECT COUNT(DISTINCT r.order_id) AS returned_orders,
       COUNT(DISTINCT o.order_id) AS total_orders,
       ROUND(100 * COUNT(DISTINCT r.order_id) / COUNT(DISTINCT o.order_id), 2) AS return_rate_pct
FROM orders o
LEFT JOIN returns r ON r.order_id = o.order_id;


--42. Ən çox rastlanan qaytarma səbəbləri

SELECT reason, COUNT(*) AS return_count
FROM returns
GROUP BY reason
ORDER BY return_count DESC;


--43. Kateqoriya üzrə qaytarma faizi

SELECT c.category_name,
       COUNT(DISTINCT r.return_id) AS returns_count,
       COUNT(DISTINCT oi.order_item_id) AS items_sold,
       ROUND(100 * COUNT(DISTINCT r.return_id) / NULLIF(COUNT(DISTINCT oi.order_item_id), 0), 2) AS return_rate_pct
FROM categories c
JOIN products p ON p.category_id = c.category_id
JOIN order_items oi ON oi.product_id = p.product_id
JOIN orders o ON o.order_id = oi.order_id
LEFT JOIN returns r ON r.order_id = o.order_id 
GROUP BY c.category_name
ORDER BY return_rate_pct DESC NULLS LAST;


--44. Ümumi geri ödəniş (refund) məbləği — ay üzrə

SELECT TO_CHAR(return_date, 'YYYY-MM') AS return_month,
       ROUND(SUM(refund_amount), 2) AS total_refund
FROM returns
GROUP BY TO_CHAR(return_date, 'YYYY-MM')
ORDER BY return_month;


--45. Kateqoriya üzrə dəstək bilet həcmi

SELECT category, COUNT(*) AS ticket_count
FROM support_tickets
GROUP BY category
ORDER BY ticket_count DESC;


--46. Prioritet paylanması və orta həll müddəti

SELECT UPPER(TRIM(priority)) AS priority_clean,
       COUNT(*) AS ticket_count,
       ROUND(AVG(resolution_hours), 2) AS avg_resolution_hours
FROM support_tickets
GROUP BY UPPER(TRIM(priority))
ORDER BY avg_resolution_hours DESC;


--47. Birdən çox dəstək bileti olan müştərilər

SELECT customer_id, COUNT(*) AS ticket_count
FROM support_tickets
GROUP BY customer_id
HAVING COUNT(*) > 1
ORDER BY ticket_count DESC;


--48. Müştəri başına qaytarma və dəstək bileti əlaqəsi

SELECT cu.customer_id,
       COUNT(DISTINCT r.return_id) AS return_count,
       COUNT(DISTINCT st.ticket_id) AS ticket_count
FROM customers cu
LEFT JOIN returns r ON r.customer_id = cu.customer_id
LEFT JOIN support_tickets st ON st.customer_id = cu.customer_id
GROUP BY cu.customer_id
HAVING COUNT(DISTINCT r.return_id) > 0 AND COUNT(DISTINCT st.ticket_id) > 0
ORDER BY return_count DESC, ticket_count DESC;


--49. Rəy (review) reytinq paylanması və kateqoriya üzrə orta reytinq

SELECT c.category_name,
       ROUND(AVG(rv.rating), 2) AS avg_review_rating,
       COUNT(rv.review_id) AS review_count
FROM reviews rv
JOIN orders o ON o.order_id = rv.order_id
JOIN order_items oi ON oi.order_id = o.order_id
JOIN products p ON p.product_id = oi.product_id
JOIN categories c ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY avg_review_rating DESC;

