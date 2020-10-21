--c
--Report 8
--What is the total number of clients and cumulative number of clients with a high budget in each year?
--Version 1
SELECT year, SUM(total_count) AS "TOTAL COUNT", SUM(SUM(total_count)) OVER (ORDER BY year rows unbounded preceding) AS CUMULATIVE FROM
((SELECT td.year, SUM(cf.total_number_of_clients) AS Total_count, SUM(SUM(cf.total_number_of_clients)) OVER (ORDER BY td.year rows unbounded preceding) AS Cumulative 
FROM ClientFACT_V1 cf, clientbudgetDIM_v1 cbd, clientDIM_V1 cd, SaleFACT_V1 sf, TimeDIM_V1 td
WHERE cf.client_budget_id = cbd.client_budget_id
AND cf.client_id = cd.client_id
AND cd.client_id = sf.client_id
AND sf.time_id = td.time_id
AND cf.client_budget_id = 3
GROUP BY td.year)
UNION
(SELECT td.year, SUM(cf.total_number_of_clients) AS Total_count, SUM(SUM(cf.total_number_of_clients)) OVER (ORDER BY td.year rows unbounded preceding) AS Cumulative 
FROM ClientFACT_V1 cf, clientbudgetDIM_v1 cbd, clientDIM_V1 cd, rentFACT_V1 sf, TimeDIM_V1 td
WHERE cf.client_budget_id = cbd.client_budget_id
AND cf.client_id = cd.client_id
AND cd.client_id = sf.client_id
AND sf.time_id = td.time_id
AND cf.client_budget_id = 3
GROUP BY td.year)
UNION
(SELECT td.year, SUM(cf.total_number_of_clients) AS Total_count, SUM(SUM(cf.total_number_of_clients)) OVER (ORDER BY td.year rows unbounded preceding) AS Cumulative 
FROM ClientFACT_V1 cf, clientbudgetDIM_v1 cbd, clientDIM_V1 cd, visitFACT_V1 sf, TimeDIM_V1 td
WHERE cf.client_budget_id = cbd.client_budget_id
AND cf.client_id = cd.client_id
AND cd.client_id = sf.client_id
AND sf.time_id = td.time_id
AND cf.client_budget_id = 3
GROUP BY td.year))
GROUP BY year;


--Version 2
SELECT YEAR, SUM(total_count) AS "TOTAL COUNT", SUM(SUM(total_count)) OVER (ORDER BY year rows unbounded preceding) AS CUMULATIVE FROM
((SELECT TO_CHAR(td.date_id, 'YYYY') AS year, SUM(cf.total_number_of_clients) AS Total_count, SUM(SUM(cf.total_number_of_clients)) OVER (ORDER BY TO_CHAR(td.date_id, 'YYYY') rows unbounded preceding) AS Cumulative 
FROM ClientFACT_V2 cf, clientDIM_V2 cd, SaleFACT_V2 sf, TimeDIM_V2 td
WHERE cf.client_id = cd.client_id
AND cd.client_id = sf.client_id
AND sf.sale_date = td.date_id
AND cd.max_budget BETWEEN 100001 AND 10000000
GROUP BY TO_CHAR(td.date_id, 'YYYY'))
UNION
(SELECT TO_CHAR(td.date_id, 'YYYY') AS year, SUM(cf.total_number_of_clients) AS Total_count, SUM(SUM(cf.total_number_of_clients)) OVER (ORDER BY TO_CHAR(td.date_id, 'YYYY') rows unbounded preceding) AS Cumulative 
FROM ClientFACT_V2 cf, clientDIM_V2 cd, RentFACT_V2 sf, TimeDIM_V2 td
WHERE cf.client_id = cd.client_id
AND cd.client_id = sf.client_id
AND sf.rent_start_date = td.date_id
AND cd.max_budget BETWEEN 100001 AND 10000000
GROUP BY TO_CHAR(td.date_id, 'YYYY'))
UNION
(SELECT TO_CHAR(td.date_id, 'YYYY') AS year, SUM(cf.total_number_of_clients) AS Total_count, SUM(SUM(cf.total_number_of_clients)) OVER (ORDER BY TO_CHAR(td.date_id, 'YYYY') rows unbounded preceding) AS Cumulative 
FROM ClientFACT_V2 cf, clientDIM_V2 cd, VisitFACT_V2 sf, TimeDIM_V2 td
WHERE cf.client_id = cd.client_id
AND cd.client_id = sf.client_id
AND sf.visit_date = td.date_id
AND cd.max_budget BETWEEN 100001 AND 10000000
GROUP BY TO_CHAR(td.date_id, 'YYYY')))
GROUP BY year;

