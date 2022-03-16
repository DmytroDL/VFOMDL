--VFOMOP-2288: [WR] Wean Offer ReportBO RFA REQUEST

--Daily count of subscribers on Wean discount (cumulative)
select
t.active_from,
t.cnt as count_per_day,
sum(t.cnt) over (order by t.active_from) as total_count
from
(select
to_date(di.active_from) active_from,
count(di.object_id) cnt
from interim.R_OE_DISC_INSTANCE di
join interim.R_OE_DISC_INSTANCE_T_BPIS tb on (di.object_id=tb.object_id)
join refined.dim_businessproductinstances pi on cast(tb.value as decimal)=pi.bpi_id
join refined.dim_customer c on (pi.customer_ref=c.customer_ref)
join refined.dim_individual i on (c.customer_ref=i.primary_customer_ref)
where di.status__id=9132857804713527191
and di.flat_discount_id='6664000081'
group by to_date(di.active_from)) t
order by t.active_from desc;

--Detailed summary report for subscribers on Wean discount
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
chng_arr1 as (select
h.subs_id,
count(*) cnt
from hist h
group by h.subs_id),
prev as (select
t.subs_id,
t.productoffering_name,
t.date_change_productoffering,
case when t1.cnt > 1 then t1.cnt-1 else 1 end as prev,
t.rownum,
t1.cnt
from chng_arr t
join chng_arr1 t1 on t.subs_id = t1.subs_id
order by subs_id)
select
c.first_name, i.sgw_id, di.active_from, di.active_to, pi.tariff_plan_name, prev.productoffering_name as prev_tariff_plan_name
from interim.R_OE_DISC_INSTANCE di
join interim.R_OE_DISC_INSTANCE_T_BPIS tb on (di.object_id=tb.object_id)
join refined.dim_businessproductinstances pi on cast(tb.value as decimal)=pi.bpi_id
join refined.dim_customer c on (pi.customer_ref=c.customer_ref)
join refined.dim_individual i on (c.customer_ref=i.primary_customer_ref)
join prev on prev.subs_id = pi.bpi_id and prev.prev = prev.rownum
where di.status__id=9132857804713527191
and di.flat_discount_id='6664000081';