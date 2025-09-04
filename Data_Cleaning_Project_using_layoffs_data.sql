select * 
from layoffs;

select count(*)
from layoffs;
-- 4141 rows there

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

-- checking duplicates
select *, 
row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised order by total_laid_off) as rn
from layoffs;

with cte as (
	select *, 
	row_number() over(partition by company, location, industry, total_laid_off, percentage_laid_off, `date`, stage, country, funds_raised order by total_laid_off) as rn
	from layoffs
)
select * 
from cte
where rn > 1;

select *
from layoffs_duplicate
where company = 'cazoo';

-- removing duplicates

create table layoffs_duplicate2 as 
with cte as(
	select * ,
		   row_number() over(partition by company, location, total_laid_off, `date`, percentage_laid_off,industry, stage, funds_raised, country
							 order by company) as rn
	from layoffs_duplicate
)
select *
from cte
where rn = 1;

select *
from layoffs_duplicate2;

-- 2. Standardize data

select * from layoffs_duplicate2;

-- company
select distinct(company), trim(company)
from layoffs_duplicate2
order by 1;

update layoffs_duplicate2
set company = trim(company);

-- location
select distinct location
from layoffs_duplicate2
order by 1;
-- too many here too

-- industry
select distinct(industry)
from layoffs_duplicate2
order by 1;

-- country
select distinct country 
from layoffs_duplicate2
order by 1;
-- found 2 UAE cz uae and united arab emirates are same

update layoffs_duplicate2
set country = 'UAE'
WHERE country = 'united arab emirates';
-- treated country column

-- date
select `date`, str_to_date(`date`,'%m/%d/%Y')
from layoffs_duplicate2;

update layoffs_duplicate2
set `date` = str_to_date(`date`, '%m/%d/%Y');

alter table layoffs_duplicate2
modify `date` date;

-- date_added
select date_added, str_to_date(date_added,'%m/%d/%Y')
from layoffs_duplicate2;

update layoffs_duplicate2
set date_added = str_to_date(date_added, '%m/%d/%Y');

alter table layoffs_duplicate2
modify date_added date;

-- total_laid_off
alter table layoffs_duplicate2
modify total_laid_off bigint;

-- percentage_laid_off
update layoffs_duplicate2
set percentage_laid_off = trim(trailing '%' from percentage_laid_off);

alter table layoffs_duplicate2
modify percentage_laid_off decimal(5,1);

-- funds_raised
update layoffs_duplicate2
set funds_raised = trim(leading '$' from funds_raised);

update layoffs_duplicate2
set funds_raised = null
where funds_raised = '';

alter table layoffs_duplicate2
modify funds_raised bigint;

-- 3. Null values

select * from layoffs_duplicate2;

-- we can not populate values to company, location, total_laid_off, percentage but we can populate country and industry

-- country
select distinct country
from layoffs_duplicate2
order by 1;

select *
from layoffs_duplicate2 
where country = '';

update layoffs_duplicate2
set country = null
where country = '';

select * from layoffs_duplicate2 where country is null;

select count(*) from layoffs_duplicate2 where country is null;

select distinct t1.location,t1.country, t2.location, t2.country
from layoffs_duplicate2 t1
join layoffs_duplicate2 t2 on t1.location = t2.location 
where t1.country is null and t2.country is not null;

update layoffs_duplicate2 t1
join layoffs_duplicate2 t2 on t1.location = t2.location 
set t1.country = t2.country
where t1.country is null and t2.country is not null;
-- now we have pupulated country using location

-- industry
select distinct industry
from layoffs_duplicate2
order by 1;

update layoffs_duplicate2
set industry = null
where industry = '';

-- lets populate nulls in industry using company and location
select *
from layoffs_duplicate2 t1
join layoffs_duplicate2 t2 on t1.company = t2.company and t1.location = t2.location
where t1.industry is null and t2.industry is not null;
-- nothing showing up lets check

select * from layoffs_duplicate2 where industry is null;
-- yeah both are unique companies in that location
-- so we can not populate for that 

-- now lets delete where both data about layoff is null

select *
from layoffs_duplicate2
where total_laid_off is null;

update layoffs_duplicate2
set total_laid_off = null
where total_laid_off = '';

select distinct percentage_laid_off
from layoffs_duplicate2
order by 1;

update layoffs_duplicate2
set percentage_laid_off = null
where percentage_laid_off = '';

select *
from layoffs_duplicate2
where total_laid_off is null and percentage_laid_off is null;

delete from layoffs_duplicate2
where total_laid_off is null and percentage_laid_off is null;

-- 4. Drop unwanted columns

alter table layoffs_duplicate2
drop column rn;

select * from layoffs_duplicate2;

select count(*) from layoffs_duplicate2; 
-- finally 3458 rows remains after cleaning

/*
	wow cool! now we have finished data cleaning.
    now our clean data is ready for eda.
*/
