------VERSION 1------

--Create Dimensions
--Create SeasonDIM_V1
DROP TABLE SeasonDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE SeasonDIM_V1
(season_id      NUMBER(1),
 season         VARCHAR2(10),
 description    VARCHAR2(20)
);

--Insert Values into SeasonDIM_V1
INSERT INTO SeasonDIM_V1 VALUES (1, 'Summer', 'DEC-FEB');
INSERT INTO SeasonDIM_V1 VALUES (2, 'Autumn', 'MAR-MAY');
INSERT INTO SeasonDIM_V1 VALUES (3, 'Winter', 'JUN-AUG');
INSERT INTO SeasonDIM_V1 VALUES (4, 'Spring', 'SEP-NOV');

--Create PropertyDIM2_V1
DROP TABLE PropertyDIM2_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyDIM2_V1 AS
SELECT
    P.property_id,
    1.0 / COUNT(PA.advert_id) AS weight_factor,
    LISTAGG(PA.advert_id, '_') WITHIN GROUP (ORDER BY PA.advert_id) AS advertisement_group_list
FROM
    property P,
    property_advert PA
WHERE P.property_id = PA.property_id
GROUP BY P.property_id;

--Create PropertyAdvertisementBRIDGE_V1
DROP TABLE PropertyAdvertisementBRIDGE_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyAdvertisementBRIDGE_V1 AS
SELECT
    property_id,
    advert_id,
    cost
FROM property_advert;

--Create AdvertisementDIM_V1
DROP TABLE AdvertisementDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE AdvertisementDIM_V1 AS
SELECT *
FROM advertisement;

--Create PropertyScaleDIM_V1
DROP TABLE PropertyScaleDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyScaleDIM_V1
(property_scale_id      NUMBER(1),
 property_scale         VARCHAR2(15),
 description            VARCHAR2(20)
);

--Insert Values into PropertyScaleDIM_V1
INSERT INTO PropertyScaleDIM_V1 VALUES (1, 'Extra Small', '<= 1 bedroom');
INSERT INTO PropertyScaleDIM_V1 VALUES (2, 'Small', '2-3 bedrooms');
INSERT INTO PropertyScaleDIM_V1 VALUES (3, 'Medium', '4-6 bedrooms');
INSERT INTO PropertyScaleDIM_V1 VALUES (4, 'Large', '7-10 bedrooms');
INSERT INTO PropertyScaleDIM_V1 VALUES (5, 'Extra Large', '> 10 bedrooms');

--Create PropertyTypeDIM_V1
DROP TABLE PropertyTypeDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyTypeDIM_V1 AS
SELECT DISTINCT property_type
FROM property;

--Create PropertyFeatureCategoryDIM_V1
DROP TABLE PropertyFeatureCategoryDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyFeatureCategoryDIM_V1
(feature_category_id    NUMBER(1),
 feature_category       VARCHAR2(15),
 description            VARCHAR2(20)
);

--Insert Values into PropertyFeatureCategoryDIM_V1
INSERT INTO PropertyFeatureCategoryDIM_V1 VALUES (1, 'Very basic', '< 10 features');
INSERT INTO PropertyFeatureCategoryDIM_V1 VALUES (2, 'Standard', '10-20 features');
INSERT INTO PropertyFeatureCategoryDIM_V1 VALUES (3, 'Luxurious', '> 20 features');

--Create RentalPeriodDIM_V1
DROP TABLE RentalPeriodDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE RentalPeriodDIM_V1
(rental_period_id       NUMBER(1),
 rental_period          VARCHAR2(15),
 description            VARCHAR2(20)
);

--Insert Values into RentalPeriodDIM_V1
INSERT INTO RentalPeriodDIM_V1 VALUES (1, 'Short', '< 6 months');
INSERT INTO RentalPeriodDIM_V1 VALUES (2, 'Medium', '6-12 months');
INSERT INTO RentalPeriodDIM_V1 VALUES (3, 'Long', '> 12 months');

--Create TempTimeDIM1_V1
DROP TABLE TempTimeDIM1_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempTimeDIM1_V1 AS
SELECT DISTINCT
    TO_CHAR(property_date_added, 'DAY') AS day,
    TO_CHAR(property_date_added, 'MM') AS month,
    TO_CHAR(property_date_added, 'YYYY') AS year, 
    TO_CHAR(property_date_added, 'YYYYMMDAY') AS time_id
FROM property;

--Create TempTimeDIM2_V1
DROP TABLE TempTimeDIM2_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempTimeDIM2_V1 AS
SELECT DISTINCT
    TO_CHAR(visit_date, 'DAY') AS day,
    TO_CHAR(visit_date, 'MM') AS month,
    TO_CHAR(visit_date, 'YYYY') AS year, 
    TO_CHAR(visit_date, 'YYYYMMDAY') AS time_id
FROM visit;

