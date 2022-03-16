/*
 To provide total consumption for the data group by date
 */
select sum(total_volume) as DataTotal,
       date_Format(event_dtm, 'yyyy-MM-dd') as ExctractedDate
from refined.fct_prepaid_usages where record_type_value = "Data"
group by date_Format(event_dtm, 'yyyy-MM-dd')
order by ExctractedDate desc