/*
Request
RCA

MSISDN

STATUS

OCS_SUBSCRIBER_ID

ICCID

MOBILE_PLAN

IMSI

SALES_ORDER_ID

SALES_ORDER_NUMBER

SALES_ORDER_STATUS

SGW_ID

Account status

DELIVERY_TYPE

SO created when

SO submitted when
*/

with payment_type as (select
distinct
so.object_id,
bpi.payment_type type_of_delivery
from interim.r_oe_sales_ord so
join interim.r_oe_bpi bpi on bpi.baseline_sales_order = so.object_id
where bpi.payment_type is not null),
contact_method as (select
row_number() over (partition by ea.individual_id order by pn.mobile_type_value desc,ea.email_address desc) as rownum,
ea.primary_customer_ref,
ea.individual_id,
ea.email_address,
pn.mobile_type_value,
pn.contact_days,
pn.contact_hours
from
refined.dim_contactmethod ea
full join refined.dim_contactmethod pn on pn.individual_id = ea.individual_id
where
ea.is_preferred_flag = 'Yes' and pn.is_preferred_flag = 'Yes'),
type1 as (select
cu.customer_ref customer_ref,
sub.msisdn msisdn,
cu.account_status_value account_status,
sub.ocs_subscriber_id ocs_subscriber_id,
sub.iccid_id iccid,
bpi.name mobile_plan,
sub.imsi imsi,
so.object_id sales_order_id,
so.sales_order_number sales_order_number,
trim(REGEXP_EXTRACT(so.sales_order_status, '(.*#(?:[0-9a-fA-F]{3}){1,2}[$])?(.*)', 2)) sales_order_status,
ind.sgw_id sgw_id,
pt.type_of_delivery,
cm.email_address,
cm.mobile_type_value,
cm.contact_days,
cm.contact_hours
from interim.r_oe_sales_ord so
join refined.dim_customer cu on cu.customer_id = so.customer_account
join interim.r_oe_bpi bpi on bpi.baseline_sales_order = so.object_id
join refined.dim_subscription sub on sub.ocs_subscription_id = nvl(bpi.ocs_subscription_id,bpi.ocs_def_subscription_id) and bpi.object_id = sub.subs_id
join refined.dim_individual ind on ind.primary_customer_ref = cu.customer_ref
join contact_method cm on cm.individual_id = ind.individual_id and cm.rownum = 1
left join payment_type pt on pt.object_id = so.object_id),
type2 as (select
cu.customer_ref customer_ref,
null as msisdn,
cu.account_status_value account_status,
null as ocs_subscriber_id,
null as iccid,
null as mobile_plan,
null as imsi,
so.object_id sales_order_id,
so.sales_order_number sales_order_number,
trim(REGEXP_EXTRACT(so.sales_order_status, '(.*#(?:[0-9a-fA-F]{3}){1,2}[$])?(.*)', 2)) sales_order_status,
ind.sgw_id sgw_id,
pt.type_of_delivery,
cm.email_address,
cm.mobile_type_value,
cm.contact_days,
cm.contact_hours
from interim.r_oe_sales_ord so
left join type1 on type1.sales_order_id = so.object_id
join refined.dim_customer cu on cu.customer_id = so.customer_account
left join refined.dim_individual ind on ind.primary_customer_ref = cu.customer_ref
left join contact_method cm on cm.individual_id = ind.individual_id and cm.rownum = 1
left join payment_type pt on pt.object_id = so.object_id
where type1.customer_ref is null)
select * from type1
union
select * from type2