--Create TempTimeDIM3_V1
DROP TABLE TempTimeDIM3_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempTimeDIM3_V1 AS
SELECT DISTINCT
    TO_CHAR(sale_date, 'DAY') AS day,
    TO_CHAR(sale_date, 'MM') AS month,
    TO_CHAR(sale_date, 'YYYY') AS year, 
    TO_CHAR(sale_date, 'YYYYMMDAY') AS time_id
FROM sale;

--Create TempTimeDIM4_V1
DROP TABLE TempTimeDIM4_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempTimeDIM4_V1 AS
SELECT DISTINCT
    TO_CHAR(rent_start_date, 'DAY') AS day,
    TO_CHAR(rent_start_date, 'MM') AS month,
    TO_CHAR(rent_start_date, 'YYYY') AS year, 
    TO_CHAR(rent_start_date, 'YYYYMMDAY') AS time_id
FROM rent;

--Create TimeDIM_V1
DROP TABLE TimeDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TimeDIM_V1 AS
SELECT * FROM TempTimeDIM1_V1
UNION
SELECT * FROM TempTimeDIM2_V1
UNION
SELECT * FROM TempTimeDIM3_V1
UNION
SELECT * FROM TempTimeDIM4_V1;

--Create PropertyDIM_V1
DROP TABLE PropertyDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyDIM_V1 AS
SELECT
    P.property_id,
    P.address_id,
    (CASE WHEN COUNT(PF.feature_code) > 0 THEN (1.0 / COUNT(PF.feature_code)) ELSE 0 END) AS weight_factor,
    LISTAGG(PF.feature_code, '_') WITHIN GROUP (ORDER BY PF.feature_code) AS feature_group_list
FROM
    property P,
    property_feature PF
WHERE P.property_id = PF.property_id (+)
GROUP BY
    P.property_id,
    P.address_id;

--Create PropertyFeatureBRIDGE_V1
DROP TABLE PropertyFeatureBRIDGE_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyFeatureBRIDGE_V1 AS
SELECT *
FROM property_feature;

--Create PropertyFeatureDIM_V1
DROP TABLE PropertyFeatureDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyFeatureDIM_V1 AS
SELECT *
FROM feature;

--Create SaleDIM_V1
DROP TABLE SaleDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE SaleDIM_V1 AS
SELECT
    property_id,
    agent_person_id AS agent_id,
    client_person_id AS client_id,
    sale_id
FROM sale;

--Create SaleHistoryDIM_V1
DROP TABLE SaleHistoryDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE SaleHistoryDIM_V1 AS
SELECT
    sale_id,
    sale_date,
    price
FROM sale;

--Create RentDIM_V1
DROP TABLE RentDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE RentDIM_V1 AS
SELECT
    property_id,
    agent_person_id AS agent_id,
    client_person_id AS client_id,
    rent_id
FROM rent;

--Create RentHistoryDIM_V1
DROP TABLE RentHistoryDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE RentHistoryDIM_V1 AS
SELECT
    rent_id,
    rent_start_date,
    rent_end_date,
    price
FROM rent;

--Create OfficeSizeDIM_V1
DROP TABLE OfficeSizeDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE OfficeSizeDIM_V1
(office_size_id     NUMBER(2),
 office_size_type   VARCHAR2(10),
 description        VARCHAR2(30));

--Insert Values into AgentOfficeSizeDIM_V1
INSERT INTO OfficeSizeDIM_V1 VALUES(1, 'Small', '< 4 employees');
INSERT INTO OfficeSizeDIM_V1 VALUES(2, 'Medium', '4-12 employees');
INSERT INTO OfficeSizeDIM_V1 VALUES(3, 'Big', '> 12 employees');

--Create GenderDIM_V1
DROP TABLE GenderDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE GenderDIM_V1 AS
SELECT DISTINCT gender
FROM person;

--Create AgentSalaryDIM_V1
DROP TABLE AgentSalaryDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE AgentSalaryDIM_V1 AS
SELECT DISTINCT salary
FROM agent;

--Create TempOfficeDIM_V1
DROP TABLE TempOfficeDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempOfficeDIM_V1 AS
SELECT
    O.office_id,
    O.office_name,
    COUNT(A.person_id) AS agent_count
FROM
    office O,
    agent_office A
WHERE O.office_id = A.office_id
GROUP BY
    O.office_id,
    O.office_name;
    
-- Alter TempOfficeDIM_V1
ALTER TABLE TempOfficeDIM_V1 ADD
(office_size_id   NUMBER(1));

-- Update TempOfficeDIM_V1
UPDATE TempOfficeDIM_V1
SET office_size_id = 1
WHERE agent_count < 4;

UPDATE TempOfficeDIM_V1
SET office_size_id = 2
WHERE agent_count >= 4
AND agent_count <= 12;

UPDATE TempOfficeDIM_V1
SET office_size_id = 3
WHERE agent_count > 12;

--Create OfficeDIM_V1
DROP TABLE OfficeDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE OfficeDIM_V1 AS
SELECT
    office_id,
    office_name,
    office_size_id
