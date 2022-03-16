/*
NCAA-783: [Report] Silver Number staticis of 24/1/2022
*/

--sales orders
with sales_ord as (select
bpi_tlo.baseline_sales_order,
so.sales_order_status,
oi_line.msisdn
FROM interim.r_oe_bpi bpi_tlo
JOIN interim.r_oe_order_item oi_tlo ON ( oi_tlo.parent_id = bpi_tlo.baseline_sales_order AND oi_tlo.reference_to_bpi = bpi_tlo.object_id )
JOIN interim.r_oe_bpi bpi_line ON bpi_line.parent_id = bpi_tlo.object_id
LEFT JOIN interim.r_oe_order_item oi_line ON ( oi_line.reference_to_bpi = bpi_line.object_id AND oi_tlo.object_id = oi_line.parent_id )
join interim.r_oe_sales_ord so on so.object_id = bpi_tlo.baseline_sales_order
where bpi_line.name like 'Mobile Line%'),
--all accounts
all_acc as (select
ca.object_id,
min(ca.modified_when) modified_when
from raw.r_cim_cust_account ca
join refined.dim_customer cu on cu.customer_id = ca.object_id and cu.account_status_value = trim(REGEXP_EXTRACT(ca.status, '(.*#(?:[0-9a-fA-F]{3}){1,2}[$])?(.*)', 2))
group by ca.object_id)

select
pn.customer_id,
pn.pn_id,
cu.account_status_value,
aa.modified_when status_changed_when,
pn.logical_status_value,
pn.vip_category_name,
pn.phone_number,
pn.reservation_date,
sales_ord.baseline_sales_order sales_order_id,
trim(REGEXP_EXTRACT(sales_ord.sales_order_status, '(.*#(?:[0-9a-fA-F]{3}){1,2}[$])?(.*)', 2)) sales_order_status
from refined.dim_phone_number pn
left join refined.dim_customer cu on cu.customer_id = pn.customer_id
left join sales_ord on sales_ord.msisdn = pn.pn_id
left join all_acc aa on aa.object_id = cu.customer_id
where
pn.vip_category_name='Silver'
and (to_date(in_service_date) > '2022-01-23' or in_service_date is null)
order by pn.customer_id desc