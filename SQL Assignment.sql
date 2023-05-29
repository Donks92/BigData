SQL Assignment


1. How many countries can be found in the education 1 & 2 table?

Query used
Provides a list:
SELECT country_iso 
FROM education.education_indicators1
group by country_iso 

Provides the number:
SELECT COUNT(DISTINCT country_iso) 
FROM education.education_indicators1

Answer: 10 = 6 in table 1, 4 in table 2

2. Indicator_code, check for null values

Query used
SELECT indicator_code
FROM education.education_indicators1
WHERE indicator_code IS NULL;

SELECT indicator_code
FROM education.education_indicators2
WHERE indicator_code IS NULL;

Answer: no null values in education_indicators1 & 2

3. education_indicators.1 — find 'Number of infant deaths, male', France and year 2000?

Query used
// LIKE is used for strings to query a specific name
// and is used to look for multiple values, all of them need to be met
// or is used if you are looking for and/or
//you do not need LIKE for numbers

SELECT *
from education.education_indicators1
where country_iso LIKE 'FRA' and year=2000 and indicator_name LIKE 'Number of infant deaths, male'

Answer: 1761

4. Which is the country and year with the highest value for 'Primary education, female'

Query used
// putting a after the table name create an alias
// a.* is a command to view the full table in your SQL dash

SELECT MAX(value), a.*
FROM education.education_indicators1 a
WHERE indicator_name LIKE '%primary education, female%'

Answer: AUS 1970

5. Which is the maximum historical value for the indicator 'Number of infant deaths, female' in France?

Query used
//You must spell everything perfectly for it to work, case matters!

SELECT MAX(value), a.country_iso
FROM education.education_indicators1 a
WHERE indicator_name LIKE 'Number of infant deaths, female' and country_iso LIKE 'FRA'

Answer: 8282

6. Which are the countries with more than 30 years with a value of 'Number of under - five deaths, female' higher than 1000?

Query used
select b.country_iso, count(*)
from 
(SELECT  a.country_iso, year 
from education.education_indicators1 a 
where value > 1000 and 
indicator_name LIKE "Number of under-five deaths, female" 
group by a.country_iso, year) b
group by b.country_iso 
having count(*)>30

OR

SELECT * from
(
SELECT count(distinct year) AS "countyears", country_iso
FROM education.education_indicators1 a
WHERE indicator_name LIKE "Number of under-five deaths, female" and value > 1000
group by country_iso
)
b
where b.countyears > 30

Answer: FRA, KOR

7. Which are the 3 TOP countries with highest average (historical) value of the indicator 'School enrollment, secondary (% net)'

Query used
SELECT AVG(value), a.*
from education.education_indicators1 a
WHERE a.indicator_name LIKE "School enrollment, secondary (% net)" 
group by country_iso
order by avg(value) desc 
LIMIT 3

Answer: SGP, AUS, FRA

8. Knowing that the total population with less than 25 years of age can be known per forming a sum operation on all the indicators that start with 'Population, ages’ and end with ‘total’ , return this total population below 25 for France in the year 2000.

Query used
SELECT sum(value), a.*
from education.education_indicators1 a
WHERE a.indicator_name LIKE 'Population ages 0-14%' and a.indicator_name LIKE '%total population)' and country_iso="FRA" and year=2000
group by country_iso

Answer: No way to tell avg pop between 15-25, only 0-14 & 15-65 brackets, but for 0-14 = 18.72% average sum

9. Which is the value for Switzerland of the ‘Repeaters in Grade 1 of primary education, both sexes (number)’ plus ‘Repeaters in Grade 2 of primary education, both sexes (number)’ for year 2000

Query used
SELECT sum(value), a.*
from education.education_indicators1 a
WHERE a.indicator_name LIKE 'Repeaters in Grade 1 of primary education, both sexes (number)' and a.indicator_name LIKE 'Repeaters in Grade 2 of primary education, both sexes (number)' and country_iso=“CHE” and year=2000
group by country_iso

Answer: Data does not exist in the data set

10. Which is the minimum value of the indicator 'Number of infant deaths, male' for Korea out of all years before 1980 (not included) and after 2000 (including 2000)

Query used
// combining AND OR here says the row will be scanned for both conditions, AND only included in the result is true for both condition.

SELECT MIN(value), year 
from education.education_indicators1 
WHERE indicator_name LIKE "number of infant deaths, male" 
and country_iso='KOR' 
and (year < 1980 or year >= 2000);

Answer: year 2020 had the min value, it was 526

11. Which is the maximum year that we have data for the indicator code 'BAR.SEC.SCHL.4549'
 
Query used
SELECT *
from education.education_indicators1 
WHERE indicator_code LIKE 'BAR.SEC.SCHL.4549'
order by year desc

OR

SELECT MAX(year), year
from education.education_indicators1 
WHERE indicator_code LIKE 'BAR.SEC.SCHL.4549'

Answer: 2010

12. For that year, and considering ALL the countries, which are the top 3 countries with highest value of the indicator 'BAR.SEC.SCHL.4549'

