/*
 Request
MSISDN

Customer Account Number

Billing Account Number

Total Amount

Payment Method

Payment transaction id

Distribution Channel

Payment status

Sales order status.
 */

select pr.customer_ref as Customer_Account_Number,
       pr.account_num as Billing_Account_Number,
       pr.msisdn,
       pr.total_amount_with_vat_value as Total_Amount,
       pr.payment_request_id,
       pt.transaction_type as Payment_Method,
       pr.event_code as event_code,
       pt.payment_transaction_id as Transaction_Id,
       dc.distribution_chanel_value as Distribution_Channel,
       pts.state as Payment_Status,
       so.sales_order_status as Order_Status,
       pr.sales_order_id as Sales_order_id
from refined.vf_fct_payment_request pr
         join refined.vf_fct_payment_transaction pt on pt.payment_request_id = pr.payment_request_id
         join refined.vf_fct_payment_transaction_status pts on pts.payment_transaction_id = pt.payment_transaction_id
         join (select MAX (pts.created) as created, pt.payment_request_id from refined.vf_fct_payment_transaction_status pts join refined.vf_fct_payment_transaction pt on pts.payment_transaction_id = pt.payment_transaction_id group by pt.payment_request_id) ptsMax on ptsMax.created = pts.created and ptsMax.payment_request_id = pr.payment_request_id
         left join interim.r_oe_sales_ord so on pr.sales_order_id = so.object_id
         left join refined.dim_distribution_chanel dc on dc.distribution_chanel_id = so.distr_ch