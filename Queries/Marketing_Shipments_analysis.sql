--Marketing analysis

/*31. Kanal üzrə ümumi marketinq büdcəsi
32. Hədəf müştəri seqmentinə görə kampaniya sayı və büdcə
33. Müştəri seqmenti üzrə ümumi gəlir
34. Kampaniya başladıqdan sonrakı 30 gündə hədəf seqmentdən gələn sifarişlər
35. Vaxta görə kanal büdcə ayrılması trendi*/



--31. Kanal üzrə ümumi marketinq büdcəsi

SELECT channel,
       COUNT(*) AS campaign_count,
       ROUND(SUM(budget), 2) AS total_budget
FROM marketing_campaigns
GROUP BY channel
ORDER BY total_budget DESC;


--32. Hədəf müştəri seqmentinə görə kampaniya sayı və büdcə

SELECT target_segment,
       COUNT(*) AS campaign_count,
       ROUND(SUM(budget), 2) AS total_budget
FROM marketing_campaigns
GROUP BY target_segment
ORDER BY total_budget DESC;


--33. Müştəri seqmenti üzrə ümumi gəlir

SELECT cu.customer_segment,
       ROUND(SUM(oi.line_total), 2) AS segment_revenue
FROM customers cu
JOIN orders o ON o.customer_id = cu.customer_id AND o.status != 'CANCELLED'
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY cu.customer_segment
ORDER BY segment_revenue DESC;


--34. Kampaniya başladıqdan sonrakı 30 gündə hədəf seqmentdən gələn sifarişlər

SELECT mc.campaign_id, mc.campaign_name, mc.target_segment, mc.start_date,
       COUNT(DISTINCT o.order_id) AS orders_in_30_days,
       ROUND(SUM(oi.line_total), 2) AS revenue_in_30_days
FROM marketing_campaigns mc
JOIN customers cu ON cu.customer_segment = mc.target_segment
JOIN orders o ON o.customer_id = cu.customer_id
             AND o.order_date BETWEEN mc.start_date AND mc.start_date + 30
             AND o.status != 'CANCELLED'
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY mc.campaign_id, mc.campaign_name, mc.target_segment, mc.start_date
ORDER BY revenue_in_30_days DESC;


--35. Vaxta görə kanal büdcə ayrılması trendi

SELECT TO_CHAR(start_date, 'YYYY-MM') AS campaign_month,
       channel,
       ROUND(SUM(budget), 2) AS monthly_budget
FROM marketing_campaigns
GROUP BY TO_CHAR(start_date, 'YYYY-MM'), channel
ORDER BY campaign_month, channel;



-- Operations & Shipping 
/*
36. Orta çatdırılma müddəti
37. Göndərim metodu üzrə paylanma və orta çatdırılma müddəti
38. Gecikmiş çatdırılmalar
39. Göndərimi olmayan sifarişlər (biznes qaydası yoxlaması)
40. Göndərim statusu paylanması
*/




--36. Orta çatdırılma müddəti

SELECT ROUND(AVG(delivery_date - shipped_date), 2) AS avg_delivery_days
FROM shipments
WHERE shipped_date IS NOT NULL AND delivery_date IS NOT NULL;


--37. Göndərim metodu üzrə paylanma və orta çatdırılma müddəti

SELECT shipping_method,
       COUNT(*) AS shipment_count,
       ROUND(AVG(delivery_date - shipped_date), 2) AS avg_delivery_days
FROM shipments
WHERE shipped_date IS NOT NULL AND delivery_date IS NOT NULL
GROUP BY shipping_method
ORDER BY shipment_count DESC;


--38. Gecikmiş çatdırılmalar

SELECT
    s.shipment_id,
    s.order_id,
    s.shipped_date,
    s.delivery_date,
    (s.delivery_date - s.shipped_date) AS delivery_days
FROM shipments s
WHERE s.shipped_date IS NOT NULL
  AND s.delivery_date IS NOT NULL
  AND (s.delivery_date - s.shipped_date) >
      2 * (
          SELECT AVG(delivery_date - shipped_date)
          FROM shipments
          WHERE shipped_date IS NOT NULL
            AND delivery_date IS NOT NULL
      )
ORDER BY delivery_days DESC;



--39. Göndərimi olmayan sifarişlər (biznes qaydası yoxlaması)

SELECT o.order_id, o.status
FROM orders o
LEFT JOIN shipments s ON s.order_id = o.order_id
WHERE s.shipment_id IS NULL
GROUP BY o.order_id, o.status;

--Asagidakida sayini yoxlayir

SELECT o.status, COUNT(*) AS order_count
FROM orders o
LEFT JOIN shipments s ON s.order_id = o.order_id
WHERE s.shipment_id IS NULL
GROUP BY o.status;


--40. Göndərim statusu paylanması

SELECT shipment_status,
       COUNT(*) AS shipment_count,
       ROUND(100 * COUNT(*) / SUM(COUNT(*)) OVER (), 2) ||'%' AS pct_of_total
FROM shipments
GROUP BY shipment_status
ORDER BY shipment_count DESC;

