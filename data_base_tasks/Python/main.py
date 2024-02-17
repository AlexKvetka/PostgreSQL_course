import psycopg2
from config import host, user, password, db_name
from faker import Faker
import random
import re
import matplotlib.pyplot as plt
import numpy as np
from matplotlib.collections import LineCollection

"Выводы по графикам:"
"""Из графика вывод: чем больше индекс тарифа, тем больше он приносит прибыли."""
"""Из графика вывод: Библиотека faker успешно справилась с рандомной генерацией данных 
т.к. слишком непредсказуемая зависимомть зарплаты от возраста"""


base_client_insert_string = '''INSERT INTO bs.Client(FirstName, LastName, FathersName, Sex, Bithday, Telephone, Email, PassportSeries, PassportNumber, AddressCountry, AddressCIty, AddressStreet, AddressBuilding, AdrsressHouse, AddressApartment, Salary, RateId, BankUseExperience, RateUseExperience, Taxpayerld, MartialStatus, PrisonYears, CumulativeCollateral, OtherCumulativeDebts, HigherEducation, SecondaryEducation) VALUES\n'''

def GetDataExample():
    """Извлечение данных (один из интеллектуальных скриптов):
    --подсчитать минимальную, среднюю, максимальную зарплаты,
    -- и разница зарплаты сотрудника с средней по должности
    --Упорядочить по убыванию разницы."""
    try:
        connection = psycopg2.connect(
            host=host,
            user=user,
            password=password,
            database=db_name
        )
        connection.autocommit = True
        with connection.cursor() as cursor:
            cursor.execute(
            """SELECT FirstName, LastName, post,
    MIN(salary) OVER (PARTITION BY post) as min_salary,
    round(AVG(salary) OVER (PARTITION BY post), 2) as avg_salary,
    MAX(salary) OVER (PARTITION BY post) as max_salary,
    salary,
    salary - round(AVG(salary) OVER (PARTITION BY post ORDER BY salary), 2) as diff_avg
    FROM bs.Employee
    ORDER BY diff_avg DESC"""
        )
            print(f'Server version: {cursor.fetchone()}')

    except Exception as e:
        print("[INFO]  ERROR")
    finally:
        if connection:
            connection.close()
            print("[INFO] CLOSE")

def GenerateInsertString(fake):
    """Возвращает одного случайно сгенерированного клиента"""
    first_name = fake.first_name()
    last_name = fake.last_name()
    fathers_name = fake.first_name_male()
    sex = random.choice(['Male', 'Female'])
    birthday = fake.date_of_birth(minimum_age=18, maximum_age=65)
    telephone = fake.phone_number()
    telephone = str(telephone)[:len(telephone) - 5]
    email = fake.email()[5:]
    passport_series = fake.random_int(min=1000, max=9999)
    passport_number = fake.random_int(min=100000, max=999999)
    address_country = fake.country().replace("'", '')
    if (len(address_country) >= 15):
        address_country = address_country[:15]
    address_city = fake.city()
    address_street = fake.street_address()[:15]
    address_building = fake.building_number()
    address_house = fake.building_number()
    address_apartment = fake.random_int(min=1, max=100)
    salary = fake.random_int(min=10000, max=100000)
    rate_id = fake.random_int(min=1, max=9)
    bank_use_experience = fake.random_int(min=1, max=10)
    rate_use_experience = fake.random_int(min=1, max=10)
    taxpayer_id = fake.ssn()
    martial_status = random.choice(['Married', 'Single', 'Divorced', 'Widowed'])
    prison_years = fake.random_int(min=0, max=20)
    cumulative_collateral = fake.random_int(min=0, max=1000000)
    other_cumulative_debts = fake.random_int(min=0, max=1000000)
    higher_education = random.choice([1, 0])
    secondary_education = random.choice([1, 0])
    return f'''('{first_name}', '{last_name}', '{fathers_name}', '{sex}', TIMESTAMP '{birthday}', '{telephone}', '{email}', '{passport_series}', {passport_number}, '{address_country}', '{address_city}', '{address_street}', {address_building}, {address_house}, {address_apartment},{salary}, {rate_id}, {bank_use_experience}, {rate_use_experience}, '{taxpayer_id}', '{martial_status}', {prison_years}, {cumulative_collateral}, {other_cumulative_debts}, {higher_education}, {secondary_education}),\n'''

