select pr.event_code, pr.payment_request_id, pr.total_amount_with_vat_value, prs.state, prs.created
from refined.vf_fct_payment_request pr
         join refined.vf_fct_payment_request_status prs on (pr.payment_request_id=prs.payment_request_id)
         join (select payment_request_id, max(created) as MaxDate from refined.vf_fct_payment_request_status group by payment_request_id) groupped
              on (pr.payment_request_id=groupped.payment_request_id)
                  and prs.created=groupped.MaxDate
where requestor_individual_id='{requestor_individual_id}';