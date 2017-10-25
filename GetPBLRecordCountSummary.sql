SELECT pbh.batch_name,
       TO_CHAR(pbh.creation_date,'DD-MM-YYYY') batch_creation_date,
       flv.meaning batch_line_status,
       COUNT(pbl.batch_line_id) recordcount
FROM   pay_batch_headers pbh,
       pay_batch_lines pbl,
       fnd_lookup_values flv
WHERE  pbh.batch_id = pbl.batch_id
AND    pbh.batch_name = NVL(:batchname,pbh.batch_name)
AND    flv.lookup_type = 'PAY_BATCH_STATUS'
AND    flv.lookup_code = pbl.batch_line_status
AND    flv.language = 'US'
and    TRUNC(SYSDATE) BETWEEN flv.start_date_Active and flv.end_date_active
group  by pbh.batch_name,
       pbh.creation_date,
       flv.meaning
order by pbh.creation_date desc