--Добавить работника
INSERT INTO bs.Employee(FirstName, LastName, FathersName, Sex, Birthday, Telephone, Email, PassportSeries, PassportNumber, AddressCountry, AddressCity, AddressStreet, AdrsressHouse, Salary, Post, BankWorkExperience, PostWorkExperience, Alive) 
VALUES
('Alex', 'Kvetka', 'Apostalovich', 'Male', '1990-01-01 00:00:00', '53244567890', 'postkvetka@gmail.com', 'AB', 1234567890, 'USA', 'New York', 'Broadway', 1, 50000, 'Manager', 5, 3, 1);

--Добавить клиента
INSERT INTO bs.Client(FirstName, LastName, FathersName, Sex, Bithday, Telephone, Email, PassportSeries, PassportNumber, AddressCountry, AddressCIty, AddressStreet, AddressBuilding, AdrsressHouse, AddressApartment, Salary, RateId, BankUseExperience, RateUseExperience, Taxpayerld, MartialStatus, PrisonYears, CumulativeCollateral, OtherCumulativeDebts, HigherEducation, SecondaryEducation)
VALUES
('Alex', 'Kvetka', 'AnotherOne', 'Male', TIMESTAMP '1991-01-01 00:00:00', '12345447890', 'jota@email.com', 'AA', 123456, 'USA', 'New York', 'Main St.', 123, 1, 101, 50000, 1, 5, 3, '1234567890', 'Married', 0, 100000, 5000, 1, 1);


-- Меняет имя клиента по id = 31
UPDATE bs.Client SET FirstName = 'Aleksei' WHERE ClientId = 31;

-- Меняет тариф для клиента с зарплатой ниже 70000 base_currency на самый дешёвый.
UPDATE bs.Client SET RateId = 1 WHERE Salary <= 70000;

-- Меняем Id банков на числа случайное число от 1 до 10
UPDATE bs.cashmachine SET BankId = floor(random() * 11)::int;

-- Удаляем всех у кого страна не USA
DELETE FROM bs.Client WHERE AddressCountry != 'USA';

--Удаляем всех у кого Фамиия Taylor
DELETE FROM bs.Client WHERE LastName = 'Taylor';

-- Получить список Женатых(Замужних) людей с зарплатой больше 50000
SELECT FirstName, LastName, Email FROM bs.Client WHERE salary > 50000 and MartialStatus = Married


-- Получить список использующих банк больше 3 лет и конкретный тариф больше 2 отсортировав.
SELECT FirstName, LastName, BankUseExperience, Telephone
FROM bs.Client 
WHERE BankUseExperience > 3 and RateUseExperience > 2
ORDER BY BankUseExperience DESC
