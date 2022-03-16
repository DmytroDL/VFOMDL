/*
 Request:
To generate the report on AA side which would reflect the following information:

sales order id

sales order number

date of order submission

product offering name

customer account id

distribution channel

completed date

sales order status

upfront payment amount with VAT
 */
select so.name as SO_Name,
       so.object_id as object_id,
       so.sales_order_number as order_number,
       so.submitted_when orderSubmitted,
       po.name,
       so.customer_account,
       dc.distribution_chanel_value as distribution_channel,
       so.processed_when as Completed,
       so.sales_order_status as SOstatus,
       so.upfront_payment  as upfront_payment
from interim.r_oe_sales_ord so
         join (SELECT Max(action_) as action_, parent_id as parent_id, Max(object_id) as object_id,
                      MAX (flat_offering_id) as flat_offering_id, MAX(one_time_basic_total_price) as price
               FROM INTERIM.r_oe_order_item
               GROUP BY parent_id) oi on oi.parent_id = so.object_id
         join interim.poc_offering po on oi.flat_offering_id = po.flat_offering_id
         JOIN refined.dim_distribution_chanel dc on dc.distribution_chanel_id = so.distr_ch
where po.flat_offering_id in (6640000000,6640000002,7640000000) and
        so.sales_order_status_id in( '9129643639813420226', '9134715141813992683')
order by so.sys_modified_when desc;