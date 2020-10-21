--b
--Report 4 
--What are the sub-total and total rental fees from
--each suburb, time period, and property type? (You must use the Cube and Partial Cube operator)
--Version 1
SELECT 
decode(GROUPING(A.suburb), 1, 'All Suburbs',
A.suburb) AS SUBURB,
decode(GROUPING(T.year), 1, 'All Years',
T.year) AS "YEARS",
decode(GROUPING(T.month), 1, 'All Months',
T.month) AS "MONTHS",
decode(GROUPING(P.property_type), 1, 'All Property Types',
P.property_type) AS "PROPERTY TYPE",
SUM(total_rental_fees) AS "RENTAL FEES"
FROM rentfact_v1 R,
timedim_v1 T,
propertytypedim_v1 P,
addressdim_v1 A
WHERE R.time_id = T.time_id
AND R.property_type = P.property_type
AND R.address_id = A.address_id
GROUP BY CUBE(A.suburb,T.year,T.Month,P.property_type)
ORDER BY A.suburb;
--Version 2

SELECT 
decode(GROUPING(A.suburb), 1, 'All Suburbs',
A.suburb) AS SUBURB,
decode(GROUPING(to_char(R.rent_start_date, 'YYYY')), 1, 'All Years',
to_char(R.rent_start_date, 'YYYY')) AS "YEARS",
decode(GROUPING(to_char(R.rent_start_date, 'MM')), 1, 'All Months',
to_char(R.rent_start_date, 'MM')) AS "MONTHS",
decode(GROUPING(P.property_type), 1, 'All Property Types',
P.property_type) AS "PROPERTY TYPE",
SUM(total_rental_fees) AS "RENTAL FEES"
FROM rentfact_v2 R,
TimeDIM_V2 T,
propertydim_v2 P,
addressdim_v2 A
WHERE R.rent_start_date = T.date_id
AND R.property_id = P.property_id
AND R.address_id = A.address_id
GROUP BY CUBE(A.suburb,
to_char(R.rent_start_date, 'YYYY'),
to_char(R.rent_start_date, 'MM'),
P.property_type)
ORDER BY A.suburb;

--Report 5
--Version 1
SELECT 
decode(GROUPING(A.suburb), 1, 'All Suburbs',
A.suburb) AS SUBURB,
decode(GROUPING(T.year), 1, 'All Years',
T.year) AS "YEARS",
decode(GROUPING(T.month), 1, 'All Months',
T.month) AS "MONTHS",
decode(GROUPING(P.property_type), 1, 'All Property Types',
P.property_type) AS "PROPERTY TYPE",
SUM(R.total_rental_fees) AS "RENTAL FEES"
FROM rentfact_v1 R,
timedim_v1 T,
propertytypedim_v1 P,
addressdim_v1 A
WHERE R.time_id = T.time_id
AND R.property_type = P.property_type
AND R.address_id = A.address_id
GROUP BY A.suburb, CUBE(T.year,T.Month,P.property_type)
ORDER BY A.suburb;

--Version 2

SELECT 
decode(GROUPING(A.suburb), 1, 'All Suburbs',
A.suburb) AS SUBURB,
decode(GROUPING(to_char(R.rent_start_date, 'YYYY')), 1, 'All Years',
to_char(R.rent_start_date, 'YYYY')) AS "YEARS",
decode(GROUPING(to_char(R.rent_start_date, 'MM')), 1, 'All Months',
to_char(R.rent_start_date, 'MM')) AS "MONTHS",
decode(GROUPING(P.property_type), 1, 'All Property Types',
P.property_type) AS "PROPERTY TYPE",
SUM(R.total_rental_fees) AS "RENTAL FEES"
FROM rentfact_v2 R,
TimeDIM_V2 T,
propertydim_v2 P,
addressdim_v2 A
WHERE R.rent_start_date = T.date_id
AND R.property_id = P.property_id
AND R.address_id = A.address_id
GROUP BY A.suburb, CUBE(to_char(R.rent_start_date, 'YYYY'),
to_char(R.rent_start_date, 'MM'),P.property_type)
ORDER BY A.suburb;

