SELECT COUNT(*) as record_count
FROM courier_report
WHERE rep_month = ${month} AND rep_year = ${year};
