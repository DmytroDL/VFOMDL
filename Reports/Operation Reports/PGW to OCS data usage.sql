with ocs as(SELECT sum (total_volume)/1073741824 VALUE,'OCS_DATA' type, date(event_dtm) event_date
from fct_prepaid_usages
where record_type_value = 'Data'
group by date (event_dtm )),
pgw as (select sum(download_volume+uploaded_volume)/1073741824 VALUE,'PGW_DATA' type, date (record_start_dtm) event_date
from refined.fct_pgw_data
group by date (record_start_dtm))
select ocs.event_date,pgw.value as PGW_DATA, ocs.value as OCS_DATA from ocs left join pgw on ocs.event_date = pgw.event_date