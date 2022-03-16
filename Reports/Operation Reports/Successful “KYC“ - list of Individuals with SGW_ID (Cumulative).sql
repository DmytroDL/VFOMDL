/*
 Request
NCAA-753: Report request - Successful “KYC“ - list of Individuals with SGW_ID (Cumulative)DONE

To provide the report with all Individuals with SGW IDs (Cumulative);- Success “KYC“ - list of Individuals with SGW_ID

sgw_id

CA_object_id
 */

select i.security_id as security_id, c.object_id as CA_object_id
from interim.r_cim_individual i
         join interim.r_cim_cust_account c on (i.object_id=c.primary_individual)
where security_id is not null;