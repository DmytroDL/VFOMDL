/*
 Request
To see the count of SO distributed by statuses
 */
 --SQL Script All SO
select count(*) as count,SUBSTR( so.sales_order_status, 10) as status
from interim.r_oe_sales_ord so
    JOIN interim.r_poc_distribution_channel  dc on dc.object_id  = so.distr_ch
where so.created_when > from_unixtime(unix_timestamp('30-12-2021 00:00' , 'dd-MM-yyyy hh:mm'))
group by  SUBSTR( so.sales_order_status, 10)

--SQL Script PYAG SO
select count(*) as count,SUBSTR( so.sales_order_status, 10) as status
from interim.r_oe_sales_ord so
    JOIN interim.r_poc_distribution_channel  dc on dc.object_id  = so.distr_ch
    join (select distinct so.customer_account as customer_account
    from interim.r_oe_sales_ord so
    join interim.r_oe_order_item oi on oi.parent_id = so.object_id and oi.flat_offering_id = '6610000000'
    JOIN interim.r_poc_distribution_channel  dc on dc.object_id  = so.distr_ch
    where oi.action_ = 'Add'and so.created_when > from_unixtime(unix_timestamp('30-12-2021 00:00' , 'dd-MM-yyyy hh:mm'))) so_payg
    on so_payg.customer_account = so.customer_account
where so.created_when > from_unixtime(unix_timestamp('30-12-2021 00:00' , 'dd-MM-yyyy hh:mm'))
group by  SUBSTR( so.sales_order_status, 10)