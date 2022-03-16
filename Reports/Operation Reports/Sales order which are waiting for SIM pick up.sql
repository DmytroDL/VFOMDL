/*
Provide the script which would show the number of sales orders which are waiting for SIM pick up, meaning sales order in processing state with order item Pick Up Point
*/

select count(*) from interim.r_oe_order_item oi
join interim.r_oe_sales_ord so on (oi.parent_id=so.object_id)
where oi.flat_offering_id='6640000001'
and so.sales_order_status='6#8CAA6E$Processing';