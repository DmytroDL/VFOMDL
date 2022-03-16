select
smr.customer_ref,
ci.customer_id,
smr.ocs_subscriber_id,
ci.account_num,
ci.msisdn,
smr.avg_usage
from
(select
customer_ref,ocs_subscriber_id,
sum (total_volume)/1073741824 total_usages,
count(distinct `date`) days_of_usage,
(sum (total_volume)/1073741824)/count(distinct `date`) avg_usage
from refined.fct_prepaid_usages
where record_type_value = 'Data'
group by customer_ref,ocs_subscriber_id) smr
left join refined.dim_customer_info ci on ci.ocs_subscriber_id = smr.ocs_subscriber_id
where smr.avg_usage > 1;