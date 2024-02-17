--сгрупировать по должности  только женщин получив среднюю зарплату 
--и оставить только тех которые выше 70000 в порядке возрастания по названию должности

SELECT Post, SUM(salary) / COUNT(salary) AS mid 
FROM bs.Employee
WHERE sex = 'Female'
GROUP BY Post
HAVING SUM(salary) / COUNT(salary) > 70000
ORDER BY post DESC




--подсчитать минимальную, среднюю, максимальную зарплаты, и разница зарплаты сотрудника с средней по должности
--Упорядочить по убыванию разницы.
SELECT FirstName, LastName, post,
MIN(salary) OVER (PARTITION BY post) as min_salary,
round(AVG(salary) OVER (PARTITION BY post), 2) as avg_salary,
MAX(salary) OVER (PARTITION BY post) as max_salary,
salary,
salary - round(AVG(salary) OVER (PARTITION BY post ORDER BY salary), 2) as diff_avg
FROM bs.Employee
ORDER BY diff_avg DESC


--Считает кол-во приёмов у каждого сотрудника
SELECT e.EmployeeId, e.FirstName, COALESCE(count, 0) AS count
FROM bs.Employee e
LEFT JOIN (
			SELECT EmployeeId, COUNT(*) as count 
			FROM bs.CustomerService 
			GROUP BY EmployeeId
		  ) cs ON cs.EmployeeId = e.EmployeeId
		  
ORDER BY EmployeeId ASC


--Другой Способ: Считает кол-во приёмов у каждого сотрудникаТоже самое
SELECT bs.Employee.EmployeeId, COUNT(bs.CustomerService.EmployeeId) 
FROM bs.Employee 
LEFT JOIN bs.CustomerService ON Employee.EmployeeId = bs.CustomerService.EmployeeId 
GROUP BY Employee.EmployeeId
ORDER BY EmployeeId ASC


--Считает Число банкоматов у каждого банка
SELECT bs.Bank.BankId, COUNT(bs.CashMachine.BankId) 
FROM bs.Bank 
LEFT JOIN bs.CashMachine ON Bank.BankId = bs.CashMachine.BankId 
GROUP BY Bank.BankId
ORDER BY BankId ASC


--Получить Прибыль за 30 дней по используемым тарифам 
--у людей с зарплатой больше 50000, отсортировав по RateId
SELECT r.RateId, round(AVG(cl.salary), 2) AS avg_salary,
COUNT(*) * r.payment30 AS Profit
FROM bs.Rate r JOIN bs.Client cl ON r.RateId = cl.RateId
GROUP BY r.RateId
HAVING AVG(cl.salary) > 50000
ORDER BY RateId


-- Считает Среднюю зарплату и номер строки в окне и выводит первые 20 в списке
SELECT FirstName, LastName, post,
round(AVG(salary) OVER (PARTITION BY post), 2) AS avg_salary,
ROW_NUMBER() OVER (PARTITION BY post ORDER BY salary) AS order_salary
FROM bs.Employee
LIMIT 20


-- Считает Среднюю зарплату, выводит имя и опыт работы самого высокооплачивоемого сотрудника по отделу,
-- Присваеваем каждой строке ранг в соответствии с зарплатой, разбивает на группы по 3 и выводит первые 20 в списке
SELECT FirstName, LastName, post,
round(AVG(salary) OVER (PARTITION BY post), 2) AS avg_salary,
salary,
FIRST_VALUE(FirstName || ' ' || bankworkexperience)
OVER(PARTITION BY sex ORDER BY salary DESC),
RANK() OVER (PARTITION BY post ORDER BY salary) AS sal_rank,
DENSE_RANK() OVER (PARTITION BY post ORDER BY salary) AS dens_rank,
NTILE(3) OVER (PARTITION BY post ORDER BY salary) AS groups_post
FROM bs.Employee
LIMIT 20
