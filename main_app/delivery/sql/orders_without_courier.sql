SELECT orders.*
FROM orders
JOIN delivery using (delivery_id)
WHERE delivery.cour_id IS NULL;