def GenereteClientInsertToFile(number_of_inserts):
    """Возвразает список размера number_of_inserts состоящий из случайно сгенерированных клиентов"""
    global base_client_insert_string
    fake = Faker()
    fake_clients = []
    for i in range(number_of_inserts):
        fake_clients.append(GenerateInsertString(fake))
    return fake_clients

def InsertDataExample(fake_clients):
    """Пример вставки данных в таблицу bs.Client.
    SQL код для вставки также записывается и в файл"""
    try:
        connection = psycopg2.connect(
            host=host,
            user=user,
            password=password,
            database=db_name
        )
        connection.autocommit = True
        with connection.cursor() as cursor:
            client_insert10 = base_client_insert_string
            with open("python_faker_inserts.sql", 'w') as f:
                f.write('')

            counter = 1
            mod = 10
            for elem in fake_clients:
                if counter % mod == 0:
                    request = re.sub(',$', ';', client_insert10)
                    with open("python_faker_inserts.sql", 'a') as f:
                        f.write(request)

                    cursor.execute(request)
                    client_insert10 = base_client_insert_string

                client_insert10 += elem
                counter += 1

            if (counter - 1) % mod != 0:
                request = re.sub(',$', ';', client_insert10)
                with open("python_faker_inserts.sql", 'a') as f:
                    f.write(request)

                cursor.execute(request)

    except Exception as e:
        print("[INFO]  ERROR")
    finally:
        if connection:
            connection.close()
            print("[INFO] CLOSE")




def RateProfitPlot():
    """Строит График Прибыли полученной по каждому тарифу, а именно запрос:
    --Получить Прибыль за 30 дней по используемым тарифам отсортировав по RateId"""
    try:
        connection = psycopg2.connect(
            host=host,
            user=user,
            password=password,
            database=db_name
        )
        connection.autocommit = True

        with connection.cursor() as cursor:
            cursor.execute("""
    SELECT r.RateId, COUNT(*) * r.payment30 AS Profit
    FROM bs.Rate r JOIN bs.Client cl ON r.RateId = cl.RateId
    GROUP BY r.RateId
    ORDER BY RateId""")
            rateid = []
            profit = []
            for e in cursor:
                rateid.append(e[0])
                profit.append(e[1])


            plt.style.use('dark_background')
            lwidths = rateid[:-1]
            points = np.array([rateid, profit]).T.reshape(-1, 1, 2)
            segments = np.concatenate([points[:-1], points[1:]], axis=1)
            lc = LineCollection(segments, linewidths=lwidths, color='blue')
            fig, a = plt.subplots()
            a.add_collection(lc)
            a.set_xlabel('RateId')
            a.set_ylabel('Profit')
            a.plot(rateid, profit, 'g')
            plt.savefig("RateProfitPlot")
            #plt.show()
            """Из графика вывод: чем больше индекс тарифа, тем больше он приносит прибыли."""

    except Exception as e:
        print("[INFO]  ERROR")
    finally:
        if connection:
            connection.close()
            print("[INFO] CLOSE")

def AgeSalaryPlot():
    """Строит график Зарплаты в зависимости от Возраста"""
    try:
        connection = psycopg2.connect(
            host=host,
            user=user,
            password=password,
            database=db_name
        )
        connection.autocommit = True
        with connection.cursor() as cursor:
            cursor.execute("""SELECT EXTRACT(YEAR FROM NOW()) - EXTRACT(YEAR FROM BithDay) as Age, 
Salary 
FROM bs.Client
GROUP BY Age, Salary
ORDER BY Age""")
            age = []
            salary = []
            for e in cursor:
                age.append(e[0])
                salary.append(e[1])

            plt.style.use('dark_background')

            fig, ax = plt.subplots()
            ax.set_xlabel('Age')
            ax.set_ylabel('Salary')
            plt.plot(age, salary, 'go', alpha=0.8, label='Age(Salary)')
            plt.savefig("AgeSalaryPlot")
            #plt.plot()

            """Из графика вывод: Библиотека faker успешно справилась с рандомной генерацией данных"""
    except Exception as e:
        print("[INFO]  ERROR")
    finally:
        if connection:
            connection.close()
            print("[INFO] CLOSE")

def main():
    # RateProfitPlot()
    # AgeSalaryPlot()
    GetDataExample()
    #InsertDataExample(GenereteClientInsertToFile(103)) # number of generated and inserted fake people

main()





