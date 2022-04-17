with tmp as (select sms.desination_address, sms.origination_address, to_date(sms.event_dtm) as event_dtm, count(distinct message_id) as count_sms
from raw.smsc_data sms
join refined.manual_ref_smsc manu
on sms.desination_address = manu.digit_code
where sms.`date` >= '2022-04-01'
and upper(sms.message_type) = 'MO_AT'
group by sms.desination_address, sms.origination_address, to_date(sms.event_dtm))
select
tmp.event_dtm,
tmp.desination_address,
tmp.origination_address as mobile_number, 
sub.tariff_plan_name as rate_plan, 
mrs.service_description,
tmp.count_sms,
mrs.rate_ro as rate_ro,
tmp.count_sms*mrs.rate_ro as total_revenue,
round(tmp.count_sms*mrs.rate_ro * 0.4,3) as vodafone_share,
round(tmp.count_sms*mrs.rate_ro * 0.6,3) as pds_share
from tmp
join refined.manual_ref_smsc mrs on mrs.digit_code = tmp.desination_address
left join refined.vf_dim_subscription sub on sub.msisdn = substring(tmp.origination_address, 4, 8)