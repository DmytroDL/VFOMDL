/*
Request

NCAA-821: [Report] Nationality Split of Active Customers DONE
*/
select count(primary_customer_ref) number_of_individuals,nationality_value from refined.dim_individual
where primary_customer_ref in
(select distinct cust.customer_ref as primary_customer_ref
from refined.dim_customer cust
left join refined.dim_individual indi
on indi.primary_customer_ref = cust.customer_ref
left join refined.dim_customer_info custinf
on cust.customer_ref = custinf.customer_ref
where cust.account_status_value = 'Active'
and (custinf.activation_date >= '2022-02-13'
and custinf.activation_date <= '2022-02-19')
) group by nationality_value
order by number_of_individuals desc;
