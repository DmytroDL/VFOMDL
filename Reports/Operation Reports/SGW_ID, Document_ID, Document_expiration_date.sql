/*
 Request
SGW_id

Document_type

Document_id

Document expiration date
 */
select ind.sgw_id, id.document_type_value, id.document_number, id.expiration_date
from refined.dim_id_document id
         left join refined.dim_individual ind
                   on (id.individual_id=ind.individual_id);