/*
Request

NCAA-824: [Report] Numbers of port outsDONE
*/
select * from refined.dim_phone_number ref
left join interim.r_pb_phone_number i on (ref.pn_id=i.object_id)
where logical_status_value='Ported Out'
and to_date(i.sys_modified_when) >= '2022-02-13'
and to_date(i.sys_modified_when) <= '2022-02-20'
order by i.sys_modified_when;