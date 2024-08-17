-- PostgreSQL database dump

CREATE SCHEMA bs; -- bank system

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

SET search_path = bs, pg_catalog;
SET default_tablespace = '';
SET default_with_oids = false;

CREATE TABLE IF NOT EXISTS Bank (
	BankId  SERIAL PRIMARY KEY,
	BankName character varying(200) NOT NULL,
	WorkScheduleStart  TIMESTAMP  NOT NULL,
	WorkScheduleFinish  TIMESTAMP  NOT NULL,
	BaseCurrency  character varying(200)  NOT NULL,
	AddressCountry  character varying(200)  NOT NULL,
	AddressCity  character varying(200)  NOT NULL,
	AddressStreet  character varying(200)  NOT NULL,
	AddressBuilding  BIGINT  NOT NULL,
	AddressHouse  BIGINT  NOT NULL
);

CREATE TABLE IF NOT EXISTS Employee (
	EmployeeId  SERIAL PRIMARY KEY,
	FirstName character varying(200)  NOT NULL,
	LastName character varying(200)  NOT NULL,
	FathersName character varying(200)  NOT NULL,
	Sex VARCHAR(20)  NOT NULL,
	Birthday TIMESTAMP  NOT NULL,
	Telephone VARCHAR(20)  NOT NULL,
	Email character varying(200)  NOT NULL,
	PassportSeries VARCHAR(20) NOT NULL,
	PassportNumber BIGINT  NOT NULL,
	AddressCountry character varying(200)  NOT NULL,
	AddressCity character varying(200)  NOT NULL,
	AddressStreet character varying(200)  NOT NULL,
	AddressHouse BIGINT  NOT NULL,
	Salary BIGINT NOT NULL,
	Post character varying(200)  NOT NULL,
	BankWorkExperience SMALLINT  NOT NULL,
	PostWorkExperience SMALLINT  NOT NULL,
	Alive BIGINT  NOT NULL
);

CREATE TABLE IF NOT EXISTS Rate (
  RateId  SERIAL PRIMARY KEY,
  Payment30 BIGINT NOT NULL,
  FirstChargeMain  BIGINT NOT NULL,
  FirstChargeExtra BIGINT NOT NULL,
  AfterChargeMain  BIGINT NOT NULL,
  AfterChargeExtra BIGINT  NOT NULL,
  ChargeReissue BIGINT NOT NULL,
  ChargeEarlyReissue BIGINT  NOT NULL,
  ChargeReissueBadVariants BIGINT  NOT NULL,
  AcceptanceOpened BIGINT NOT NULL,
  AcceptanceAnother BIGINT NOT NULL
);

CREATE TABLE IF NOT EXISTS Client (
  ClientId  SERIAL PRIMARY KEY,
  FirstName character varying(200) NOT NULL,
  LastName character varying(200) NOT NULL,
  FathersName  character varying(200) NOT NULL,
  Sex  character varying(200) NOT NULL,
  Bithday  TIMESTAMP NOT NULL,
  Telephone VARCHAR(20) NOT NULL,
  Email character varying(200) NOT NULL,
  PassportSeries VARCHAR(20) NOT NULL,
  PassportNumber BIGINT NOT NULL,
  AddressCountry character varying(200) NOT NULL,
  AddressCIty  character varying(200) NOT NULL,
  AddressStreet character varying(200) NOT NULL,
  AddressBuilding  BIGINT NOT NULL,
  AdrsressHouse BIGINT NOT NULL,
  AddressApartment BIGINT NOT NULL,
  Salary BIGINT NOT NULL,
  RateId BIGINT NOT NULL,
  BankUseExperience SMALLINT NOT NULL,
  RateUseExperience SMALLINT NOT NULL,
  Taxpayerld VARCHAR(20) NOT NULL,
  MartialStatus VARCHAR(20) NOT NULL,
  PrisonYears  BIGINT  NOT NULL,
  CumulativeCollateral BIGINT  NOT NULL,
  OtherCumulativeDebts BIGINT  NOT NULL,
  HigherEducation  SMALLINT NOT NULL,
  SecondaryEducation SMALLINT  NOT NULL,
  FOREIGN KEY (RateId) REFERENCES Rate(RateId)
);


CREATE TABLE IF NOT EXISTS CustomerService (
  CustomerServiceId  SERIAL PRIMARY KEY,
  ClientId BIGINT,
  EmployeeId BIGINT,
  StartTimeService TIMESTAMP NOT NULL,
  EndTimeService TIMESTAMP NOT NULL,
  Format BIGINT NOT NULL,
  KindService  character varying(200) NOT NULL,
  LanguageService  character varying(200) NOT NULL,
  TimeCreated  TIMESTAMP NOT NULL,
  FOREIGN KEY (ClientId) REFERENCES Client(ClientId),
  FOREIGN KEY (EmployeeId) REFERENCES Employee(EmployeeId)
);


CREATE TABLE IF NOT EXISTS CashMachine (
  CashMachineId SERIAL PRIMARY KEY,
  BankId BIGINT NOT NULL,
  BankName VARCHAR(20),
  WorkScheduleStart TIMESTAMP  NOT NULL,
  WorkScheduleFinish TIMESTAMP  NOT NULL,
  AddressCountry VARCHAR(20) NOT NULL,
  AddressCity VARCHAR(20)  NOT NULL,
  AddressStreet VARCHAR(20) NOT NULL,
  AddressHouse BIGINT NOT NULL,
  BankNameCharge BIGINT NOT NULL,
  OtherBankCharge BIGINT  NOT NULL,
  BankNameChargePercentages BIGINT NOT NULL,
  OtherBankChargePercentages BIGINT NOT NULL,
  FOREIGN KEY (BankId) REFERENCES Bank(BankId)
);

