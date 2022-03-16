select
pn.customer_id,
pn.logical_status_value,
pn.vip_category_name,
pn.phone_number,
ra.range_name
from refined.dim_phone_number pn
left join refined.dim_customer cu on cu.customer_id = pn.customer_id
left join refined.dim_100k_pn_range ra on ra.range_id = pn.parent_100k_range_id
where
pn.parent_100k_range_id in (9162353447613634348,9162353511713656053)
order by pn.customer_id desc;