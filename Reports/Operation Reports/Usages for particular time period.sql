select * from refined.fct_prepaid_usages
where event_dtm > '2022-01-05 00:00'
  and event_dtm < '2022-01-05 23:59'
order by event_dtm;


--Option2 Faster
select * from (select * from refined.fct_prepaid_usages
               where (`date` >= '2021-12-30' and `date` <= '2022-01-20')
               union all
               select * from refined.fct_prepaid_usages
               where (`date` >= '2022-01-21' and `date` <= '2022-01-31')
               union all
               select * from refined.fct_prepaid_usages
               where (`date` >= '2022-02-01' and `date` <= '2022-02-14')
               union all
               select * from refined.fct_prepaid_usages
               where `date` > '2022-02-14') ttl
where ttl.msisdn='96877007465'
  and (ttl.event_dtm > from_unixtime(unix_timestamp('2021-12-31 00:00:00' , 'yyyy-MM-dd hh:mm:ss'))
    and ttl.event_dtm < from_unixtime(unix_timestamp('2022-02-20 00:00:00' , 'yyyy-MM-dd hh:mm:ss')));