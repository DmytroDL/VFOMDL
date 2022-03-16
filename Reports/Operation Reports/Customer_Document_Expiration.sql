/*
 Goal of report
The system provides the API to get list of all Individuals with ID Documents that will expire soon or already expired.

Input
 Parameter, Format, Multiplicity,  Description
 Array of Individual ID, text, 0..1,  List of "Individual ID" attribute value in BSS of Individual of selected ID Document

Output
The system gets all ID Documents with ID Type other than Oman ID, Bahrain ID, Kuwait ID, Qatar ID, Saudi Arabia ID, United Arab Emirates ID and Expiration Date<current date+180 days

The system gets ID Documents with ID Type in (Oman ID, Bahrain ID, Kuwait ID, Qatar ID, Saudi Arabia ID, United Arab Emirates ID) and Expiration Date<current date+30 days
 */

select ind.individual_id, ind.primary_customer_ref, id.document_id, id.document_type_value, id.expiration_date
from refined.dim_individual ind
         left join refined.dim_id_document id
                   on id.individual_id = ind.individual_id