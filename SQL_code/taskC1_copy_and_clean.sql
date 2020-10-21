DROP TABLE address CASCADE CONSTRAINTS PURGE;
CREATE TABLE address AS
SELECT * FROM monre.address;

DROP TABLE advertisement CASCADE CONSTRAINTS PURGE;
CREATE TABLE advertisement AS
SELECT * FROM monre.advertisement;

DROP TABLE agent CASCADE CONSTRAINTS PURGE;
CREATE TABLE agent AS
SELECT * FROM monre.agent;

DROP TABLE agent_office CASCADE CONSTRAINTS PURGE;
CREATE TABLE agent_office AS
SELECT * FROM monre.agent_office;

DROP TABLE client CASCADE CONSTRAINTS PURGE;
CREATE TABLE client AS
SELECT * FROM monre.client;

DROP TABLE client_wish CASCADE CONSTRAINTS PURGE;
CREATE TABLE client_wish AS
SELECT * FROM monre.client_wish;

DROP TABLE feature CASCADE CONSTRAINTS PURGE;
CREATE TABLE feature AS
SELECT * FROM monre.feature;

DROP TABLE office CASCADE CONSTRAINTS PURGE;
CREATE TABLE office AS
SELECT * FROM monre.office;

DROP TABLE person CASCADE CONSTRAINTS PURGE;
CREATE TABLE person AS
SELECT distinct * FROM monre.person;

DROP TABLE postcode CASCADE CONSTRAINTS PURGE;
CREATE TABLE postcode AS
SELECT * FROM monre.postcode;

DROP TABLE property CASCADE CONSTRAINTS PURGE;
CREATE TABLE property AS
SELECT distinct * FROM monre.property;

DROP TABLE property_advert CASCADE CONSTRAINTS PURGE;
CREATE TABLE property_advert AS
SELECT * FROM monre.property_advert;

DROP TABLE property_feature CASCADE CONSTRAINTS PURGE;
CREATE TABLE property_feature AS
SELECT * FROM monre.property_feature;

DROP TABLE rent CASCADE CONSTRAINTS PURGE;
CREATE TABLE rent AS
SELECT * FROM monre.rent;

DROP TABLE sale CASCADE CONSTRAINTS PURGE;
CREATE TABLE sale AS
SELECT * FROM monre.sale;

DROP TABLE state CASCADE CONSTRAINTS PURGE;
CREATE TABLE state AS
SELECT * FROM monre.state;

DROP TABLE visit CASCADE CONSTRAINTS PURGE;
CREATE TABLE visit AS
SELECT * FROM monre.visit;

DELETE
FROM state
WHERE state_code is null;

DELETE
FROM agent
WHERE salary <= 0;

DELETE
FROM agent_office
WHERE person_id NOT IN
(SELECT person_id FROM AGENT);

DELETE
FROM client
WHERE min_budget > max_budget;

DELETE
FROM client
WHERE person_id NOT IN
(SELECT person_id FROM person);

DELETE
FROM visit
WHERE client_person_id NOT IN
(SELECT person_id FROM client);

DELETE
FROM rent
WHERE client_person_id NOT IN
(SELECT person_id FROM client);

DELETE
FROM person
WHERE address_id NOT IN
(SELECT address_id FROM address);

DELETE
FROM client
WHERE person_id = 7001;