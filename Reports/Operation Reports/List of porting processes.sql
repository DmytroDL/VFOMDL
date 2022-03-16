/*
Request
msisdn_bss_id

msisdn

bss bpi status
*/
select oi.msisdn, sub.msisdn, oi.msisdn_tech, bpi.ext_business_prod_inst_stat as BSS_BPI_status from interim.r_oe_order_item  oi
join interim.r_oe_bpi bpi on (oi.porting_process_id=bpi.porting_process_id)
join refined.vf_dim_subscription sub on (oi.msisdn=sub.msisdn_id)
where oi.porting_process_id is not null;