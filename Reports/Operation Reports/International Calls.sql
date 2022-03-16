select
CASE
WHEN t.cto = '91' THEN 'India'
WHEN t.cto = '88' THEN 'Bangladesh'
WHEN t.cto = '20' THEN 'Egypt'
WHEN t.cto = '92' THEN 'Pakistan'
WHEN t.cto = '971' THEN 'UAE'
WHEN t.cto = '967' THEN 'Yemen'
WHEN t.cto = '966' THEN 'Saudi Arabia'
WHEN t.cto = '974' THEN 'Qatar'
WHEN t.cto = '94' THEN 'Sri Lanka'
WHEN t.cto = '90' THEN 'Turkey'
WHEN t.cto = '44' THEN 'Great Britain'
WHEN t.cto = '249' THEN 'Sudan'
WHEN t.cto = '977' THEN 'Nepal'
WHEN t.cto = '49' THEN 'Germany'
WHEN t.cto = '34' THEN 'Spain'
WHEN t.cto = '963' THEN 'Syria'
WHEN t.cto = '255' THEN 'Tanzania'
WHEN t.cto = '212' THEN 'Morocco'
WHEN t.cto = '216' THEN 'Tunisie'
WHEN t.cto = '60' THEN 'Malaysia'
WHEN t.cto = '254' THEN 'Kenya'
WHEN t.cto = '973' THEN 'Bahrain'
WHEN t.cto = '420' THEN 'Czech Republic'
WHEN t.cto = '1' THEN 'USA\Canada'
WHEN t.cto = '63' THEN 'Philippines'
WHEN t.cto = '233' THEN 'Ghana'
WHEN t.cto = '61' THEN 'Australia'
WHEN t.cto = '98' THEN 'Iran'
WHEN t.cto = '353' THEN 'Ireland'
WHEN t.cto = '234' THEN 'Nigeria'
ELSE t.cto END country,
count(t.called_number) No_of_calls
from (select
calling_number,
case
when calling_number like '97%' THEN substr(calling_number,1,3)
when calling_number like '96%' THEN substr(calling_number,1,3)
when calling_number like '24%' THEN substr(calling_number,1,3)
when calling_number like '25%' THEN substr(calling_number,1,3)
when calling_number like '21%' THEN substr(calling_number,1,3)
when calling_number like '42%' THEN substr(calling_number,1,3)
when calling_number like '23%' THEN substr(calling_number,1,3)
when calling_number like '35%' THEN substr(calling_number,1,3)
when calling_number like '1%' THEN substr(calling_number,1,1)
ELSE substr(calling_number,1,2) END cfrm,
called_number,
case
when called_number like '97%' THEN substr(called_number,1,3)
when called_number like '96%' THEN substr(called_number,1,3)
when called_number like '24%' THEN substr(called_number,1,3)
when called_number like '25%' THEN substr(called_number,1,3)
when called_number like '21%' THEN substr(called_number,1,3)
when called_number like '42%' THEN substr(called_number,1,3)
when called_number like '23%' THEN substr(called_number,1,3)
when called_number like '35%' THEN substr(called_number,1,3)
when called_number like '1%' THEN substr(called_number,1,1)
ELSE substr(called_number,1,2) END cto
from refined.fct_prepaid_usages
where record_type_value = 'Voice'
and (`date` >= '2022-02-20' and `date` <= '2022-02-26')) t – << SET PRERIOD HERE
where t.cfrm = '968'
and t.cfrm <> t.cto
group by t.cto
order by count(t.called_number) desc
limit 20