FROM TempOfficeDIM_V1;
    
--Create AgentOfficeBRIDGE_V1
DROP TABLE AgentOfficeBRIDGE_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE AgentOfficeBRIDGE_V1 AS
SELECT
    person_id AS agent_id,
    office_id
FROM agent_office;

--Create AgentDIM_V1
DROP TABLE AgentDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE AgentDIM_V1 AS
SELECT
    A.person_id AS agent_id,
    1.0 / COUNT(AO.office_id) AS weight_factor,
    LISTAGG(AO.office_id, '_') WITHIN GROUP (ORDER BY AO.office_id) AS office_group_list
FROM
    agent A,
    agent_office AO
WHERE A.person_id = AO.person_id (+)
GROUP BY A.person_id;

--Create AddressDIM_V1
DROP TABLE AddressDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE AddressDIM_V1 AS
SELECT DISTINCT
    P.address_id,
    A.suburb,
    PC.postcode,
    PC.state_code
FROM
    property P,
    address A,
    postcode PC
WHERE P.address_id = A.address_id
AND A.postcode = PC.postcode;

--Create ClientBudgetDIM_V1
DROP TABLE ClientBudgetDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE ClientBudgetDIM_V1
(client_budget_id   NUMBER(3),
 client_budget      VARCHAR2(20),
 description        VARCHAR2(30));

--Insert Values into ClientBudgetDIM_V1
INSERT INTO ClientBudgetDIM_V1 VALUES(1, 'Low', '0 to 1000');
INSERT INTO ClientBudgetDIM_V1 VALUES(2, 'Medium', '1001 to 100000');
INSERT INTO ClientBudgetDIM_V1 VALUES(3, 'High', '100001 to 10000000');

--Create ClientDIM_V1
DROP TABLE ClientDIM_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE ClientDIM_V1 AS
SELECT
    C.person_id AS client_id,
    (CASE WHEN COUNT(W.feature_code) > 0 THEN (1.0 / COUNT(W.feature_code)) ELSE 0 END) AS weight_factor,
    LISTAGG(W.feature_code, '_') WITHIN GROUP (ORDER BY W.feature_code) AS wishlist_group_list
FROM
    client C,
    client_wish W
WHERE C.person_id = W.person_id (+)
GROUP BY C.person_id;

--Create ClientWishBRIDGE_V1
DROP TABLE ClientWishBRIDGE_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE ClientWishBRIDGE_V1 AS
SELECT
    person_id AS client_id,
    feature_code
FROM client_wish;

--Create Facts
--Create TempPropertyFACT_V1
DROP TABLE TempPropertyFACT_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempPropertyFACT_V1 AS
SELECT
    P.property_id,
    to_char(P.property_date_added, 'YYYYMMDAY') AS time_id,
    P.property_type,
    P.address_id,
    P.property_no_of_bedrooms,
    COUNT(PF.feature_code) AS feature_count
FROM
    property P,
    property_feature PF
WHERE P.property_id = PF.property_id (+)
GROUP BY
    P.property_id,
    to_char(P.property_date_added, 'YYYYMMDAY'),
    P.property_type,
    P.address_id,
    P.property_no_of_bedrooms;

--Alter TempPropertyFACT_V1
ALTER TABLE TempPropertyFACT_V1 ADD (
property_scale_id NUMBER(1),
feature_category_id NUMBER(1));

--Update TempPropertyFACT_V1
UPDATE TempPropertyFACT_V1 SET property_scale_id = 1 
WHERE property_no_of_bedrooms <= 1;

UPDATE TempPropertyFACT_V1 SET property_scale_id = 2 
WHERE property_no_of_bedrooms >=2
AND property_no_of_bedrooms <= 3;

UPDATE TempPropertyFACT_V1 SET property_scale_id = 3
WHERE property_no_of_bedrooms >=4
AND property_no_of_bedrooms <= 6;

UPDATE TempPropertyFACT_V1 SET property_scale_id = 4
WHERE property_no_of_bedrooms >=7
AND property_no_of_bedrooms <= 10;

UPDATE TempPropertyFACT_V1 SET property_scale_id = 5 
WHERE property_no_of_bedrooms > 10;

UPDATE TempPropertyFACT_V1 SET feature_count = 0
WHERE feature_count IS NULL;

UPDATE TempPropertyFACT_V1 SET feature_category_id = 1
WHERE feature_count < 10;

UPDATE TempPropertyFACT_V1 SET feature_category_id = 2
WHERE feature_count >= 10
AND feature_count <= 20;

UPDATE TempPropertyFACT_V1 SET feature_category_id = 3
WHERE feature_count > 20;

--Create PropertyFACT_V1
DROP TABLE PropertyFACT_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyFACT_V1 AS 
SELECT
    property_id,
    property_scale_id,
    time_id,
    property_type,
    feature_category_id,
    address_id,
    COUNT(*) AS total_number_of_properties
