/*
Request

ocs_subscriber_id

event_type

amount

transaction_id

transaction status

date and time
*/
select
pp.ocs_subscriber_id,
pp.event_type,
pp.offer_price as amount,
pp.transaction_id,
pp.result_message as status,
pp.event_dtm as datandtime
from interim.prepaid_provisioning pp
where lower(pp.event_type) in ('addsubscriptionrequest') --- EDR PROV
union
select
pmt.ocs_subscriber_id,
pmt.event_type,
pmt.balance_amount as amount,
pmt.transaction_id,
pmt.result_message,
pmt.event_dtm as datandtime
from interim.prepaid_payments pmt
where lower(pmt.event_type) in ('creditbalance', 'debitbalances', 'debitbalance') ---EDR ВMP
union
select
pch.ocs_subscriber_id,
pch.event_type,
pch.charged_amount as amount,
pch.transaction_id,
pch.result_message as status,
pch.event_dtm as datandtime
from interim.prepaid_charges pch
where lower(pch.event_type) in ('renewal') --- EDR HBR
order by amount desc;