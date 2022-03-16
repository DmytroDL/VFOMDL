/*
All statuses without split for Reserved by Anonymous and Deanonymized
*/
select
logical_status_value msisdn_status, count(logical_status_value) as count
from refined.dim_phone_number
group by logical_status_value;

/*
All statuses with split for Reserved by Anonymous and Deanonymized with Reserved Total
*/
with cnt_all as (select
CASE
WHEN logical_status_value = 'Reserved' THEN 'Reserved | Total'
ELSE logical_status_value
END as msisdn_status,
count(logical_status_value) as count
from refined.dim_phone_number
group by logical_status_value
union
select
'Reserved | Non-anonymous' msisdn_status, count(pn.logical_status_value) as count
from (select distinct pn.pn_id,pn.logical_status_value
from refined.dim_phone_number pn
join refined.dim_customer c on (pn.customer_id=c.customer_id)
join refined.dim_id_document doc on (doc.individual_id=c.primary_individual_id)
where pn.logical_status_value = 'Reserved') pn
union
select
'Reserved | Anonymous' msisdn_status, count(pn.logical_status_value) as count
from refined.dim_phone_number pn
left join refined.dim_customer c on (pn.customer_id=c.customer_id)
left join refined.dim_id_document doc on (doc.individual_id=c.primary_individual_id)
where pn.logical_status_value = 'Reserved' and doc.document_id is null)
select * from cnt_all order by msisdn_status;

/*
All statuses with split for Reserved by Anonymous and Deanonymized without Reserved Total (for graphs)
*/
select
logical_status_value msisdn_status, count(logical_status_value) as count
from refined.dim_phone_number
where logical_status_value != 'Reserved'
group by logical_status_value
union
select
'Reserved | Non-anonymous' msisdn_status, count(pn.logical_status_value) as count
from (select distinct pn.pn_id,pn.logical_status_value
from refined.dim_phone_number pn
join refined.dim_customer c on (pn.customer_id=c.customer_id)
join refined.dim_id_document doc on (doc.individual_id=c.primary_individual_id)
where pn.logical_status_value = 'Reserved') pn
union
select
'Reserved | Anonymous' msisdn_status, count(pn.logical_status_value) as count
from refined.dim_phone_number pn
left join refined.dim_customer c on (pn.customer_id=c.customer_id)
left join refined.dim_id_document doc on (doc.individual_id=c.primary_individual_id)
where pn.logical_status_value = 'Reserved' and doc.document_id is null
order by msisdn_status;
