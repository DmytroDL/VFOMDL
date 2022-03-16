/*
Request

sgw_id

customer name

email

civil_id, passport

date of birth

sales order status

sales order number

distribution channel

plan price from bss

special number price from bss

sum of plan price and special number price from bss

payment amount from ZPP
*/
select
distinct
ind.sgw_id sgw_id,
cu.customer_ref customer_ref,
cm.email_address email,
idd.document_type_value document,
idd.document_number document_number,
ind.date_of_birth date_of_birth,
trim(REGEXP_EXTRACT(so.sales_order_status, '(.*#(?:[0-9a-fA-F]{3}){1,2}[$])?(.*)', 2)) sales_order_status,
so.sales_order_number sales_order_number,
dc.distribution_chanel_value distribution_chanel,
upf.summ_mrc_bss plan_price_bss,
oi.totalForPremiumPhoneNumber as special_price_number_bss,
nvl(upf.summ_mrc_bss,0)+nvl(oi.totalForPremiumPhoneNumber,0) as plan_and_special_total_bss,
sp.zentity_payments as payments_zpp
from refined.dim_individual ind
join refined.dim_customer cu on cu.customer_ref = ind.primary_customer_ref
join refined.dim_contactmethod cm on cm.contact_method_id = ind.primary_email_id
join refined.dim_id_document idd on idd.individual_id = ind.individual_id
join interim.r_oe_sales_ord so on so.customer_account = cu.customer_id
left join refined.dim_distribution_chanel dc on dc.distribution_chanel_id = so.distr_ch
left join
(
  select oi.root_parent_id as sales_order_number , oi.total_price_with_tax_nrc as totalForPremiumPhoneNumber
    from interim.r_oe_order_item oi
    join interim.poc_offering po on po.flat_offering_id = oi.flat_offering_id
    where oi.total_price_with_tax_nrc > 0 and po.external_id = 'MobPrepPNumber'
) oi on oi.sales_order_number = so.object_id
left join
(
select pr.sales_order_id, sum(pr.total_amount_with_vat_value) zentity_payments
from refined.vf_fct_payment_request pr
join refined.vf_fct_payment_request_status rs on rs.payment_request_id = pr.payment_request_id
where rs.state in ('DONE')
group by sales_order_id
) sp on sp.sales_order_id = so.object_id
left join
(
select oi.root_parent_id, sum(nvl(oi.upfront_payment_mrc,0)) summ_mrc_bss
from interim.r_oe_order_item oi
group by oi.root_parent_id
) upf on upf.root_parent_id = so.object_id;