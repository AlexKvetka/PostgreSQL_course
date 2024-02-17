from faker import Faker
import random

fake = Faker()

def generate_data():
    first_name = fake.first_name()
    last_name = fake.last_name()
    fathers_name = fake.first_name_male()
    sex = random.choice(['Male', 'Female'])
    birthday = fake.date_of_birth(minimum_age=18, maximum_age=65)
    telephone = fake.phone_number()
    email = fake.email()
    passport_series = fake.random_int(min=1000, max=9999)
    passport_number = fake.random_int(min=100000, max=999999)
    address_country = fake.country()
    address_city = fake.city()
    address_street = fake.street_address()
    address_building = fake.building_number()
    address_house = fake.secondary_address()
    address_apartment = fake.random_int(min=1, max=100)
    salary = fake.random_int(min=10000, max=100000)
    rate_id = fake.random_int(min=1, max=10)
    bank_use_experience = fake.random_int(min=1, max=10)
    rate_use_experience = fake.random_int(min=1, max=10)
    taxpayer_id = fake.ssn()
    martial_status = random.choice(['Married', 'Single', 'Divorced', 'Widowed'])
    prison_years = fake.random_int(min=0, max=20)
    cumulative_collateral = fake.random_int(min=0, max=1000000)
    other_cumulative_debts = fake.random_int(min=0, max=1000000)
    higher_education = random.choice([True, False])
    secondary_education = random.choice([True, False])

    return (first_name, last_name, fathers_name, sex, birthday,
            telephone, email, passport_series, passport_number,
            address_country, address_city, address_street,
            address_building, address_house, address_apartment,
            salary, rate_id, bank_use_experience,
            rate_use_experience, taxpayer_id,
            martial_status, prison_years,
            cumulative_collateral,
            other_cumulative_debts,
            higher_education,
            secondary_education)


print(generate_data())