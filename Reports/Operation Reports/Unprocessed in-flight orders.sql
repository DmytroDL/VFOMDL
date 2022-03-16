select object_id, name, revision, sales_order_status from interim.r_oe_sales_ord
where revision!=1 and sales_order_status not in ('6#5B8630$Processed', '6#CFCFCF$Superseded')