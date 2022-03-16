/*
Request

NCAA-823: [Report] Numbers of port in DONE
*/
select
count(*)
from interim.r_pb_area_code ac
join interim.r_pb_100k_range hr on hr.parent_id = ac.object_id
join interim.r_pb_10k_range tr on tr.parent_id = hr.object_id
join interim.r_pb_phone_number pn on pn.parent_id = tr.object_id
where ac.object_id <> 9156806933813867300
and pn.logical_status in ('Assigned','In Use')
and (to_date(pn.created_when) >= '2022-02-13' and to_date(pn.created_when) <= '2022-02-19')