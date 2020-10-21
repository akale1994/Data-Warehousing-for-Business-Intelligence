---a
--Report 1
--Rank
--Top 10 suburbs with lowest rent per week for Apartment Property Type
--Version 1
SELECT * FROM(
SELECT A.suburb AS SUBURB, 
P.property_type AS "PROPERTY TYPE",
SUM(R.total_rental_fees) AS "RENTAL FEES",
DENSE_RANK() OVER(ORDER BY SUM(R.total_rental_fees)) AS "RANK BY RENT"
FROM rentfact_v1 R,
propertytypedim_v1 P,
addressdim_v1 A
WHERE R.property_type = P.property_type
AND R.address_id = A.address_id
AND R.property_type like '%Apartment%'
GROUP BY A.suburb,
P.property_type)
WHERE "RANK BY RENT" <= 10;

-- Version 2
SELECT * FROM(
SELECT A.suburb AS SUBURB, 
P.property_type AS "PROPERTY TYPE",
SUM(R.total_rental_fees) AS "RENTAL FEES",
DENSE_RANK() OVER(ORDER BY SUM(R.total_rental_fees)) AS "RANK BY RENT"
FROM rentfact_v2 R,
propertydim_v2 P,
addressdim_v2 A
WHERE R.property_id = P.property_id
AND R.address_id = A.address_id
AND P.property_type like '%Apartment%'
GROUP BY A.suburb,
P.property_type)
WHERE "RANK BY RENT" <= 10;

--Report 2
--Rank Percent
--Top 10% visits by property type and months for time period = 2020 
--Version 1
SELECT *
FROM (
SELECT
P.property_type AS "PROPERTY TYPE",
T.MONTH AS "TIME PERIOD",
SUM(V.total_number_of_visits) AS  "TOTAL VISITS", 
round(PERCENT_RANK() OVER(ORDER BY SUM(V.total_number_of_visits)), 5) AS "PERCENTAGE RANK"
FROM TimeDIM_V1 T,
visitfact_v1 V,
propertytypedim_v1 P
WHERE T.time_id = V.time_id
AND P.property_type = V.property_type
AND T.YEAR = 2020
GROUP BY T.MONTH,
P.property_type)
WHERE "PERCENTAGE RANK"  >= 0.9
ORDER BY "PERCENTAGE RANK"  DESC;

--Version 2
SELECT *
FROM (
SELECT
P.property_type AS "PROPERTY TYPE",
TO_CHAR(V.visit_date, 'MM') AS "TIME PERIOD",
SUM(V.total_number_of_visits) AS  "TOTAL VISITS", 
round(PERCENT_RANK() OVER(ORDER BY SUM(V.total_number_of_visits)), 5) AS "PERCENTAGE RANK"
FROM TimeDIM_V2 T,
visitfact_v2 V,
propertydim_v2 P
WHERE T.date_id = V.visit_date
AND P.property_id = V.property_id
AND TO_CHAR(V.visit_date, 'YYYY') = 2020
GROUP BY TO_CHAR(V.visit_date, 'MM'),
P.property_type)
WHERE "PERCENTAGE RANK"  >= 0.9
ORDER BY "PERCENTAGE RANK"  DESC;

--Report 3
--Show all
--Show avg sales by all states and years
--Version 1
SELECT A.state_code AS STATE,
T.year as "YEAR",
Round(SUM(S.total_sales)/SUM(S.total_number_of_sales)) AS "AVERAGE SALES"
FROM timedim_v1 T,
salefact_v1 S,
rentfact_v1 R,
addressdim_v1 A
WHERE S.address_id = A.address_id
AND t.time_id = s.time_id
GROUP BY A.state_code,
T.year
ORDER BY STATE;

--Version 2
SELECT A.state_code AS STATE,
to_char(S.sale_date, 'YYYY') AS "YEAR",
Round(SUM(S.total_sales)/SUM(S.total_number_of_sales)) AS "AVERAGE SALES"
FROM TimeDIM_V2 T,
salefact_v2 S,
addressdim_v2 A
WHERE S.address_id = A.address_id
AND t.date_id = s.sale_date
GROUP BY A.state_code,
to_char(S.sale_date, 'YYYY')
ORDER BY STATE;

