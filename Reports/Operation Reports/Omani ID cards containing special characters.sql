/*
 Request
NCAA-757: Report request - Omani ID cards containing special charactersDONE

The report requires to query all orders having Omani ID containing

any characters not a number

lenght <= 9 (totalDigits{9})
 */

select doc.id_number as Id_Number,
       ca.name as Customer_Name,
       ca.object_id as BSS_Customer_Id,
       so.name as Sales_Order_Name,
       SUBSTR(so.sales_order_status, 10) as Sales_Order_Status
from  interim.r_cim_individual ind
          join interim.r_cim_id_document doc on doc.parent_id = ind.object_id
          join interim.r_cim_cust_account ca on ca.primary_individual = ind.object_id
          join interim.r_oe_sales_ord so on so.customer_account = ca.object_id
where (trim(REGEXP_EXTRACT(doc.id_number, '[^0-9]', 0)) != '' or length(doc.id_number) >9)
  and doc.id_type = '9157890424113881460'