--REPORT 9
--What is the total revenue and cumulative revenue for each property type and for each state?
--Version 1
SELECT PROPERTY_TYPE, STATE_CODE, SUM(TOTAL_REVENUE) AS TOTAL_REVENUE, SUM(SUM(TOTAL_REVENUE)) over (order by property_type rows unbounded preceding) AS CUMULATIVE FROM
((select pd.property_type,a.state_code,
sum(r.total_revenue) as Total_revenue,
sum(sum(r.total_revenue)) over (order by pd.property_type rows unbounded preceding) as Cumulative
from RevenueFACT_V1 r, PropertyTypeDIM_V1 pd, AddressDIM_V1 a, RentFACT_V1 rf, PropertyDIM_V1 p
where rf.property_id=p.property_id
and p.address_id=a.address_id
and p.property_id=r.property_id
and rf.property_type =pd.property_type
group by pd.property_type,a.state_code)
UNION
(select pd.property_type,a.state_code,
sum(r.total_revenue) as Total_salary,
sum(sum(r.total_revenue)) over (order by pd.property_type rows unbounded preceding) as Cumulative
from RevenueFACT_V1 r, PropertyTypeDIM_V1 pd, AddressDIM_V1 a, SaleFACT_V1 sf, PropertyDIM_V1 p
where sf.property_id=p.property_id
and p.address_id=a.address_id
and p.property_id=r.property_id
and sf.property_type =pd.property_type
group by pd.property_type,a.state_code))
GROUP BY PROPERTY_TYPE, STATE_CODE 
ORDER BY PROPERTY_TYPE;


----Version 2

select pd.property_type,a.state_code,
sum(r.total_revenue) as Total_revenue,
sum(sum(r.total_revenue)) over (order by pd.property_type rows unbounded preceding) as Cumulative
from RevenueFACT_V2 r, PropertyDIM_V2 pd, AddressDIM_V2 a
where r.property_id=pd.property_id
and pd.address_id=a.address_id
group by pd.property_type,a.state_code;


---REPORT 10
--What is the total rental fee and moving aggregate in 2020 for Victoria?
--Version 1
select t.month as Month, 
a.state_code,
sum(r.total_rental_fees) as Total_Rent_fees,
avg(sum(r.total_rental_fees)) over (order by a.state_code,t.month rows 2 preceding)
as Avg_3_Months
from RentFact_V1 r, 
AddressDIM_V1 a, 
TimeDIM_V1 t
where r.Time_id = t.time_id
and r.address_id=a.address_id
and t.year ='2020'
and a.state_code='VIC'
group by t.month,a.state_code;

--Version 2
select to_char(r.rent_start_date, 'MM') AS Month, 
a.state_code,
sum(r.total_rental_fees) as Total_Rent_fees,
avg(sum(r.total_rental_fees)) over (order by a.state_code,to_char(r.rent_start_date, 'MM') rows 2 preceding)
as Avg_3_Months
from RentFact_V2 r, 
AddressDIM_V2 a, 
TimeDIM_V2 t
where r.rent_start_date = t.date_id
and r.address_id=a.address_id
and to_char(r.rent_start_date, 'YYYY') ='2020'
and a.state_code='VIC'
group by to_char(r.rent_start_date, 'MM'),a.state_code;