FROM TempPropertyFACT_V1
GROUP BY
    property_id,
    property_scale_id,
    time_id,
    property_type,
    feature_category_id,
    address_id;

--Create TempVisitFACT_V1
DROP TABLE TempVisitFACT_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempVisitFACT_V1 AS
SELECT
    P.property_id,
    to_char(V.visit_date, 'YYYYMMDAY') AS time_id,
    to_char(V.visit_date) AS visit_date,
    P.property_type,
    P.address_id,
    P.property_no_of_bedrooms,
    V.client_person_id AS client_id,
    (CASE WHEN PD.weight_factor > 0 THEN ROUND(1 / PD.weight_factor) ELSE 0 END) AS feature_count
FROM
    property P,
    PropertyDIM_V1 PD,
    Visit V
WHERE V.property_id = PD.property_id (+)
AND V.property_id = P.property_id;

--Alter TempVisitFACT_V1
ALTER TABLE TempVisitFACT_V1 ADD (
season_id NUMBER(1),
property_scale_id NUMBER(1),
feature_category_id NUMBER(1));

--UPDATE TempVisitFACT_V1
UPDATE TempVisitFACT_V1 SET season_id = 1
WHERE EXTRACT( MONTH FROM TO_DATE( visit_date ) ) >= 01
AND EXTRACT( MONTH FROM TO_DATE( visit_date ) ) <= 02;

UPDATE TempVisitFACT_V1 SET season_id = 1 
WHERE EXTRACT( MONTH FROM TO_DATE( visit_date ) ) = 12;

UPDATE TempVisitFACT_V1 SET season_id = 3 
WHERE EXTRACT( MONTH FROM TO_DATE( visit_date ) ) >= 06
AND EXTRACT( MONTH FROM TO_DATE( visit_date ) ) <= 08;

UPDATE TempVisitFACT_V1 SET season_id = 2
WHERE EXTRACT( MONTH FROM TO_DATE( visit_date ) ) >= 03
AND EXTRACT( MONTH FROM TO_DATE( visit_date ) ) <= 05;

UPDATE TempVisitFACT_V1 SET season_id = 4 
WHERE EXTRACT(MONTH FROM TO_DATE( visit_date ) ) >= 09
AND EXTRACT( MONTH FROM TO_DATE( visit_date ) ) <= 11;

UPDATE TempVisitFACT_V1 SET property_scale_id = 1 
WHERE property_no_of_bedrooms <= 1;

UPDATE TempVisitFACT_V1 SET property_scale_id = 2 
WHERE property_no_of_bedrooms >=2
AND property_no_of_bedrooms <= 3;

UPDATE TempVisitFACT_V1 SET property_scale_id = 3
WHERE property_no_of_bedrooms >=4
AND property_no_of_bedrooms <= 6;

UPDATE TempVisitFACT_V1 SET property_scale_id = 4
WHERE property_no_of_bedrooms >=7
AND property_no_of_bedrooms <= 10;

UPDATE TempVisitFACT_V1 SET property_scale_id = 5 
WHERE property_no_of_bedrooms > 10;

UPDATE TempVisitFACT_V1 SET feature_count = 0
WHERE feature_count IS NULL;

UPDATE TempVisitFACT_V1 SET feature_category_id = 1
WHERE feature_count < 10;

UPDATE TempVisitFACT_V1 SET feature_category_id = 2
WHERE feature_count >= 10
AND feature_count <= 20;

UPDATE TempVisitFACT_V1 SET feature_category_id = 3
WHERE feature_count > 20;

--Create VisitFACT_V1
DROP TABLE VisitFACT_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE VisitFACT_V1 AS 
SELECT
    property_id,
    season_id, 
    time_id,
    property_type, 
    address_id,
    property_scale_id,
    feature_category_id,
    client_id,
    COUNT(*) AS total_number_of_visits
FROM TempVisitFACT_V1
GROUP BY 
    property_id,
    season_id , 
    time_id,
    property_type, 
    address_id,
    property_scale_id,
    feature_category_id,
    client_id;

--Create TempRentFACT_V1
DROP TABLE TempRentFACT_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempRentFACT_V1 AS
SELECT
    P.address_id,
    (CASE WHEN PD.weight_factor > 0 THEN ROUND(1 / PD.weight_factor) ELSE 0 END) AS feature_count,
    to_char(R.rent_start_date, 'YYYYMMDAY') AS time_id,
    R.price,
    P.property_id,
    R.rent_start_date,
    R.rent_end_date,
    P.property_type,
    P.property_no_of_bedrooms,
    R.client_person_id AS client_id
FROM
    rent R,
    property P,
    propertyDIM_V1 PD
WHERE R.property_id = P.property_id
AND R.property_id = PD.property_id (+)
AND R.client_person_id IS NOT NULL;

