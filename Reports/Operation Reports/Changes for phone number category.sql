/*
Request is to provide all the changes for the phone number category through CSRD from Silver to Regular and and from Regular to Silver Numbers.
 */

with num_chg as (select
                     rpn.name,
                     count(distinct rpn.vip_category)
                 from interim.r_pb_phone_number ipn
                          join raw.r_pb_phone_number rpn on rpn.name = ipn.name
                 group by rpn.name
                 having count(distinct rpn.vip_category)>1),
     chng_arr as (select row_number() over (partition by rpn.name order by rpn.modified_when) as rownum,
                         rpn.name,
                         rpn.object_id,
                         rpn.vip_category,
                         dim_pn_categories.value as vip_category_name,
                         rpn.modified_when
                  from interim.r_pb_phone_number ipn
                           join raw.r_pb_phone_number rpn on rpn.name = ipn.name
                           left join interim.nc_ref_dict as dim_pn_categories on (cast(rpn.vip_category as string) = dim_pn_categories.id and dim_pn_categories.`table`='dim_pn_categories')
                  where ipn.name in (select name from num_chg)
                  order by rpn.name,rpn.modified_when)
select
    t1.name as phone_number,
    t1.object_id TOMS_ID,
    t1.vip_category_name as prev_type,
    t2.vip_category_name as new_type,
    t2.modified_when as changed_when
from chng_arr t1
         join chng_arr t2 on t1.name = t2.name and cast(t2.rownum as int) = (cast(t1.rownum as int) + 1)
where
    t1.vip_category_name != t2.vip_category_name
order by phone_number, changed_when;
