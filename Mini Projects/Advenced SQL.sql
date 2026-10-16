--------------------------------
--- Advanced SQL
--------------------------------


-- Calculate customer churn rates by contract using a CTE.
with contract_churn as (
    select
        dc.Contract,
        count(*) as total_customers,
        sum(case when f.Churn = 1 then 1 else 0 end) as churned_customers
    from FactCustomerChurn as f
    inner join DimContract as dc
        on f.ContractKey = dc.ContractKey
    group by dc.Contract
)
select
    Contract,
    total_customers,
    churned_customers,
    cast(churned_customers * 100.0 / total_customers as decimal(5,2)) as churn_rate
from contract_churn
order by churn_rate desc;


-- Rank contract types by the number of churned customers.
select
    dc.Contract,
    count(*) as total_customers,
    sum(case when f.Churn = 1 then 1 else 0 end) as churned_customers,
    rank() over (
        order by sum(case when f.Churn = 1 then 1 else 0 end) desc
    ) as churn_rank
from FactCustomerChurn as f
inner join DimContract as dc
    on f.ContractKey = dc.ContractKey
group by dc.Contract
order by churn_rank;


-- Calculate total and churned customers for each contract using window functions.
select
    dc.Contract,
    f.CustomerKey,
    f.Churn,
    count(*) over (
        partition by dc.Contract
    ) as total_customers,
    sum(cast(f.Churn as int)) over (
        partition by dc.Contract
    ) as churned_customers
from FactCustomerChurn as f
inner join DimContract as dc
    on f.ContractKey = dc.ContractKey;


-- Calculate customer churn rates by contract using window functions.
    select
    dc.Contract,
    f.CustomerKey,
    f.Churn,
    count(*) over (
        partition by dc.Contract
    ) as total_customers,
    sum(cast(f.Churn as int)) over (
        partition by dc.Contract
    ) as churned_customers,
    cast(
        100.0 * sum(cast(f.Churn as int)) over (
            partition by dc.Contract
        ) / count(*) over (
            partition by dc.Contract
        )
        as decimal(5,2)
    ) as churn_rate
from FactCustomerChurn as f
inner join DimContract as dc
    on f.ContractKey = dc.ContractKey;


-- Classify customers as new or old based on their tenure.
    select
    CustomerKey,
    tenure,
    case
        when tenure <= 12 then 'New Customer'
        else 'Old Customer'
    end as CustomerCategory
from FactCustomerChurn;


-- Compare customer counts and churn rates by customer category.
select
    case
        when tenure <= 12 then 'New Customer'
        else 'Old Customer'
    end as CustomerCategory,
    count(*) as TotalCustomers,
    sum(cast(Churn as int)) as ChurnedCustomers,
    cast(
        100.0 * sum(cast(Churn as int)) / count(*)
        as decimal(5,2)
    ) as ChurnRate
from FactCustomerChurn
group by
    case
        when tenure <= 12 then 'New Customer'
        else 'Old Customer'
    end
order by ChurnRate desc;


-- Find customers whose monthly charges are above the overall average.
select
    CustomerKey,
    MonthlyCharges,
    tenure,
    Churn
from FactCustomerChurn
where MonthlyCharges > (
    select avg(MonthlyCharges)
    from FactCustomerChurn
)
order by MonthlyCharges desc;


-- Compare average monthly charges for churned and retained customers.
select
    case
        when Churn = 1 then 'Churned'
        else 'Retained'
    end as CustomerStatus,
    count(*) as TotalCustomers,
    cast(avg(MonthlyCharges) as decimal(10,2)) as AvgMonthlyCharges
from FactCustomerChurn
group by Churn
order by AvgMonthlyCharges desc;


-- Create a view summarizing customer churn by contract.
create view vw_ChurnByContract
as
select
    dc.Contract,
    count(*) as TotalCustomers,
    sum(cast(f.Churn as int)) as ChurnedCustomers,
    cast(
        100.0 * sum(cast(f.Churn as int)) / count(*)
        as decimal(5,2)
    ) as ChurnRate
from FactCustomerChurn as f
inner join DimContract as dc
    on f.ContractKey = dc.ContractKey
group by dc.Contract;

-- Display churn statistics by contract from the view.
select *
from vw_ChurnByContract
order by ChurnRate desc;
