SELECT cl_id, cl_name, cl_regist, cl_adress, cl_phone
FROM clients
WHERE EXTRACT(YEAR FROM cl_regist) = ${year}
  AND EXTRACT(MONTH FROM cl_regist) BETWEEN ${month_start} AND ${month_end};
