select * 
from layoffs;

select count(*)
from layoffs;
-- 2361 rows there

-- always take backup and manipulate that 
create table layoffs_duplicate
like layoffs;

insert into layoffs_duplicate
select * 
from layoffs;

select *
from layoffs_duplicate;

# Data Cleaning

-- 1.Remove Duplicates


select *, 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions order by total_laid_off) as rn
from layoffs;

with cte as (
	select *, 
	row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised_millions order by total_laid_off) as rn
	from layoffs
)
select * 
from cte
where rn > 1;

select *
from layoffs_duplicate
where company = 'yahoo';

create table layoffs_duplicate2 as 
select distinct *
from layoffs_duplicate;

select *
from layoffs_duplicate2;

-- 2. Standardize data

select * from layoffs_duplicate2;

select distinct(company), trim(company)
from layoffs_duplicate2
order by 1;

update layoffs_duplicate2
set company = trim(company);
-- there is lot of company we cant see manually

select distinct location
from layoffs_duplicate2
order by 1;
-- too many here too

select distinct(industry)
from layoffs_duplicate2
order by 1;

select *
from layoffs_duplicate2
where industry like 'crypto%';

update layoffs_duplicate2
set industry = 'Crypto'
where industry like 'crypto%';
-- treated industry 

select distinct country 
from layoffs_duplicate2
order by 1;
-- found 2 united states

update layoffs_duplicate2
set country = trim(trailing '.' from country);
-- treated country col

select `date`, str_to_date(`date`,'%m/%d/%Y')
from layoffs_duplicate2;

update layoffs_duplicate2
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_duplicate2
modify `date` date;

-- 3. Null values

select * from layoffs_duplicate2;

-- we can not populate values to company, location, total_laid_off, percentage but we can populate country and industry

select distinct country
from layoffs_duplicate2
order by 1;
-- no nulls in country

select distinct industry 
from layoffs_duplicate2
order by 1;

-- lets populate nulls in industry using company and location

update layoffs_duplicate2
set industry = null
where industry = '';

select *
from layoffs_duplicate2 t1
join layoffs_duplicate2 t2 on t1.company = t2.company and t1.location = t2.location
where t1.industry is null and t2.industry is not null;

-- now lets populate t2.industry to t1.industry
update layoffs_duplicate2 t1
join layoffs_duplicate2 t2 on t1.company = t2.company and t1.location = t2.location
set t1.industry = t2.industry
where t1.industry is null and t2.industry is not null;

select *
from layoffs_duplicate2
where industry is null;
-- we have only one company which we can not populate

-- now lets delete where both data about layoff is null
select *
from layoffs_duplicate2
where total_laid_off is null and percentage_laid_off is null;

delete from layoffs_duplicate2
where total_laid_off is null and percentage_laid_off is null;

/*
	wow cool! now we have finished data cleaning.
    now our clean data is ready for eda.
*/