Query used
SELECT *
from education.education_indicators1 
WHERE indicator_code LIKE 'BAR.SEC.SCHL.4549' and year=2010
Group by country_iso
Order by value desc
LIMIT 3

Answer:  Switzerland, France, Korea


13. Now, considering the same indicator 'BAR.SEC.SCHL.4549', all the years, and the 3 previous countries, which are the average values for those countries

Query used
SELECT AVG(value), a.*
from education.education_indicators1 a
WHERE a.indicator_code LIKE 'BAR.SEC.SCHL.4549' and a.country_iso IN ('FRA','CHE','KOR')
Group by country_iso

Answer:  Switzerland (4.06), France (3.19), Korea (2.81)

14. Check if there is any country of the country_dim table that does not exist in the education_indicators1 table

Query used
// NOT IN removes all items from country dim present in education indicators

SELECT country_iso
FROM education.country_dim
WHERE country_iso NOT IN (
    SELECT country_iso
    FROM education.education_indicators1
)
GROUP BY country_iso;

Answer: FIN, IT, JPN, POL, CAN, SWE, ESP, PT

15. Without the education_indicators2 table, check for all the indicators in the table death_prob_thresholds if for year 2000 and for France the objective threshold was higher than the values (the result are 4 rows).
16. And were higher than the risk threshold?

STEP 1: Get the values in FRA for 2000 looking at deaths
Query used
SELECT indicator_name, (value/1000)
from education.education_indicators1 a
WHERE  country_iso='FRA' and year=2000 and indicator_name LIKE '%deaths ages%'

STEP 2: divide values by 1000 to get the per 1,000 metric & compare to objective threshold
CALCULATIONS DONE
5-9 value 0.467 vs objective threshold 0.32 vs risk threshold 0.64
10-14 value 0.536 vs objective threshold 0.5 vs risk threshold 1
15-19 value 1.761 vs objective threshold 1.15 vs risk threshold 2
20-24 value 2.707 vs objective threshold 1.75 vs risk threshold 2.5

Answer: 
In all age brackets, in 2000 in France the death probability was higher than the objective threshold, 
but lower than the risk threshold for all but the 20-24 age range.

17. For France and the indicator ‘Probability of dying among children ages 5-9 years (per 1,000)’ how many years the values are lower than the risk threshold

5-9 risk threshold 0.64

Check:
SELECT country_iso, indicator_name, (value/1000)
from education.education_indicators1 
WHERE  country_iso='FRA' and indicator_name = 'Number of deaths ages 5-9 years' 
order by value desc

Check:
SELECT country_iso, indicator_name, (value/1000)
from education.education_indicators1 
WHERE  country_iso='FRA' and indicator_name = 'Number of deaths ages 5-9 years' and value<0.64

Query Used:
SELECT country_iso, indicator_name, (value/1000), count(distinct year)
from education.education_indicators1 
WHERE  country_iso='FRA' and indicator_name = 'Number of deaths ages 5-9 years' and value/1000 < 0.64
order by value desc

Answer: 28

18. Without considering the education_indicators2 table, which is the country that has less than 15 years with a value of the indicator = 'Probability of dying among children ages 5 - 9 years (per 1,000)' lower than the risk threshold?

Query Used:
SELECT country_iso, indicator_name, (value/1000), count(distinct year)
from education.education_indicators1 
WHERE indicator_name = 'Number of deaths ages 5-9 years' and value/1000 < 0.64 
Group by country_iso
order by value desc

Answer: None, KOR closest with 18 years, then FRA with 28 and all others 32

19. Do all the countries have the same number of indicators?

Query Used:
SELECT country_iso, count(distinct indicator_name)
from education.education_indicators1 
Group by country_iso
order by count(distinct indicator_name) desc

Answer: No, only FRA and NLD have the same at 855


20. Calculate for each country of education_indicators1 table the percentage of years that the value of the indicators is higher than the risk threshold. The result must be a table of 3 columns: country, % of the indicator 'Probability of dying among adolescents ages 10 - 14 years (per 1,000)' and % of the indicator 'Probability of dying among adolescents ages 15 - 19 years (per 1,000).

Query Used: 
SELECT (value/1000), country_iso, 
	(COUNT(CASE WHEN indicator_name = 'Number of deaths ages 10-14 years' and value/1000 > 0.5 THEN 1 END) / COUNT(*) * 100) AS "% Probability of dying among adolescents ages 10 - 14 years (per 1,000)",
    (COUNT(CASE WHEN indicator_name = 'Number of deaths ages 15-19 years' and value/1000 > 1.15 THEN 1 END) / COUNT(*) * 100) AS "% Probability of dying among adolescents ages 15 - 19 years (per 1,000)"
FROM education.education_indicators1 
GROUP BY country_iso


QUESTIONS FOR FRIDAY:
1. For question 8 there is no way to tell avg pop between 15-25, only 0-14 & 15-65 brackets, but for 0-14 = 18.72% average sum
2. For question 9 the data does not exist in the data set
3. I got the answer to 16, 17 and 18, but manually, how do I build a query to do this calculation for me?
4. For question 18 there are no countries that meet the criteria requested
5. Can we break question 20 down 