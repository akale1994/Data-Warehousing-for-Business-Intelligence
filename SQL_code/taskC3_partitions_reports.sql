--d
--REPORT 11: Show ranking of each property type based on the yearly total
--number of sales and the ranking of each state based on the yearly total number of
--sales.
--Version 1
select s.property_type,
a.state_code,
t.year,
to_char(sum(s.total_sales)) as Sales$, 
DENSE_RANK() OVER (PARTITION BY s.property_type 
order by sum(s.total_sales) DESC) AS RANK_BY_PROPERTY, 
DENSE_RANK() OVER (PARTITION BY a.state_code
order by sum(s.total_sales) DESC) as RANK_BY_STATE 
from SaleFACT_V1 s,
propertytypedim_v1 p,
AddressDIM_V1 a,
TimeDIM_V1 t
where s.property_type=p.property_type
and a.address_id=s.address_id
and s.time_id=t.time_id
group by s.property_type, a.state_code,t.year;

--Version 2
select p.property_type,
a.state_code,
to_char(S.sale_date, 'YYYY') AS "YEAR",
to_char(sum(s.total_sales)) as Sales$, 
DENSE_RANK() OVER (PARTITION BY p.property_type 
order by sum(s.total_sales) DESC) AS RANK_BY_PROPERTY, 
DENSE_RANK() OVER (PARTITION BY a.state_code
order by sum(s.total_sales) DESC) as RANK_BY_STATE 
from SaleFACT_V2 s,
propertydim_v2 p,
AddressDIM_V2 a,
TimeDIM_V2 t
where s.property_id=p.property_id
and a.address_id=s.address_id
and s.sale_date=t.date_id
group by p.property_type, 
a.state_code,
to_char(S.sale_date, 'YYYY');

--Report 12
--Show ranking of each advertisement type based on total number of properties and ranking of each state 
--based on total number of properties.
--Version 1

select a.advert_name, ad.state_code, to_char(sum(pf.total_number_of_properties)) as Total_properties,
DENSE_RANK() OVER(PARTITION BY a.advert_name 
order by sum(pf.total_number_of_properties) DESC) AS RANK_BY_Advertisements,
DENSE_RANK() OVER(PARTITION BY ad.state_code
order by sum(pf.total_number_of_properties) DESC) AS RANK_BY_states
from PropertyFACT_V1 pf, PropertyDIM2_V1 pd, PropertyAdvertisementBRIDGE_V1 pfb, AdvertisementDIM_V1 a, AddressDIM_V1 ad 
where pf.property_id=pd.property_id
and pd.property_id=pfb.property_id
and pfb.advert_id=a.advert_id
and pf.address_id=ad.address_id
group by a.advert_name, ad.state_code;

--Version 2
select a.advert_name, ad.state_code, to_char(sum(pf.total_number_of_properties)) as Total_properties,
DENSE_RANK() OVER(PARTITION BY a.advert_name 
order by sum(pf.total_number_of_properties) DESC) AS RANK_BY_Advertisements,
DENSE_RANK() OVER(PARTITION BY ad.state_code
order by sum(pf.total_number_of_properties) DESC) AS RANK_BY_states
from PropertyFACT_V2 pf, PropertyDIM2_V2 pd, PropertyAdvertisementBRIDGE_V2 pfb, AdvertisementDIM_V2 a, AddressDIM_V2 ad 
where pf.property_id=pd.property_id
and pd.property_id=pfb.property_id
and pfb.advert_id=a.advert_id
and pf.address_id=ad.address_id
group by a.advert_name, ad.state_code;


