/*
 Request
To show charges for MSISDN
 */
select ce.amount, * from refined.dim_ocs_costedevent ce
                             join refined.vf_dim_subscription subs on subs.ocs_subscriber_id  = ce.ocs_subscriber_id
where ce.transaction_type not in ('Upfront Payment', 'Top-up') and ce.amount > 0 and
        msisdn = {MSISDN} and
    ce.event_dtm > 'yyyy-MM-dd'

