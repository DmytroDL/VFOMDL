/*
 Request
Report for zero-balanced subscribers that are able to do charges  (calls, SMS, Data, Charges from Balance)

To show:

MSISDN , Billing Account ID ,Product/Tariff Plan
 */
select
    balance.amount as consumed_amount,
    balance.paymentAmount as payed_amount,
    subs.msisdn as msisdn,
    subs.tariff_plan_name as tariff_plan_name,
    subs.billing_account_id as billing_account_id
from
    (
        select SUM(ce.amount) as amount,
               SUM(pr.total_amount_with_vat_value) as paymentAmount,
               ce.ocs_subscriber_id as ocs_subscriber_id
        from refined.dim_ocs_costedevent ce
                 join refined.vf_fct_payment_request pr on pr.ocs_subscriber_id = ce.ocs_subscriber_id
            and ce.transaction_type not in ('Upfront Payment', 'Top-up')
                 join refined.vf_fct_payment_request_status ps on
                    ps.payment_request_id  = pr.payment_request_id and ps.state = 'DONE'
        group by ce.ocs_subscriber_id
        having amount > paymentAmount
    ) balance
        join refined.vf_dim_subscription subs on subs.ocs_subscriber_id  = balance.ocs_subscriber_id