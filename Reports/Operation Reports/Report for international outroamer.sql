/*
Need to provide dump and query for international outroamer ( person travelling outside oman) details to include MSISDN, country, IMSI. Query need to be date specific
*/
select
usages.event_dtm event_date,
sub.msisdn as msisdn,
sub.imsi as imsi,
usages.ocs_subscriber_id,
usages.roaming_country
from refined.dim_subscription sub
join interim.prepaid_usages usages
on usages.ocs_subscriber_id = sub.ocs_subscriber_id
where roaming_country != 'Oman'
order by usages.event_dtm desc