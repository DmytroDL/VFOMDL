with total_usages as (select
cast(msisdn as decimal(20,0)),
ocs_subscriber_id,
ocs_subscription_id,
tariff_plan_name,
CASE WHEN data_allowance = 'Unlimited' THEN cast(9999 as decimal(10,5)) ELSE cast(data_allowance as decimal(10,5)) END as data_allowance,
CASE WHEN voice_allowance = 'Unlimited' THEN cast(9999 as decimal(10,2)) ELSE cast(voice_allowance as decimal(10,2)) END as voice_allowance,
CASE WHEN sms_allowance = 'Unlimited' THEN cast(9999 as decimal(10,0)) ELSE cast(sms_allowance as decimal(10,0)) END as sms_allowance,
cast(total_usage as decimal(10,5)) total_usage,
cast(total_income_min as decimal(10,5)) total_income_min,
cast(total_outgoing_min as decimal(10,5)) total_outgoing_min,
cast(total_messages as decimal(10,5)) total_messages,
date
from datamart.dim_prepaid_bill_cycle_usage_daily du
union
select
cast(msisdn as decimal(20,0)),
ocs_subscriber_id,
ocs_subscription_id,
tariff_plan_name,
cast(0 as decimal(10,5)) data_allowance,
cast(0 as decimal(10,2)) voice_allowance,
cast(0 as decimal(10,0)) sms_allowance,
cast(total_usage as decimal(10,5)) total_usage,
cast(total_income_min as decimal(10,5)) total_income_min,
cast(total_outgoing_min as decimal(10,5)) total_outgoing_min,
cast(total_messages as decimal(10,5)) total_messages,
date
from datamart.dim_payg_usage_consamption_daily
union
select
cast(msisdn as decimal(20,0)),
ocs_subscriber_id,
ocs_subscription_id,
tariff_plan_name,
CASE WHEN data_allowance = 'Unlimited' THEN cast(9999 as decimal(10,5)) ELSE cast(data_allowance as decimal(10,5)) END as data_allowance,
CASE WHEN voice_allowance = 'Unlimited' THEN cast(9999 as decimal(10,2)) ELSE cast(voice_allowance as decimal(10,2)) END as voice_allowance,
CASE WHEN sms_allowance = 'Unlimited' THEN cast(9999 as decimal(10,0)) ELSE cast(sms_allowance as decimal(10,0)) END as sms_allowance,
cast(total_usage as decimal(10,5)) total_usage,
cast(total_income_min as decimal(10,5)) total_income_min,
cast(total_outgoing_min as decimal(10,5)) total_outgoing_min,
cast(total_messages as decimal(10,5)) total_messages,
date
from datamart.dim_addons_usage_consamption_daily),
temp as (select
msisdn,
ocs_subscriber_id,
ocs_subscription_id,
tariff_plan_name,
nvl(data_allowance,0.0) data_allowance,
sum(total_usage) total_data_usage,
nvl(voice_allowance,0.0) voice_allowance,
sum(total_income_min) total_income_min,
sum(total_outgoing_min) total_outgoing_min,
nvl(sms_allowance,0.0) sms_allowance,
sum(total_messages) total_messages
from total_usages
group by msisdn,ocs_subscriber_id,ocs_subscription_id,tariff_plan_name,data_allowance,voice_allowance,sms_allowance
order by msisdn, ocs_subscriber_id, ocs_subscription_id)
select
msisdn,
ocs_subscriber_id,
ocs_subscription_id,
tariff_plan_name,
data_allowance,
total_data_usage,
CASE WHEN data_allowance-total_data_usage < 0 THEN data_allowance-total_data_usage ELSE 0 END as total_data_lost,
voice_allowance,
total_income_min,
total_outgoing_min,
CASE WHEN voice_allowance-total_outgoing_min < 0 THEN voice_allowance-total_outgoing_min ELSE 0 END as total_voice_lost,
sms_allowance,
total_messages,
CASE WHEN sms_allowance-total_messages < 0 THEN sms_allowance-total_messages ELSE 0 END as total_sms_lost,
'usages' as part_key
from temp