--Alter TempRentFACT_V1
ALTER TABLE TempRentFACT_V1 ADD
(season_id              NUMBER(1),
 rental_period_id       NUMBER(1),
 property_scale_id      NUMBER(1),
 feature_category_id    NUMBER(1)
);

--Update TempRentFACT_V1
UPDATE TempRentFACT_V1
SET season_id = 2
WHERE TO_CHAR(rent_start_date, 'MM') >= 3
AND TO_CHAR(rent_start_date, 'MM') <= 5;

UPDATE TempRentFACT_V1
SET season_id = 3
WHERE TO_CHAR(rent_start_date, 'MM') >= 6
AND TO_CHAR(rent_start_date, 'MM') <= 8;

UPDATE TempRentFACT_V1
SET season_id = 4
WHERE TO_CHAR(rent_start_date, 'MM') >= 9
AND TO_CHAR(rent_start_date, 'MM') <= 11;

UPDATE TempRentFACT_V1
SET season_id = 1
WHERE season_id IS NULL;

UPDATE TempRentFACT_V1
SET rental_period_id = 1
WHERE (ROUND(MONTHS_BETWEEN(rent_end_date, rent_start_date))) < 06;

UPDATE TempRentFACT_V1
SET rental_period_id = 2
WHERE (ROUND(MONTHS_BETWEEN(rent_end_date, rent_start_date))) >= 06
AND (ROUND(MONTHS_BETWEEN(rent_end_date, rent_start_date))) <= 12;

UPDATE TempRentFACT_V1
SET rental_period_id = 3
WHERE (ROUND(MONTHS_BETWEEN(rent_end_date, rent_start_date))) > 12;

UPDATE TempRentFACT_V1
SET property_scale_id = 1
WHERE property_no_of_bedrooms <= 1;

UPDATE TempRentFACT_V1
SET property_scale_id = 2
WHERE property_no_of_bedrooms >= 2
AND property_no_of_bedrooms <= 3;

UPDATE TempRentFACT_V1
SET property_scale_id = 3
WHERE property_no_of_bedrooms >= 4
AND property_no_of_bedrooms <= 6;

UPDATE TempRentFACT_V1
SET property_scale_id = 4
WHERE property_no_of_bedrooms >= 7
AND property_no_of_bedrooms <= 10;

UPDATE TempRentFACT_V1
SET property_scale_id = 5
WHERE property_no_of_bedrooms > 10;

UPDATE TempRentFACT_V1
SET feature_count = 0
WHERE feature_count IS NULL;

UPDATE TempRentFACT_V1
SET feature_category_id = 1
WHERE feature_count < 10;

UPDATE TempRentFACT_V1
SET feature_category_id = 2
WHERE feature_count >= 10
AND feature_count <= 20;

UPDATE TempRentFACT_V1
SET feature_category_id = 3
WHERE feature_count > 20;

--Create RentFACT_V1
DROP TABLE RentFACT_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE RentFACT_V1 AS
SELECT
    property_id,
    time_id,
    season_id,
    address_id,
    feature_category_id,
    rental_period_id,
    property_type,
    property_scale_id,
    client_id,
    COUNT(*) AS total_number_of_rents,
    SUM(price) AS total_rental_fees
FROM TempRentFACT_V1
GROUP BY
    address_id,
    time_id,
    season_id,
    feature_category_id,
    property_id,
    rental_period_id,
    property_type,
    price,
    property_scale_id,
    client_id;

--Create TempSaleFACT_V1
DROP TABLE TempSaleFACT_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempSaleFACT_V1 AS
SELECT
    P.address_id,
    (CASE WHEN PD.weight_factor > 0 THEN ROUND(1 / PD.weight_factor) ELSE 0 END) AS feature_count,
    to_char(S.sale_date, 'YYYYMMDAY') AS time_id,
    S.price,
    S.sale_date,
    P.property_id,
    P.property_type,
    P.property_no_of_bedrooms,
    S.client_person_id AS client_id
FROM
    sale S,
    property P,
    propertyDIM_V1 PD
WHERE S.property_id = P.property_id
AND S.property_id = PD.property_id (+)
AND S.client_person_id IS NOT NULL;

--Alter TempSaleFACT_V1
ALTER TABLE TempSaleFACT_V1 ADD
(season_id              NUMBER(1),
 property_scale_id      NUMBER(1),
 feature_category_id    NUMBER(1)
);

--Update TempSaleFACT_V1
UPDATE TempSaleFACT_V1
SET season_id = 2
WHERE TO_CHAR(sale_date, 'MM') >= 3
AND TO_CHAR(sale_date, 'MM') <= 5;

UPDATE TempSaleFACT_V1
SET season_id = 3
WHERE TO_CHAR(sale_date, 'MM') >= 6
AND TO_CHAR(sale_date, 'MM') <= 8;

UPDATE TempSaleFACT_V1
SET season_id = 4
WHERE TO_CHAR(sale_date, 'MM') >= 9
AND TO_CHAR(sale_date, 'MM') <= 11;

