SELECT * FROM investment

-- PART1 DATA EXPLORATION
-- PART2 ANSWERING BUSINESS QUESTIONS
-- PART3 GATHERIN INSIGHTS FROM DATA

PART1 DATA EXPLORATION
check null values and remove it
concat or split columns if needed
make everything lower case
GET RID OF OUTLIERS
SELECT DISTINCT VALUES

ALTER TABLE investment
RENAME COLUMN debt_fincing to debt_financing

SELECT market FROM investment
group by market;

UPDATE investment 
SET market = lower(market)

SELECT * FROM investment

SELECT market FROM investment
WHERE market LIKE 'fin%'
group by market

UPDATE investment
SET market = 'financial services'
WHERE market= 'fincialservices'

-- checking all funding_total_usd

SELECT funding_total_usd FROM investment
WHERE funding_total_usd isnull and seed > 0
or  funding_total_usd isnull and venture > 0
or  funding_total_usd isnull and equity_crowdfunding > 0
or  funding_total_usd isnull and undisclosed > 0
or  funding_total_usd isnull and undisclosed > 0
or  funding_total_usd isnull and convertible_note > 0
or  funding_total_usd isnull and debt_financing > 0
or  funding_total_usd isnull and private_equity > 0

-- upon checking all funding_total_usd has zero funding then its okay to remove it

SELECT * FROM investment
WHERE market LIKE 'financial%'

DELETE FROM investment
WHERE funding_total_usd isnull

SELECT * FROM investment
WHERE market LIKE 'financial services'

-- replacing null status column

UPDATE investment
SET status = 'unknown'
WHERE status isnull

-- lowercase on country_code column and setting null values to unknown

UPDATE investment
SET country_code = 'unknown'
WHERE country_code isnull

UPDATE investment 
SET country_code = lower(country_code) 

-- filling null of values of founded_year column

UPDATE investment
SET founded_year = 0
WHERE founded_year isnull

SELECT * FROM investment
WHERE market LIKE 'financial services'

-- checking the outliers of the data using zscore


SELECT *,
(funding_total_usd- AVG(funding_total_usd) over())/ (STDDEV(funding_total_usd) over()) as outlier_test FROM investment

-- Filtering the data of the outlier

SELECT * FROM (
SELECT *,
(funding_total_usd- AVG(funding_total_usd) over())/ (STDDEV(funding_total_usd) over()) as outlier_test FROM investment
)x
WHERE x.market = 'financial services' and x.outlier_test < -2.576
or x.market = 'financial services' and x.outlier_test > 2.576

-- selecting data without outlier and getting only the distinct data

SELECT DISTINCT * FROM (
SELECT *,
(funding_total_usd- AVG(funding_total_usd) over())/ (STDDEV(funding_total_usd) over()) as outlier_test FROM investment
)x
WHERE x.market = 'financial services' and x.outlier_test > -2.576
and x.market = 'financial services' and x.outlier_test < 2.576

-- calculating for average_Seed and STDDEV_seed

SELECT *, AVG(seed) over() as avg_seed ,((seed- AVG(seed) over())/STDDEV(seed) over()) as Stddev_seed FROM(SELECT DISTINCT * FROM (
SELECT *,
(funding_total_usd- AVG(funding_total_usd) over())/ (STDDEV(funding_total_usd) over()) as outlier_test FROM investment
)x
WHERE x.market = 'financial services' and x.outlier_test > -2.576 
and x.market = 'financial services' and x.outlier_test < 2.576)y