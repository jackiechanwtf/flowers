SELECT c.cour_id, c.cour_name
FROM couriers c
LEFT JOIN delivery d ON c.cour_id = d.cour_id
LEFT JOIN orders o ON d.delivery_id = o.delivery_id
WHERE o.delivery_id IS NULL;
