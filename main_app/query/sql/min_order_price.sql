SELECT MIN(bouqets.bouq_price*compos.quantity) as min_price
FROM bouqets, compos, orders
WHERE bouqets.bouq_id=compos.bouq_id
AND compos.order_id = orders.order_id
AND YEAR(orders.creation_date)=${year};