UPDATE TempSaleFACT_V1
SET season_id = 1
WHERE season_id IS NULL;

UPDATE TempSaleFACT_V1
SET property_scale_id = 1
WHERE property_no_of_bedrooms <= 1;

UPDATE TempSaleFACT_V1
SET property_scale_id = 2
WHERE property_no_of_bedrooms >= 2
AND property_no_of_bedrooms <= 3;

UPDATE TempSaleFACT_V1
SET property_scale_id = 3
WHERE property_no_of_bedrooms >= 4
AND property_no_of_bedrooms <= 6;

UPDATE TempSaleFACT_V1
SET property_scale_id = 4
WHERE property_no_of_bedrooms >= 7
AND property_no_of_bedrooms <= 10;

UPDATE TempSaleFACT_V1
SET property_scale_id = 5
WHERE property_no_of_bedrooms > 10;

UPDATE TempSaleFACT_V1
SET feature_count = 0
WHERE feature_count IS NULL;

UPDATE TempSaleFACT_V1
SET feature_category_id = 1
WHERE feature_count < 10;

UPDATE TempSaleFACT_V1
SET feature_category_id = 2
WHERE feature_count >= 10
AND feature_count <= 20;

UPDATE TempSaleFACT_V1
SET feature_category_id = 3
WHERE feature_count > 20;

--Create SaleFACT_V1
DROP TABLE SaleFACT_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE SaleFACT_V1 AS
SELECT
    property_id,
    time_id,
    season_id,
    address_id,
    feature_category_id,
    property_type,
    property_scale_id,
    client_id,
    COUNT(*) AS total_number_of_sales,
    SUM(price) AS total_sales
FROM TempSaleFACT_V1
GROUP BY
    address_id,
    time_id,
    season_id,
    feature_category_id,
    property_id,
    property_type,
    price,
    property_scale_id,
    client_id;
    
--Create TempClientFACT_V1
DROP TABLE TempClientFACT_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempClientFACT_V1 AS
SELECT
    C.person_id AS client_id,
    C.max_budget AS client_budget,
    P.gender
FROM client C,
    person P,
    client_wish CW
WHERE C.person_id = P.person_id
AND C.person_id = CW.person_id (+);
    
-- Alter TempClientFACT_V1
ALTER TABLE TempClientFACT_V1 ADD
(client_budget_id   NUMBER(1));

-- Update TempClientFACT_V1
UPDATE TempClientFACT_V1
SET client_budget_id = 1
WHERE client_budget BETWEEN 0 AND 1000;

UPDATE TempClientFACT_V1
SET client_budget_id = 2
WHERE client_budget BETWEEN 1001 AND 100000;

UPDATE TempClientFACT_V1
SET client_budget_id = 3
WHERE client_budget BETWEEN 100001 AND 10000000;

--Create ClientFACT_V1
DROP TABLE ClientFACT_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE ClientFACT_V1 AS
SELECT
    client_id,
    client_budget_id,
    gender,
    COUNT(DISTINCT client_id) AS total_number_of_clients
FROM TempClientFACT_V1
GROUP BY
    client_id,
    client_budget_id,
    gender;

--Create TempAgentFACT_V1
DROP TABLE TempAgentFACT_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempAgentFACT_V1 AS
SELECT
    A.person_id as agent_id,
    A.salary,
    P.gender
FROM
    agent A,
    person P
WHERE A.person_id = P.person_id;

--Create AgentFACT_V1
DROP TABLE AgentFACT_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE AgentFACT_V1 AS
SELECT
    agent_id,
    salary,
    gender,
    COUNT(agent_id) AS total_number_of_agents,
    SUM(salary) AS total_salary
FROM
    TempAgentFACT_V1
GROUP BY
    agent_id,
    salary,
    gender;

--Create TempRevenueFACT1_V1
DROP TABLE TempRevenueFACT1_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempRevenueFACT1_V1 AS
SELECT
    agent_person_id AS agent_id,
    property_id,
    price AS total_revenue
FROM sale
WHERE client_person_id IS NOT NULL;

--Create TempRevenueFACT2_V1
DROP TABLE TempRevenueFACT2_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempRevenueFACT2_V1 AS
SELECT
    agent_person_id as agent_id,
    property_id,
    ROUND((price / 7) * (rent_end_date - rent_start_date), 2) AS total_revenue
FROM rent
WHERE client_person_id IS NOT NULL;

--Create RevenueFACT_V1
DROP TABLE RevenueFACT_V1 CASCADE CONSTRAINTS PURGE;
CREATE TABLE RevenueFACT_V1 AS
SELECT * FROM TempRevenueFACT1_V1
UNION
SELECT * FROM TempRevenueFACT2_V1;

-----------------------------------------------------------------------------------------------




------VERSION 2------

