SELECT bouq_id as 'Номер букета', kolvo as 'Количество', total_price as 'Общая сумма'
FROM report
where rep_mon=${month} and rep_year = ${year}
ORDER BY rep_year ASC, rep_mon ASC;
