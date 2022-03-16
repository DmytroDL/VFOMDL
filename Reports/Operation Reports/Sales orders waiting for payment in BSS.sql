/*
Request
Request is to provide the list of all sales orders waiting for payment. Columns:

sales order id

sales order name

sales order creation date

customer account id in BSS

customer name

email address

phone number
*/
select distinct so.object_id as SalesOrderId,
so.name as SalesOrderName,
so.created_when as SalesOrderCreatedWhen,
so.customer_account as CustomerAccount,
cmEmail.email_address as Email,
cmPhone.mobile_type_value as Phone
from interim.r_oe_sales_ord so
join refined.dim_customer c on (so.customer_account=c.customer_id)
join
(select distinct primary_customer_ref, email_address from  refined.dim_contactmethod where email_address is not null) cmEmail
 on (c.customer_ref=cmEmail.primary_customer_ref)
join
(select distinct primary_customer_ref, mobile_type_value from  refined.dim_contactmethod where mobile_type_value is not null) cmPhone
 on (c.customer_ref=cmPhone.primary_customer_ref)
where so.sales_order_status='6#FFF200$Pending payment'
and so.created_when > from_unixtime(unix_timestamp('03-01-2022 00:00' , 'dd-MM-yyyy hh:mm'))
and so.created_when < from_unixtime(unix_timestamp('09-01-2022 23:59' , 'dd-MM-yyyy hh:mm'))
order by so.created_when, so.customer_account;