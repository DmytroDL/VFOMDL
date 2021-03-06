with all_calls as (select
originating_country,
calling_number,
case
when calling_number like '1%' THEN substr(calling_number,1,1)
when calling_number like '7%' THEN substr(calling_number,1,1)
when calling_number like '21%' THEN substr(calling_number,1,3)
when calling_number like '22%' THEN substr(calling_number,1,3)
when calling_number like '23%' THEN substr(calling_number,1,3)
when calling_number like '24%' THEN substr(calling_number,1,3)
when calling_number like '25%' THEN substr(calling_number,1,3)
when calling_number like '26%' THEN substr(calling_number,1,3)
when calling_number like '29%' THEN substr(calling_number,1,3)
when calling_number like '35%' THEN substr(calling_number,1,3)
when calling_number like '37%' THEN substr(calling_number,1,3)
when calling_number like '38%' THEN substr(calling_number,1,3)
when calling_number like '42%' THEN substr(calling_number,1,3)
when calling_number like '50%' THEN substr(calling_number,1,3)
when calling_number like '59%' THEN substr(calling_number,1,3)
when calling_number like '67%' THEN substr(calling_number,1,3)
when calling_number like '68%' THEN substr(calling_number,1,3)
when calling_number like '69%' THEN substr(calling_number,1,3)
when calling_number like '85%' THEN substr(calling_number,1,3)
when calling_number like '88%' THEN substr(calling_number,1,3)
when calling_number like '96%' THEN substr(calling_number,1,3)
when calling_number like '97%' THEN substr(calling_number,1,3)
when calling_number like '99%' THEN substr(calling_number,1,3)
ELSE substr(calling_number,1,2) END cfrm,
called_number,
case
when length(called_number) = 5 THEN 'PDS_NUMBER'
when called_number like '1%' THEN substr(called_number,1,1)
when called_number like '7%' THEN substr(called_number,1,1)
when called_number like '21%' THEN substr(called_number,1,3)
when called_number like '22%' THEN substr(called_number,1,3)
when called_number like '23%' THEN substr(called_number,1,3)
when called_number like '24%' THEN substr(called_number,1,3)
when called_number like '25%' THEN substr(called_number,1,3)
when called_number like '26%' THEN substr(called_number,1,3)
when called_number like '29%' THEN substr(called_number,1,3)
when called_number like '35%' THEN substr(called_number,1,3)
when called_number like '37%' THEN substr(called_number,1,3)
when called_number like '38%' THEN substr(called_number,1,3)
when called_number like '42%' THEN substr(called_number,1,3)
when called_number like '50%' THEN substr(called_number,1,3)
when called_number like '59%' THEN substr(called_number,1,3)
when called_number like '67%' THEN substr(called_number,1,3)
when called_number like '68%' THEN substr(called_number,1,3)
when called_number like '69%' THEN substr(called_number,1,3)
when called_number like '85%' THEN substr(called_number,1,3)
when called_number like '88%' THEN substr(called_number,1,3)
when called_number like '96%' THEN substr(called_number,1,3)
when called_number like '97%' THEN substr(called_number,1,3)
when called_number like '99%' THEN substr(called_number,1,3)
when called_number like '0091%' THEN '91'
ELSE substr(called_number,1,2) END cto,
duration_seconds/60 duration,
number_of_messages sms,
date_format(event_dtm,'MMMM') event_date,
record_type_value
from refined.fct_prepaid_usages
where record_type_value in ('Voice','SMS')
and `date` = '2022-04-20'),
out_events as (select 
ac.event_date event_date,
ac.originating_country originating_country,
cc2.country destination_country,
sum(if(ac.record_type_value = 'Voice', 0.0, 0.0)) as In_Mins,
sum(if(ac.record_type_value = 'Voice', nvl(ac.duration,0.0), 0)) as Out_Mins,
sum(if(ac.record_type_value = 'SMS', 0.0, 0.0)) as In_SMS,
sum(if(ac.record_type_value = 'SMS', nvl(ac.sms,0.0), 0)) as Out_SMS,
count(distinct ac.calling_number) msisdn_cnt,
sum(if(ac.record_type_value = 'Voice', 1.0, 0.0)) as calls_cnt
from all_calls ac
left join datamart.dm_country_codes cc2 on cc2.code = ac.cto
where ac.cfrm = '968' and ac.cto <> '968' and ac.originating_country = 'Oman' and ac.cto <> 'PDS_NUMBER'
group by event_date,ac.originating_country,cc2.country),
inc_events as (select 
ac.event_date event_date,
ac.originating_country originating_country,
cc2.country destination_country,
sum(if(ac.record_type_value = 'Voice', nvl(ac.duration,0.0), 0)) as In_Mins,
sum(if(ac.record_type_value = 'Voice', 0.0, 0.0)) as Out_Mins,
sum(if(ac.record_type_value = 'SMS', nvl(ac.sms,0.0), 0)) as In_SMS,
sum(if(ac.record_type_value = 'SMS', 0.0, 0.0)) as Out_SMS,
count(distinct ac.calling_number) msisdn_cnt,
sum(if(ac.record_type_value = 'Voice', 1.0, 0.0)) as calls_cnt
from all_calls ac
left join datamart.dm_country_codes cc2 on cc2.code = ac.cto
where ac.cfrm <> '968' and ac.cto = '968' and ac.originating_country <> 'Oman'
group by event_date,ac.originating_country,cc2.country)
select * from out_events
union
select * from inc_events