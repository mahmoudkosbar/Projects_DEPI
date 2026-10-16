-- =========================================
-- 1. Overview
-- =========================================

select count(*) as total_customers
from data_after_py;

select churn, count(*) as customer_count
from data_after_py
group by churn;

select
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py;

-- =========================================
-- 2. Churn by Contract
-- =========================================

select
contract,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by contract;

-- =========================================
-- 3. Churn by Internet Service
-- =========================================

select
InternetService,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by InternetService;

-- =========================================
-- 4. Churn by Payment Method
-- =========================================

select
PaymentMethod,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by PaymentMethod;

-- =========================================
-- 5. Churn by Customer Type
-- =========================================

select
CustomerType,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by CustomerType;

-- =========================================
-- 6. Average Monthly Charges by Churn
-- =========================================

select
churn,
count(*) as customer_count,
avg(MonthlyCharges) as avg_monthly_charges
from data_after_py
group by churn;

-- =========================================
-- 7. Monthly Charges Associated with Churn
-- =========================================

select
count(*) as churned_customers,
sum(MonthlyCharges) as associated_monthly_charges,
avg(MonthlyCharges) as avg_monthly_charges
from data_after_py
where churn = 1;

-- =========================================
-- 8. Simplified Customer Lifetime Revenue
-- =========================================

select
churn,
count(*) as customer_count,
avg(MonthlyCharges * tenure) as avg_customer_lifetime_revenue
from data_after_py
group by churn;

-- =========================================
-- 9. Average Tenure by Churn
-- =========================================

select
churn,
count(*) as customer_count,
avg(tenure) as avg_tenure_months
from data_after_py
group by churn;

-- =========================================
-- 10. Churn by Tenure Group
-- =========================================

select
case
when tenure <= 12 then '0-12 months'
when tenure <= 36 then '13-36 months'
else '37+ months'
end as tenure_group,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by
case
when tenure <= 12 then '0-12 months'
when tenure <= 36 then '13-36 months'
else '37+ months'
end;

-- =========================================
-- 11. Churn by Senior Citizen
-- =========================================

select
SeniorCitizen,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by SeniorCitizen;

-- =========================================
-- 12. Churn by Paperless Billing
-- =========================================

select
PaperlessBilling,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by PaperlessBilling;

-- =========================================
-- 13. Churn by Partner
-- =========================================

select
Partner,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by Partner;

-- =========================================
-- 14. Churn by Dependents
-- =========================================

select
Dependents,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by Dependents;

-- =========================================
-- 15. Churn by Online Security
-- =========================================

select
OnlineSecurity,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by OnlineSecurity;

-- =========================================
-- 16. Churn by Online Backup
-- =========================================

select
OnlineBackup,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by OnlineBackup;

-- =========================================
-- 17. Churn by Tech Support
-- =========================================

select
TechSupport,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by TechSupport;

-- =========================================
-- 18. Churn by Device Protection
-- =========================================

select
DeviceProtection,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by DeviceProtection;

-- =========================================
-- 19. Churn by Multiple Lines
-- =========================================

select
MultipleLines,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by MultipleLines;

-- =========================================
-- 20. Churn by Streaming TV
-- =========================================

select
StreamingTV,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by StreamingTV;

-- =========================================
-- 21. Churn by Streaming Movies
-- =========================================

select
StreamingMovies,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by StreamingMovies;

-- =========================================
-- 22. Churn by Phone Service
-- =========================================

select
PhoneService,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by PhoneService;

-- =========================================
-- 23. Churn by Total Services
-- =========================================

select
TotalServices,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by TotalServices
order by TotalServices;

-- =========================================
-- 24. Churn by Contract and Total Services
-- =========================================

select
Contract,
TotalServices,
count(*) as customer_count,
sum(case when churn = 1 then 1 else 0 end) as churned_customers,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by Contract, TotalServices
order by Contract, TotalServices;

-- =========================================
-- 25. Revenue Analysis by Contract
-- =========================================

select
Contract,
count(*) as customer_count,
avg(MonthlyCharges) as avg_monthly_charges,
sum(MonthlyCharges) as total_monthly_charges,
sum(case when churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by Contract
order by churn_rate desc;

-- =========================================
-- 26. Monthly Charges Associated with Churn by Contract
-- =========================================

select
Contract,
count(*) as churned_customers,
sum(MonthlyCharges) as associated_monthly_charges,
avg(MonthlyCharges) as avg_monthly_charges
from data_after_py
where Churn = 1
group by Contract
order by associated_monthly_charges desc;

-- =========================================
-- 27. Total Charges by Contract
-- =========================================

select
Contract,
count(*) as customer_count,
avg(TotalCharges) as avg_total_charges,
sum(TotalCharges) as total_charges
from data_after_py
group by Contract
order by avg_total_charges desc;

-- =========================================
-- 28. Churn by Monthly Charge Category
-- =========================================

select
case
when MonthlyCharges < 35 then 'Low Charges'
when MonthlyCharges < 70 then 'Medium Charges'
else 'High Charges'
end as charge_category,
count(*) as customer_count,
sum(case when Churn = 1 then 1 else 0 end) as churned_customers,
sum(case when Churn = 1 then 1 else 0 end) * 100.0 / count(*) as churn_rate
from data_after_py
group by
case
when MonthlyCharges < 35 then 'Low Charges'
when MonthlyCharges < 70 then 'Medium Charges'
else 'High Charges'
end
order by churn_rate desc;


