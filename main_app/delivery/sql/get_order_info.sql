SELECT
    o.order_id,
    o.creation_date,
    d.del_date,
    d.delivery_time,
    d.delivery_place,
    c.cour_id,
    c.cour_name,
    c.cour_phone
FROM orders o
JOIN delivery d ON o.delivery_id = d.delivery_id
JOIN couriers c ON d.cour_id = c.cour_id
WHERE o.order_id = ${order_id} AND c.cour_id = ${courier_id};
