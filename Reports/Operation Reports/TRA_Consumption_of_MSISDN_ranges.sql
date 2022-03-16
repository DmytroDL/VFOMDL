/*The System provides quantitative information about the current state of MSISDN consumption in the following dimensions:
Total Registered Numbers
Total Quarantine Numbers
Total Available Vanity Numbers
Total Ported Out Numbers

Registered: the system provides the quantity of the Phone Numbers that are in use by calculating all MSISDN with Logical Status = 'In Use'.
Quarantine: the System provides the quantity of the Phone Numbers that are quarantined by calculating all MSISDN with Logical Status = 'Pending'.
Available Vanity: the System provides the quantity of vanity Phone Numbers that are available by calculating all MSISDN with Logical Status = 'Available' and Category != 'Regular'.
Port out: the System provides the quantity of all Phone Numbers that were ported out by calculating all MSISDN with Logical Status = 'Ported Out'.
*/

select
    sum(case when dim_phone_number.logical_status_value = 'In Use' then 1 else 0 end) as totalRegisteredNumbers,
    sum(case when dim_phone_number.logical_status_value = 'Pending' then 1 else 0 end) as totalQuarantineNumbers,
    sum(case when dim_phone_number.logical_status_value = 'Available' and dim_phone_number.vip_category_name <> 'Regular' and dim_phone_number.vip_category_name <> 'Network Mobile Number' then 1 else 0 end) as totalAvailableVanityNumbers,
    sum(case when dim_phone_number.logical_status_value = 'Ported Out' then 1 else 0 end) as totalPortOutNumbers,
    sum(case when dim_phone_number.vip_category_name = 'Network Mobile Number' then 1 else 0 end) as totalTestNumbers
from refined.dim_phone_number