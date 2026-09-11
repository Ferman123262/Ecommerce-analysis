--Customer Analytics (
/*
11. Ay üzrə yeni müştəri qeydiyyatı trendi
12. Müştəri seqmenti üzrə sayı və gəlir
13. Ümumi xərcinə görə ən yaxşı 20 müştəri
14. Təkrar alış-veriş nisbəti
15. Müştəri başına orta sifariş sayı
16. RFM-lite seqmentasiya (Recency/Frequency/Monetary)
17. Churn namizədləri (son 6 ayda sifariş verməyənlər)
18. Cinsiyyət üzrə müştəri sayı və gəlir
19. Yaş qrupu üzrə analiz
20. Ölkə üzrə müştəri ömürlük dəyəri (CLV)
*/


--11. Ay üzrə yeni müştəri qeydiyyatı trendi

SELECT TO_CHAR(signup_date, 'YYYY-MM') AS signup_month,
       COUNT(*) AS new_customers
FROM customers
GROUP BY TO_CHAR(signup_date, 'YYYY-MM')
ORDER BY signup_month;

--12. Müştəri seqmenti üzrə sayı və gəlir

SELECT cu.customer_segment,
       COUNT(DISTINCT cu.customer_id) AS customer_count,
       ROUND(SUM(oi.line_total), 2) AS total_revenue
FROM customers cu
LEFT JOIN orders o ON o.customer_id = cu.customer_id AND o.status != 'CANCELLED'
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY cu.customer_segment
ORDER BY total_revenue DESC NULLS LAST;

--13. Ümumi xərcinə görə ən yaxşı 20 müştəri

SELECT cu.customer_id, cu.first_name, cu.last_name,
       ROUND(SUM(oi.line_total), 2) AS lifetime_spend
FROM customers cu
JOIN orders o ON o.customer_id = cu.customer_id AND o.status != 'CANCELLED'
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY cu.customer_id, cu.first_name, cu.last_name
ORDER BY lifetime_spend DESC
FETCH FIRST 20 ROWS ONLY;


--14. Təkrar alış-veriş nisbəti

SELECT COUNT(DISTINCT CASE WHEN order_cnt >= 2 THEN customer_id END) AS repeat_customers,
       COUNT(DISTINCT customer_id) AS total_customers_with_orders,
       ROUND(100 * COUNT(DISTINCT CASE WHEN order_cnt >= 2 THEN customer_id END)
             / COUNT(DISTINCT customer_id), 2) || '%' AS repeat_rate_pct
FROM (
    SELECT customer_id, COUNT(*) AS order_cnt
    FROM orders
    WHERE status != 'CANCELLED'
    GROUP BY customer_id
);


--15. Müştəri başına orta sifariş sayı

SELECT ROUND(COUNT(*) / COUNT(DISTINCT customer_id), 2) AS avg_orders_per_customer
FROM orders
WHERE status != 'CANCELLED';


--16. RFM-lite seqmentasiya (Recency/Frequency/Monetary)


SELECT customer_id,
       recency_days,
       frequency,
       monetary,
       NTILE(4) OVER (ORDER BY recency_days) AS recency_score,
       NTILE(4) OVER (ORDER BY frequency DESC) AS frequency_score,
       NTILE(4) OVER (ORDER BY monetary DESC) AS monetary_score
FROM (
    SELECT o.customer_id,
           TRUNC(SYSDATE) - MAX(o.order_date) AS recency_days,
           COUNT(DISTINCT o.order_id) AS frequency,
           SUM(oi.line_total) AS monetary
    FROM orders o
    JOIN order_items oi ON oi.order_id = o.order_id
    WHERE o.status != 'CANCELLED'
    GROUP BY o.customer_id
);


--17. Churn namizədləri (son 6 ayda sifariş verməyənlər)

SELECT cu.customer_id, cu.first_name, cu.last_name, MAX(o.order_date) AS last_order_date
FROM customers cu
JOIN orders o ON o.customer_id = cu.customer_id AND o.status != 'CANCELLED'
GROUP BY cu.customer_id, cu.first_name, cu.last_name
HAVING MAX(o.order_date) < ADD_MONTHS((SELECT MAX(order_date) FROM orders), -6)
ORDER BY last_order_date;


--18. Cinsiyyət üzrə müştəri sayı və gəlir

SELECT cu.gender,
       COUNT(DISTINCT cu.customer_id) AS customer_count,
       ROUND(SUM(oi.line_total), 2) AS total_revenue
FROM customers cu
LEFT JOIN orders o ON o.customer_id = cu.customer_id AND o.status != 'CANCELLED'
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY cu.gender
ORDER BY total_revenue DESC NULLS LAST;


--19. Yaş qrupu üzrə analiz

SELECT CASE
         WHEN age < 25 THEN '18-24'
         WHEN age BETWEEN 25 AND 34 THEN '25-34'
         WHEN age BETWEEN 35 AND 44 THEN '35-44'
         WHEN age BETWEEN 45 AND 54 THEN '45-54'
         ELSE '55+'
       END AS age_group,
       COUNT(DISTINCT cu.customer_id) AS customer_count,
       ROUND(SUM(oi.line_total), 2) AS total_revenue
FROM customers cu
LEFT JOIN orders o ON o.customer_id = cu.customer_id AND o.status != 'CANCELLED'
LEFT JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY CASE
           WHEN age < 25 THEN '18-24'
           WHEN age BETWEEN 25 AND 34 THEN '25-34'
           WHEN age BETWEEN 35 AND 44 THEN '35-44'
           WHEN age BETWEEN 45 AND 54 THEN '45-54'
           ELSE '55+'
         END
ORDER BY age_group;


--20. Ölkə üzrə müştəri ömürlük dəyəri (CLV)

SELECT cu.country,
       COUNT(DISTINCT cu.customer_id) AS customer_count,
       ROUND(SUM(oi.line_total) / COUNT(DISTINCT cu.customer_id), 2) AS avg_clv
FROM customers cu
JOIN orders o ON o.customer_id = cu.customer_id AND o.status != 'CANCELLED'
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY cu.country
ORDER BY avg_clv DESC;


