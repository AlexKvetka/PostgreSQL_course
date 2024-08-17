--Будем обзванивать клиентов с уточнением паспортных данных. Изменились ли они.
CREATE OR REPLACE VIEW bs.client_info 
AS
 SELECT 
 FirstName,
 LastName,
 RateId,
 concat('****', "substring"(Client.PassportSeries::text, 1, 2), '****') AS PassportSeries,
 concat('****', "substring"(Client.PassportNumber::text, 5, 8), '****') AS PassportNumber
   FROM bs.Client;

ALTER TABLE bs.Client
    OWNER TO postgres;


--Будем обзванивать клиентов с предложением изменить тариф.
CREATE OR REPLACE VIEW bs.client_call_offer_rate
AS
 SELECT
 FirstName,
 FathersName,
 RateId,
 Salary,
 concat('XX-XX-XX', (RIGHT(Client.telephone, 3))) AS Telephone

   FROM bs.Client;

ALTER TABLE bs.Client
    OWNER TO postgres;




-- Звонить клиенту предложением отправить подарок по его Адресу. Частично сверив Адрес.
CREATE OR REPLACE VIEW bs.client_call_offer_gift
AS
 SELECT
 FirstName,
 FathersName,
 RateId,
 Salary,
 concat('XX-XX-XX', (RIGHT(Client.Telephone, 3))) AS Telephone,
 concat('XXXX', (RIGHT(Client.addresscountry, 3))) AS addresscountry,
 concat('XXXX', (RIGHT(Client.addresscity, 3))) AS addresscity,
 concat('XXXXX', (RIGHT(Client.addressstreet, 5))) AS addressstreet,
 concat('XXX', (RIGHT(Client.addressbuilding::text, 1))) AS addressbuilding,
 concat('XXX', (RIGHT(Client.adrsresshouse::text, 1))) AS adrsresshouse,
 concat('XXX', (RIGHT(Client.addressapartment::text, 1))) AS addressapartment

   FROM bs.Client;

ALTER TABLE bs.Client
    OWNER TO postgres;




--Получить Прибыль за 30 дней по используемым тарифам
--у людей с зарплатой больше 50000, отсортировав по RateId

CREATE OR REPLACE VIEW bs.client_rate_profit
AS
SELECT r.RateId, round(AVG(cl.salary), 2) AS avg_salary,
COUNT(*) * r.payment30 AS Profit
FROM bs.Rate r JOIN bs.Client cl ON r.RateId = cl.RateId
GROUP BY r.RateId
HAVING AVG(cl.salary) > 50000
ORDER BY RateId


--подсчитать минимальную, среднюю, максимальную зарплаты, и разница зарплаты сотрудника с средней по должности
--Упорядочить по убыванию разницы.
CREATE OR REPLACE VIEW bs.min_middle_max_diff_salary_employee
AS
SELECT FirstName, LastName, post,
MIN(salary) OVER (PARTITION BY post) as min_salary,
round(AVG(salary) OVER (PARTITION BY post), 2) as avg_salary,
MAX(salary) OVER (PARTITION BY post) as max_salary,
salary,
salary - round(AVG(salary) OVER (PARTITION BY post ORDER BY salary), 2) as diff_avg
FROM bs.Employee
ORDER BY diff_avg DESC;

ALTER TABLE bs.Client
    OWNER TO postgres;


--Количество приемов у каждого сотрудника
CREATE OR REPLACE VIEW bs.number_receptions_employee AS
SELECT bs.Employee.EmployeeId, COUNT(bs.CustomerService.EmployeeId)
FROM bs.Employee
LEFT JOIN bs.CustomerService ON Employee.EmployeeId = bs.CustomerService.EmployeeId
GROUP BY Employee.EmployeeId
ORDER BY EmployeeId ASC;

ALTER TABLE bs.Client
    OWNER TO postgres;



--Считает Число банкоматов у каждого банка
CREATE OR REPLACE VIEW bs.number_cashmachine_banks AS
SELECT bs.Bank.BankId, COUNT(bs.CashMachine.BankId)
FROM bs.Bank
LEFT JOIN bs.CashMachine ON Bank.BankId = bs.CashMachine.BankId
GROUP BY Bank.BankId
ORDER BY BankId ASC;

ALTER TABLE bs.Client
	OWNER TO postgres;
