with bc as (select
dense_rank() over (partition by ocs_subscriber_id order by activation_date) as subscription_cycle_id,
ocs_subscriber_id,
ocs_subscription_id,
productoffering_name,
lag(productoffering_name) over (partition by ocs_subscriber_id order by activation_date) as prev_tariff,
activation_date,
lead(activation_date) over (partition by ocs_subscriber_id order by activation_date) as next_activation_date,
renewal_date
from refined.fct_prepaid_charges
where lower(is_payg) = 'n' and bpi_id not like '%RACK' and event_type ='addSubscriptionRequest' /* TLO and Addons */
order by subscription_cycle_id)

select
ci.msisdn msisdn,
bc.prev_tariff prev_tariff_plan_name,
bc.productoffering_name new_tariff_plan_name,
nvl(sub.subs_status_value,'NA') mobile_line_status,
bc.activation_date date_start,
bc.next_activation_date date_end
from refined.dim_customer_info ci
join bc on ci.ocs_subscriber_id = bc.ocs_subscriber_id
left join refined.dim_subscription sub on sub.msisdn = ci.msisdn
order by ci.msisdn, bc.activation_date;