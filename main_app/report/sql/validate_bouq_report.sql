SELECT COUNT(*) as record_count
FROM report
WHERE rep_mon = ${month} AND rep_year = ${year};
