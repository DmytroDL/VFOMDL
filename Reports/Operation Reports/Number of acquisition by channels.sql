/*
Request

NCAA-828: [Report] Sales – Number of acquisition by Channels in MVA, MPOS, ESTOREDONE
*/

select count(1) as totalCount, distribution_channel_value
from  refined.vf_dim_subscription
where actual_start_date between ('2022-02-13 00:00:00') and ('2022-02-19 23:59:00')
group by distribution_channel_value