--Report 6
--Total Revenue and sub totals of all Agentoffices from all Suburbs and all Genders
--Version 1
SELECT 
decode(GROUPING(o.office_name), 1, 'All Offices',
o.office_name) AS "OFFICE NAME",
decode(GROUPING(A.suburb), 1, 'All Suburbs',
A.suburb) AS "SUBURB",
decode(GROUPING(G.gender), 1, 'All Genders',
G.gender) AS "GENDER",
SUM(R.total_revenue) AS "TOTAL REVENUE"
FROM revenuefact_v1 R,
officedim_v1 o,
genderdim_v1 G,
addressdim_v1 A,
agentdim_v1 AT,
propertydim_v1 P,
agentofficebridge_v1 ao
WHERE AT.agent_id = ao.agent_id
AND ao.office_id = o.office_id
AND R.agent_id = AT.agent_id
AND R.property_id = P.property_id
AND P.address_id = A.address_id
GROUP BY ROLLUP(o.office_name, A.suburb, G.gender)
ORDER BY o.office_name;

--Version 2

SELECT 
decode(GROUPING(o.office_name), 1, 'All Offices',
o.office_name) AS "OFFICE NAME",
decode(GROUPING(A.suburb), 1, 'All Suburbs',
A.suburb) AS "SUBURB",
decode(GROUPING(G.gender), 1, 'All Genders',
G.gender) AS "GENDER",
SUM(R.total_revenue) AS "TOTAL REVENUE"
FROM revenuefact_v2 R,
officedim_v2 o,
genderdim_v2 G,
addressdim_v2 A,
agentdim_v2 AT,
propertydim_v2 P,
agentofficebridge_v2 ao
WHERE AT.agent_id = ao.agent_id
AND ao.office_id = o.office_id
AND R.agent_id = AT.agent_id
AND R.property_id = P.property_id
AND P.address_id = A.address_id
GROUP BY ROLLUP(o.office_name, A.suburb, G.gender)
ORDER BY o.office_name;

--Report 7
--Total Properties and subtotals from all states and all Property Types by time period.
--Version 1
SELECT
decode(GROUPING(A.State_code), 1, 'All States',
A.State_code) AS STATE,
decode(GROUPING(P.property_type), 1, 'All Property Types',
p.property_type) AS "PROPERTY TYPE",
decode(GROUPING(T.year), 1, 'All Years',
T.year) AS "YEARS",
decode(GROUPING(T.month), 1, 'All Months',
T.month) AS "MONTHS",
SUM(PF.total_number_of_properties) AS "TOTAL PROPERTIES"
FROM TimeDIM_V1 T,
PropertyFACT_V1 PF,
PropertyTypeDIM_V1 P,
AddressDIM_V1 A
WHERE PF.time_id = T.time_id
AND A.address_id= PF.address_id
AND p.property_type = pf.property_type
GROUP BY A.State_code, ROLLUP(P.property_type,T.year,T.month)
ORDER BY A.State_code;

--Version 2

SELECT
decode(GROUPING(A.State_code), 1, 'All States',
A.State_code) AS STATE,
decode(GROUPING(P.property_type), 1, 'All Property Types',
p.property_type) AS "PROPERTY TYPE",
decode(GROUPING(to_char(PF.property_date_added, 'YYYY')), 1, 'All Years',
to_char(PF.property_date_added, 'YYYY')) AS "YEARS",
decode(GROUPING(to_char(PF.property_date_added, 'MM')), 1, 'All Months',
to_char(PF.property_date_added, 'MM')) AS "MONTHS",
SUM(PF.total_number_of_properties) AS "TOTAL PROPERTIES"
FROM TimeDIM_V2 T,
PropertyFACT_V2 PF,
PropertyDIM_V2 P,
AddressDIM_V2 A
WHERE PF.property_date_added = T.date_id
AND A.address_id= PF.address_id
AND p.property_id = pf.property_id
GROUP BY A.State_code, ROLLUP(P.property_type,
to_char(PF.property_date_added, 'YYYY'),
to_char(PF.property_date_added, 'MM'))
ORDER BY A.State_code;
