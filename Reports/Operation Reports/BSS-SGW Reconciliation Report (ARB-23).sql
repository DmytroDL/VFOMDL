/*
Request

We have a situation where BSS and SGW are not in sync, there are scenario where we have customer, individual, billing account, subscribers created in BSS but not available in SGW, due to failure of API-GW, So we wish to fetch the details for all the customer from Data lake in csv, so that SGW can validate on their side.
Below is the list of fields needed

SGW ID
Customer ID
Customer Status
Individual ID
First Name
Last Name
Email
Billing account ID
Subscriber ID
*/
with cont_meth as (select distinct individual_id,email_address
from refined.dim_contactmethod
where email_address is not null)
select distinct ind.sgw_id SGW_ID, cu.customer_id CUSTOMER_ID,
cu.account_status_value CUSTOMER_STATUS,ind.individual_id INDIVIDUAL_ID,
cm.email_address EMAIL,ba.object_id BILLING_ACCOUNT_ID,
bpi.ocs_subscriber_id SUBSCRIBER_ID,
ci.msisdn
from refined.dim_individual ind
join refined.dim_customer cu on cu.primary_individual_id = ind.individual_id
left join cont_meth cm on cm.individual_id = ind.individual_id
left join refined.dim_billing_account ba on ba.customer_ref = cu.customer_ref
left join refined.dim_businessproductinstances bpi on bpi.customer_id = cu.customer_id and bpi.tariff_plan_name = 'Mobile Line' and bpi.billing_account_id = ba.object_id
left join refined.dim_customer_info ci on ci.ocs_subscriber_id = bpi.ocs_subscriber_id
where ind.sgw_id is not null
order by ind.sgw_id;