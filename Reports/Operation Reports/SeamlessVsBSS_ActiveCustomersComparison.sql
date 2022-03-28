select  pn.pn_name,
        SUBSTR( so.sales_order_status, 10) as status
from interim.r_oe_sales_ord so
         join (SELECT Max(action_) as action_, parent_id as parent_id, Max(object_id) as object_id
               FROM interim.r_oe_order_item
               GROUP BY parent_id) oi on oi.parent_id = so.object_id
         join interim.r_oe_order_item msisdn_oi on msisdn_oi.parent_id = oi.object_id
         JOIN interim.r_poc_distribution_channel  dc on dc.object_id  = so.distr_ch
         join refined.dim_phone_number pn on msisdn_oi.msisdn = pn.pn_id
where oi.action_ = 'Add' and SUBSTR( so.sales_order_status, 10) in ('Processing', 'Processed', 'Superseded') and
    so.submitted_when  between '2022-03-22' and '2022-03-23' and dc.name in ('Retail on wheel', 'Organized retailers', 'Flagship')