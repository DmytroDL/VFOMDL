/*
 Request
is to get the report on AA side to get the information below:

Order ID

Order type (AIM)

Submission Time (submission time)

Distribution Channel

Completion Time (processed time)
 */
select so.name as SO_Name,
       so.sales_order_number as order_number,
       (case
            when oi.action_ != '-'
then oi.action_
            when oi_lvl1.action_ != '-'
then oi_lvl1.action_
            else oi_lvl2.action_
           end) as orderType,
       so.submitted_when orderSubmitted,
       dc.distribution_chanel_value as distribution_channel,
       so.processed_when as Completed,
       so.sales_order_status as SOstatus
from interim.r_oe_sales_ord so
         join (SELECT Max(action_) as action_, parent_id as parent_id, Max(object_id) as object_id
               FROM INTERIM.r_oe_order_item
               GROUP BY parent_id) oi on oi.parent_id = so.object_id
         JOIN refined.dim_distribution_chanel dc on dc.distribution_chanel_id = so.distr_ch
         LEFT JOIN INTERIM.r_oe_order_item oi_lvl1 on oi_lvl1.parent_id = oi.object_id
         LEFT JOIN INTERIM.r_oe_order_item oi_lvl2 on oi_lvl2.parent_id = oi_lvl1.object_id
where so.sales_order_status_id in( '9129643639813420226', '9134715141813992683')
    LikeBe the first to like this