--Create Dimensions
--Create PropertyDIM2_V2
DROP TABLE PropertyDIM2_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyDIM2_V2 AS
SELECT
    P.property_id,
    1.0 / COUNT(PA.advert_id) AS weight_factor,
    LISTAGG(PA.advert_id, '_') WITHIN GROUP (ORDER BY PA.advert_id) AS advertisement_group_list
FROM
    property P,
    property_advert PA
WHERE P.property_id = PA.property_id
GROUP BY P.property_id;

--Create PropertyAdvertisementBRIDGE_V2
DROP TABLE PropertyAdvertisementBRIDGE_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyAdvertisementBRIDGE_V2 AS
SELECT
    property_id,
    advert_id,
    cost
FROM property_advert;

--Create AdvertisementDIM_V2
DROP TABLE AdvertisementDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE AdvertisementDIM_V2 AS
SELECT *
FROM advertisement;

--Create TempDateDIM_V2
DROP TABLE TempDateDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempDateDIM_V2 AS
SELECT DISTINCT
    property_date_added AS date_id
FROM property;

--Create TempVisitDateDIM_V2
DROP TABLE TempVisitDateDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempVisitDateDIM_V2 AS
SELECT DISTINCT visit_date AS date_id
FROM visit;

--Create TempSaleDateDIM_V2
DROP TABLE TempSaleDateDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempSaleDateDIM_V2 AS
SELECT DISTINCT sale_date AS date_id
FROM sale;

--Create TempRentStartDateDIM_V2
DROP TABLE TempRentStartDateDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempRentStartDateDIM_V2 AS
SELECT DISTINCT rent_start_date AS date_id
FROM rent;

--Create TimeDIM_V2
DROP TABLE TimeDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TimeDIM_V2 AS
SELECT * FROM TempDateDIM_V2
UNION
SELECT * FROM TempVisitDateDIM_V2
UNION
SELECT * FROM TempSaleDateDIM_V2
UNION
SELECT * FROM TempRentStartDateDIM_V2;

--Create PropertyDIM_V2
DROP TABLE PropertyDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyDIM_V2 AS
SELECT
    P.property_id,
    P.address_id,
    P.property_no_of_bedrooms,
    P.property_type,
    (CASE WHEN COUNT(PF.feature_code) > 0 THEN (1.0 / COUNT(PF.feature_code)) ELSE 0 END) AS weight_factor,
    LISTAGG(PF.feature_code, '_') WITHIN GROUP (ORDER BY PF.feature_code) AS feature_group_list
FROM
    property P,
    property_feature PF
WHERE P.property_id = PF.property_id (+)
GROUP BY
    P.property_id,
    P.address_id,
    P.property_no_of_bedrooms,
    P.property_type;

--Create PropertyFeatureBRIDGE_V2
DROP TABLE PropertyFeatureBRIDGE_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyFeatureBRIDGE_V2 AS
SELECT *
FROM property_feature;

--Create PropertyFeatureDIM_V2
DROP TABLE PropertyFeatureDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyFeatureDIM_V2 AS
SELECT *
FROM feature;

--Create SaleDIM_V2
DROP TABLE SaleDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE SaleDIM_V2 AS
SELECT
    property_id,
    agent_person_id AS agent_id,
    client_person_id AS client_id,
    sale_id
FROM sale;

--Create SaleHistoryDIM_V2
DROP TABLE SaleHistoryDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE SaleHistoryDIM_V2 AS
SELECT
    sale_id,
    sale_date,
    price
FROM sale;

--Create RentDIM_V2
DROP TABLE RentDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE RentDIM_V2 AS
SELECT
    property_id,
    agent_person_id AS agent_id,
    client_person_id AS client_id,
    rent_id
FROM rent;

--Create RentHistoryDIM_V2
DROP TABLE RentHistoryDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE RentHistoryDIM_V2 AS
SELECT
    rent_id,
    rent_start_date,
    rent_end_date,
    price
FROM rent;

--Create GenderDIM_V2
DROP TABLE GenderDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE GenderDIM_V2 AS
SELECT DISTINCT gender
FROM person;

--Create OfficeDIM_V2
DROP TABLE OfficeDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE OfficeDIM_V2 AS
SELECT
    O.office_id,
    O.office_name,
    COUNT(A.person_id) AS agent_count
FROM
    office O,
    agent_office A
WHERE O.office_id = A.office_id
GROUP BY
    O.office_id,
    O.office_name;
    
--Create AgentOfficeBRIDGE_V2
DROP TABLE AgentOfficeBRIDGE_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE AgentOfficeBRIDGE_V2 AS
SELECT
    person_id AS agent_id,
    office_id
FROM agent_office;

--Create AgentDIM_V2
DROP TABLE AgentDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE AgentDIM_V2 AS
SELECT
    A.person_id AS agent_id,
    A.salary,
    1.0 / COUNT(AO.office_id) AS weight_factor,
    LISTAGG(AO.office_id, '_') WITHIN GROUP (ORDER BY AO.office_id) AS office_group_list
FROM
    agent A,
    agent_office AO
