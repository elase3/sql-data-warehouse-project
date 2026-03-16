-- cleansing bronze.crm_cust_info

insert into silver.crm_cust_info (
cst_id,
cst_key,
cst_firstname,
cst_lastname ,
cst_marital_status,
cst_gndr,
cst_create_date
)
select 
cst_id,
cst_key,
trim(cst_firstname) as cst_firstname,
trim(cst_lastname) as cst_lastname ,
case when upper(trim(cst_marital_status)) = 'S' then 'Single'
	 when upper(trim(cst_marital_status)) = 'M' then 'Married'
	 else 'n/a'
end cst_marital_status,
case when upper(trim(cst_gndr)) = 'M' then 'Male'
	 when upper(trim(cst_gndr)) = 'F' then 'Female'
	 else 'n/a'
end cst_gndr,
cst_create_date
from (
select  * ,
ROW_NUMBER() OVER(PARTITION BY cst_id ORDER BY cst_create_date DESC) as rn
from bronze.crm_cust_info
) as t 
where rn = 1
