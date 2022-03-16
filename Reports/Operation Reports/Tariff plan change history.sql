with hist as (select
                  distinct
                  bh.subs_id,
                  bh.productoffering_name,
                  bh.date_change_productoffering
              from refined.fct_bpi_history bh
                       join REFINED.dim_productofferings dpo on dpo.external_id = bh.external_id
              where dpo.is_top_offer = 'Yes'),
     chng_arr as (select
                      row_number() over (partition by h.subs_id order by h.date_change_productoffering) as rownum,
                      h.subs_id,
                      h.productoffering_name,
                      h.date_change_productoffering
                  from hist h),
     rslts as (select
                   t1.subs_id as subs_id,
                   t1.productoffering_name as prev_tariff,
                   CASE WHEN t2.productoffering_name is NULL THEN t1.productoffering_name ELSE t2.productoffering_name END as new_tariff,
                   t1.date_change_productoffering tariff_start_date,
                   t2.date_change_productoffering tariff_end_date
               from chng_arr t1
                        left join chng_arr t2 on t1.subs_id = t2.subs_id and cast(t2.rownum as int) = (cast(t1.rownum as int) + 1)
               order by subs_id, tariff_start_date,tariff_end_date)
select
    substr(bpi.name,instr(bpi.name,'|')+2,8) msisdn,
    trim(REGEXP_EXTRACT(bpi.ext_business_prod_inst_stat, '(.#(?:[0-9a-fA-F]{3}){1,2}[$])?(.)', 2)) as subs_status_value,
    rslts.prev_tariff prev_tariff,
    rslts.new_tariff new_tariff,
    rslts.tariff_start_date tariff_start_date,
    rslts.tariff_end_date tariff_change_date
from rslts
         join interim.r_oe_bpi bpi on bpi.object_id = rslts.subs_id
order by msisdn,tariff_start_date,tariff_end_date