WHERE A.person_id = AO.person_id (+)
GROUP BY
    A.person_id,
    A.salary;

--Create AddressDIM_V2
DROP TABLE AddressDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE AddressDIM_V2 AS
SELECT DISTINCT
    P.address_id,
    A.street,
    A.suburb,
    PC.postcode,
    PC.state_code
FROM
    property P,
    address A,
    postcode PC
WHERE P.address_id = A.address_id
AND A.postcode = PC.postcode;

--Create ClientDIM_V2
DROP TABLE ClientDIM_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE ClientDIM_V2 AS
SELECT
    C.person_id AS client_id,
    C.min_budget,
    C.max_budget,
    (CASE WHEN COUNT(W.feature_code) > 0 THEN (1.0 / COUNT(W.feature_code)) ELSE 0 END) AS weight_factor,
    LISTAGG(W.feature_code, '_') WITHIN GROUP (ORDER BY W.feature_code) AS wishlist_group_list
FROM
    client C,
    client_wish W
WHERE C.person_id = W.person_id (+)
GROUP BY
    C.person_id,
    C.min_budget,
    C.max_budget;

--Create ClientWishBRIDGE_V2
DROP TABLE ClientWishBRIDGE_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE ClientWishBRIDGE_V2 AS
SELECT
    person_id AS client_id,
    feature_code
FROM client_wish;

--Create Facts
--Create PropertyFACT_V2
DROP TABLE PropertyFACT_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE PropertyFACT_V2 AS
SELECT
    property_date_added,
    address_id,
    property_id,
    COUNT(*) AS total_number_of_properties
FROM property
GROUP BY
    property_date_added,
    address_id,
    property_id;

--Create VisitFACT_V2
DROP TABLE VisitFACT_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE VisitFACT_V2 AS
SELECT
    P.property_id,
    V.visit_date,
    P.address_id,
    V.client_person_id AS client_id,
    COUNT(*) AS total_number_of_visits
FROM
    property P,
    Visit V
WHERE V.property_id = P.property_id
GROUP BY
    P.property_id,
    V.visit_date,
    P.address_id,
    V.client_person_id;

--Create RentFACT_V2
DROP TABLE RentFACT_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE RentFACT_V2 AS
SELECT
    P.address_id,
    P.property_id,
    R.rent_start_date,
    R.client_person_id AS client_id,
    SUM(R.price) AS total_rental_fees,
    COUNT(*) AS total_number_of_rents
FROM
    rent R,
    property P
WHERE R.property_id = P.property_id
AND R.client_person_id IS NOT NULL
GROUP BY
    P.address_id,
    R.client_person_id,
    P.property_id,
    R.rent_start_date;

--Create SaleFACT_V2
DROP TABLE SaleFACT_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE SaleFACT_V2 AS
SELECT
    P.address_id,
    S.sale_date,
    P.property_id,
    S.client_person_id AS client_id,
    SUM(S.price) AS total_sales,
    COUNT(*) AS total_number_of_sales
FROM
    sale S,
    property P
WHERE S.property_id = P.property_id
AND S.client_person_id IS NOT NULL
GROUP BY
    P.address_id,
    S.sale_date,
    P.property_id,
    S.client_person_id;

--Create ClientFACT_V2
DROP TABLE ClientFACT_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE ClientFACT_V2 AS
SELECT
    C.person_id AS client_id,
    P.gender,
    COUNT(*) AS total_number_of_clients
FROM client C,
     person P
WHERE C.person_id = P.person_id
GROUP BY
    C.person_id,
    P.gender;
    
--Create AgentFACT_V2
DROP TABLE AgentFACT_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE AgentFACT_V2 AS
SELECT
    A.person_id AS agent_id,
    P.gender,
    COUNT(*) AS total_number_of_agents,
    SUM(A.salary) AS total_salary
FROM
    agent A,
    person P
WHERE A.person_id = P.person_id
GROUP BY
    A.person_id,
    P.gender;

--Create TempRevenueFACT1_V2
DROP TABLE TempRevenueFACT1_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempRevenueFACT1_V2 AS
SELECT
    agent_person_id AS agent_id,
    property_id,
    price AS total_revenue
FROM sale
WHERE client_person_id IS NOT NULL;

--Create TempRevenueFACT2_V2
DROP TABLE TempRevenueFACT2_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE TempRevenueFACT2_V2 AS
SELECT
    agent_person_id as agent_id,
    property_id,
    ROUND((price / 7) * (rent_end_date - rent_start_date), 2) AS total_revenue
FROM rent
WHERE client_person_id IS NOT NULL;

--Create RevenueFACT_V2
DROP TABLE RevenueFACT_V2 CASCADE CONSTRAINTS PURGE;
CREATE TABLE RevenueFACT_V2 AS
SELECT * FROM TempRevenueFACT1_V2
UNION
SELECT * FROM TempRevenueFACT2_V2;

-----------------------------------------------------------------------------------------------

COMMIT;