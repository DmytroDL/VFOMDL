--Recharges (DECEMBER and JANUARY)

with smr as (select
transaction_type as Type,
sum(amount) total,
'December' as month
from refined.dim_ocs_costedevent
where transaction_type in ('Top-up','Balance Adjustment','Upfront Payment')
and to_date(event_dtm) <= ('2021-12-31')
group by transaction_type
union
select
transaction_type as Type,
sum(amount) total,
'January' as month
from refined.dim_ocs_costedevent
where transaction_type in ('Top-up','Balance Adjustment','Upfront Payment')
and to_date(event_dtm) <= '2022-01-31' and to_date(event_dtm) >= '2022-01-01'
group by transaction_type),
ttl as(select type,total,month from smr
union
select 'Grand.Total' as type,sum(total),'-' as month from smr
union
select 'December.Total' as type,sum(total),'-' as month from smr where month = 'December'
union
select 'January.Total' as type,sum(total),'-' as month from smr where month = 'January')
select type,total,month from ttl order by month desc, total asc;

--Usages for DECEMBER

  with dec_usg as(select
  t.product_name,
  sum(t.amount) value
  from (select
  CASE
  WHEN productoffering_name = 'Mobile Line' THEN 'Vodafone Blue'
  WHEN productoffering_name = 'Vodafone Blue' THEN 'Vodafone Blue'
  WHEN productoffering_name = 'Launch Offer' THEN 'Launch Offer'
  WHEN productoffering_name = '2021 Launch Offer' THEN '2021 Launch Offer'
  WHEN transaction_type = 'One-Time Charge' and event_type = 'One-Time Charge' THEN 'One-Time Service'
  ELSE 'Addons' end product_name,
  amount,
  transaction_type
  from refined.dim_ocs_costedevent
  where transaction_type in ('Usage')
  and to_date(event_dtm) <= '2021-12-31'
  and amount is not null
  and amount <> 0) t
  group by t.product_name),

  dec_chrg as(select
  t.product_name,
  sum(t.amount) value
  from (select
  CASE
  WHEN productoffering_name = 'Mobile Line' THEN 'Vodafone Blue'
  WHEN productoffering_name = 'Vodafone Blue' THEN 'Vodafone Blue'
  WHEN productoffering_name = 'Launch Offer' THEN 'Launch Offer'
  WHEN productoffering_name = '2021 Launch Offer' THEN '2021 Launch Offer'
  WHEN transaction_type = 'One-Time Charge' and event_type = 'One-Time Charge' THEN 'One-Time Service'
  ELSE 'Addons' end product_name,
  amount,
  transaction_type
  from refined.dim_ocs_costedevent
  where transaction_type in ('One-Time Charge','Recurrent Charge')
  and to_date(event_dtm) <= '2021-12-31'
  and amount is not null
  and amount <> 0) t
  group by t.product_name)

  select nvl(dec_chrg.product_name,dec_usg.product_name) product_name,dec_usg.value Usages,dec_chrg.value Charges,nvl(dec_usg.value,0)+nvl(dec_chrg.value,0) total,'December' as month
  from dec_usg full join dec_chrg on dec_chrg.product_name=dec_usg.product_name

  --Usages for JANUARY

  with jan_usg as(select
  t.product_name,
  sum(t.amount) value
  from (select
  CASE
  WHEN productoffering_name = 'Mobile Line' THEN 'Vodafone Blue'
  WHEN productoffering_name = 'Vodafone Blue' THEN 'Vodafone Blue'
  WHEN productoffering_name = 'Launch Offer' THEN 'Launch Offer'
  WHEN productoffering_name = '2021 Launch Offer' THEN '2021 Launch Offer'
  WHEN transaction_type = 'One-Time Charge' and event_type = 'One-Time Charge' THEN 'One-Time Service'
  ELSE 'Addons' end product_name,
  amount,
  transaction_type
  from refined.dim_ocs_costedevent
  where transaction_type in ('Usage')
  and to_date(event_dtm) >= '2022-01-01' and to_date(event_dtm) <= '2022-01-31'
  and amount is not null
  and amount <> 0) t
  group by t.product_name),

  jan_chrg as(select
  t.product_name,
  sum(t.amount) value
  from (select
  CASE
  WHEN productoffering_name = 'Mobile Line' THEN 'Vodafone Blue'
  WHEN productoffering_name = 'Vodafone Blue' THEN 'Vodafone Blue'
  WHEN productoffering_name = 'Launch Offer' THEN 'Launch Offer'
  WHEN productoffering_name = '2021 Launch Offer' THEN '2021 Launch Offer'
  WHEN transaction_type = 'One-Time Charge' and event_type = 'One-Time Charge' THEN 'One-Time Service'
  ELSE 'Addons' end product_name,
  amount,
  transaction_type
  from refined.dim_ocs_costedevent
  where transaction_type in ('One-Time Charge','Recurrent Charge')
  and to_date(event_dtm) >= '2022-01-01' and to_date(event_dtm) <= '2022-01-31'
  and amount is not null
  and amount <> 0) t
  group by t.product_name)

  select
  nvl(jan_chrg.product_name,jan_usg.product_name) product_name,
  jan_usg.value Usages,
  jan_chrg.value Charges,
  nvl(jan_usg.value,0)+nvl(jan_chrg.value,0) total,
  'January' as month
  from jan_usg full join jan_chrg on jan_chrg.product_name=jan_usg.product_name;

  --Balance decemeber

    with usages as (select
    sum(ce.amount) as value,
    'December' as month
    from refined.dim_ocs_costedevent ce
    where ce.transaction_type in ('Usage','One-Time Charge','Recurrent Charge')
    and to_date(ce.event_dtm) <= '2021-12-31'),
    topups as (select
    sum(pr.total_amount_with_vat_value) as value,
    'December' as month
    from refined.vf_fct_payment_request pr
    join refined.vf_fct_payment_request_status ps on ps.payment_request_id  = pr.payment_request_id and ps.state = 'DONE'
    where to_date(pr.created) <= '2021-12-31')
    select
    topups.month,
    topups.value Top_Ups,
    usages.value Usages,
    topups.value - usages.value Balance
    from usages
    join topups on topups.month = usages.month

    --Balance january

      with usages as (select
      sum(ce.amount) as value,
      'January' as month
      from refined.dim_ocs_costedevent ce
      where ce.transaction_type in ('Usage','One-Time Charge','Recurrent Charge')
      and to_date(ce.event_dtm) >= '2022-01-01' and to_date(ce.event_dtm) <= '2022-01-31'),
      topups as (select
      sum(pr.total_amount_with_vat_value) as value,
      'January' as month
      from refined.vf_fct_payment_request pr
      join refined.vf_fct_payment_request_status ps on ps.payment_request_id  = pr.payment_request_id and ps.state = 'DONE'
      where to_date(pr.created) >= '2022-01-01' and to_date(pr.created) <= '2022-01-31')
      select
      topups.month,
      topups.value Top_Ups,
      usages.value Usages,
      topups.value - usages.value Balance
      from usages
      join topups on topups.month = usages.month