/*
 Request
NCAA-748: Report request - List of Customer with their active numbersDONE

To generate the report on AA side which would reflect the following information:

customer_ref

billing account

civil document type (Oman ID, Passport, ..)

civil document number

customer name

tariff plan name

activation date

msisdn
 */

select distinct ds.customer_ref customer_reference, ds.account_num billing_account_num, d.document_name, d.document_number, cust.full_name full_name, ds.tariff_plan_name, bpi.actual_start_date, ds.msisdn msisdn, bpi.distribution_channel_value
from refined.dim_subscription ds
         left join interim.r_am_esim esim ON ds.iccid_id = esim.object_id
         left join interim.r_am_sim_card sim ON cast(ds.iccid_id as string) = sim.name
         left join refined.dim_customer cust on (cust.customer_ref=ds.customer_ref)
         left join refined.dim_businessproductinstances bpi on (bpi.ocs_subscriber_id=ds.ocs_subscriber_id and bpi.ocs_subscription_id=ds.ocs_subscription_id)
         left join refined.dim_id_document d on (cust.primary_individual_id=d.individual_id)
where (sim.activation_state_ = 'Activated' or esim.activation_state_ = 'Activated')
order by ds.customer_ref;