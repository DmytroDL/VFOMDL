select
pr.msisdn,
pr.total_amount_with_vat_value,
pr.created
from refined.vf_fct_payment_request pr
join refined.vf_fct_payment_request_status ps on ps.payment_request_id = pr.payment_request_id and ps.state = 'DONE'