/*
 Goal of report
The System provides the quantity of the Activated Physical Sim Cards and Activated ESims.

To identify SIM cards that were activated the following conditions should be added:
dim_sim_card table:
sim_card_logical_status_value = ‘In Use’

dim_esim table:
activation_state_value = ‘Activated’
esim_logical_status_value = 'Assigned'
 */

 /*
  Information about ESIM:
  */
select 
ds.activation_state_value, ds.imsi, dm.item_model_name, bpi.actual_start_date, bpi.distribution_channel_value, ds.`date`
from refined.dim_esim ds
join refined.dim_item_model dm on ds.item_model_id = dm.item_model_id
left join refined.dim_businessproductinstances bpi on cast(ds.iccid as decimal(20,0)) = bpi.iccid
where ds.activation_state_value = 'Activated' and ds.esim_logical_status_value = 'Assigned'

/*
 Information about Physical SIM:
 */

select sc.imsi, bpi.actual_start_date, dm.item_model_name,sc.sim_card_logical_status_value, dm.item_model_name, bpi.distribution_channel_value, sc.date
from dim_sim_card sc
         join dim_item_model dm
              on sc.item_model_id = dm.item_model_id
         left join dim_businessproductinstances bpi
                   on sc.iccid = bpi.iccid
where sc.sim_card_logical_status_value  = ‘In Use’
