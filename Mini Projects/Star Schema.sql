use TelecomChurnDB;

select top 5 *
from data_after_py;


-- Create the customer dimension table.
create table DimCustomer (
    CustomerKey int identity(1,1) primary key,
    customerID nvarchar(50) not null unique,
    gender nvarchar(20),
    SeniorCitizen bit,
    Partner nvarchar(10),
    Dependents nvarchar(10),
    CustomerType nvarchar(50)
);

-- Insert unique customer records into the dimension table.
insert into DimCustomer (
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    CustomerType
)
select distinct
    customerID,
    gender,
    SeniorCitizen,
    Partner,
    Dependents,
    CustomerType
from data_after_py;

-- Count the total customers in the dimension table.
select count(*) as total_customers
from DimCustomer;


-- Create the contract dimension table.
create table DimContract (
    ContractKey int identity(1,1) primary key,
    Contract nvarchar(50) not null unique
);


-- Insert unique contract types.
insert into DimContract (Contract)
select distinct Contract
from data_after_py
where Contract is not null;

-- Preview the contract dimension table.
select *
from DimContract;



-- Create the internet service dimension table.
create table DimInternetService (
    InternetServiceKey int identity(1,1) primary key,
    InternetService nvarchar(50) not null unique
);

-- Insert unique internet service types.
insert into DimInternetService (InternetService)
select distinct InternetService
from data_after_py
where InternetService is not null;

-- Preview the internet service dimension table.
select *
from DimInternetService;



-- Create the payment method dimension table.
create table DimPaymentMethod (
    PaymentMethodKey int identity(1,1) primary key,
    PaymentMethod nvarchar(100) not null unique
);


-- Insert unique payment methods.
insert into DimPaymentMethod (PaymentMethod)
select distinct PaymentMethod
from data_after_py
where PaymentMethod is not null;

-- Preview the payment method dimension table.
select *
from DimPaymentMethod;




-- Create the fact table and define its relationships with dimension tables.
create table FactCustomerChurn (
    FactKey int identity(1,1) primary key,

    CustomerKey int not null,
    ContractKey int not null,
    InternetServiceKey int not null,
    PaymentMethodKey int not null,

    tenure tinyint,
    MonthlyCharges float,
    TotalCharges float,
    Churn bit,

    PhoneService nvarchar(10),
    MultipleLines nvarchar(50),
    OnlineSecurity nvarchar(50),
    OnlineBackup nvarchar(50),
    DeviceProtection nvarchar(50),
    TechSupport nvarchar(50),
    StreamingTV nvarchar(50),
    StreamingMovies nvarchar(50),

    TotalServices int,
    AvgMonthlySpend float,

    constraint FK_Fact_Customer
        foreign key (CustomerKey)
        references DimCustomer(CustomerKey),

    constraint FK_Fact_Contract
        foreign key (ContractKey)
        references DimContract(ContractKey),

    constraint FK_Fact_Internet
        foreign key (InternetServiceKey)
        references DimInternetService(InternetServiceKey),

    constraint FK_Fact_Payment
        foreign key (PaymentMethodKey)
        references DimPaymentMethod(PaymentMethodKey)
);



-- Insert customer churn data and dimension keys into the fact table.
insert into FactCustomerChurn (
    CustomerKey,
    ContractKey,
    InternetServiceKey,
    PaymentMethodKey,
    tenure,
    MonthlyCharges,
    TotalCharges,
    Churn,
    PhoneService,
    MultipleLines,
    OnlineSecurity,
    OnlineBackup,
    DeviceProtection,
    TechSupport,
    StreamingTV,
    StreamingMovies,
    TotalServices,
    AvgMonthlySpend
)
select
    dc.CustomerKey,
    dcon.ContractKey,
    dis.InternetServiceKey,
    dpm.PaymentMethodKey,
    src.tenure,
    src.MonthlyCharges,
    src.TotalCharges,
    src.Churn,
    src.PhoneService,
    src.MultipleLines,
    src.OnlineSecurity,
    src.OnlineBackup,
    src.DeviceProtection,
    src.TechSupport,
    src.StreamingTV,
    src.StreamingMovies,
    src.TotalServices,
    src.AvgMonthlySpend
from data_after_py as src
inner join DimCustomer as dc
    on src.customerID = dc.customerID
inner join DimContract as dcon
    on src.Contract = dcon.Contract
inner join DimInternetService as dis
    on src.InternetService = dis.InternetService
inner join DimPaymentMethod as dpm
    on src.PaymentMethod = dpm.PaymentMethod;



-- Count the records inserted into the fact table.
select count(*) as total_fact_records
from FactCustomerChurn;



-- Check for fact records without a matching customer.
select count(*) as unmatched_customers
from FactCustomerChurn as f
left join DimCustomer as c
    on f.CustomerKey = c.CustomerKey
where c.CustomerKey is null;


-- Check for unmatched dimension keys in the fact table.
select
    count(*) as total_records,
    sum(case when dcon.ContractKey is null then 1 else 0 end) as unmatched_contracts,
    sum(case when dis.InternetServiceKey is null then 1 else 0 end) as unmatched_internet_services,
    sum(case when dpm.PaymentMethodKey is null then 1 else 0 end) as unmatched_payment_methods
from FactCustomerChurn as f
left join DimContract as dcon
    on f.ContractKey = dcon.ContractKey
left join DimInternetService as dis
    on f.InternetServiceKey = dis.InternetServiceKey
left join DimPaymentMethod as dpm
    on f.PaymentMethodKey = dpm.PaymentMethodKey;




-- Add the PaperlessBilling column to DimCustomer if it does not exist.
if col_length('DimCustomer', 'PaperlessBilling') is null
begin
    alter table DimCustomer
    add PaperlessBilling nvarchar(10);
end;
go

-- Update PaperlessBilling values using the source data.
update dc
set dc.PaperlessBilling = src.PaperlessBilling
from DimCustomer as dc
inner join data_after_py as src
    on dc.customerID = src.customerID;
