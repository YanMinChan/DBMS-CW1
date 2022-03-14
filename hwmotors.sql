CREATE DATABASE hwmotors;
USE hwmotors;
DROP TABLE IF EXISTS Bookings; 
CREATE TABLE IF NOT EXISTS Bookings (	
	bookingID int(10) NOT NULL PRIMARY KEY AUTO_INCREMENT, 
	startDate date NOT NULL, 
	endDate date NOT NULL, 
	basePrice decimal(7, 2) NOT NULL,
	inExt char(1) NOT NULL CHECK(inExt IN ('Y','N')), 
	discount decimal(7, 2),
	billedAmt decimal(7, 2) NOT NULL,
	bookingStat char(1) NOT NULL CHECK(bookingStat IN ('C', 'P', 'D')),
/*FK*/
	vecRegNum char(8) NOT NULL,
	cusID int(10) NOT NULL,
	pickUpLocID int(6) NOT NULL,
	returnLocID int(6) NOT NULL,
	priceType char(1) NOT NULL CHECK(priceType IN ('P', 'L'))
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Customers; 
CREATE TABLE IF NOT EXISTS Customers (
	cusID int(10) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	lastName varchar(100) NOT NULL,
	firstName varchar(100) NOT NULL,
	licenseNum char(16) NOT NULL,
	dateOfBirth date NOT NULL,
	address varchar(250) NOT NULL,
	mobileNum char(11) NOT NULL,
	email varchar(256) NOT NULL,
	creditCard int(16) NOT NULL,
/*FK*/
	mainDrivID int(10)
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Vehicles; 
CREATE TABLE IF NOT EXISTS Vehicles (	
	vecRegNum char(8) NOT NULL PRIMARY KEY,
	photo blob NOT NULL, *
	ageLim int(2) NOT NULL,
	vecType varchar(30) NOT NULL, 
	numOfSeats int(2) NOT NULL, 
	engSize varchar(30) NOT NULL, 
	transType char(1) NOT NULL CHECK(transType in ('A','M')), 
	vecStat char(1) NOT NULL CHECK(vecStat in ('A', 'R', 'S')), 
	basePrice decimal(7, 2) NOT NULL,
/*FK*/
	baseID int(6) NOT NULL,
	currentLocID int(6) NOT NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS Services; 
CREATE TABLE IF NOT EXISTS Services (	
	servID int(6) NOT NULL PRIMARY KEY AUTO_INCREMENT, 
	startDate date NOT NULL, 
	endDate date NOT NULL,
	servDes varchar(100) NOT NULL, 
	cost decimal(7,2) NOT NULL, 
/*FK*/
	vecRegNum char(8) NOT NULL
) ENGINE=InnoDB;

DROP TABLE IF EXISTS SeasonPrices; 
CREATE TABLE IF NOT EXISTS SeasonPrices (
	priceType char(1) NOT NULL PRIMARY KEY CHECK (priceType IN ('P', 'L')),	
	startDate date NOT NULL, *
	endDate date NOT NULL, *
/*NOT SURE*/
	multiplier decimal(2, 2) NOT NULL *
) ENGINE=InnoDB; 

DROP TABLE IF EXISTS Locations; 
CREATE TABLE IF NOT EXISTS Locations(
	locationID int(6) NOT NULL PRIMARY KEY AUTO_INCREMENT,
	address varchar(250) NOT NULL,
	mobileNum char(11) NOT NULL
) ENGINE=InnoDB;

ALTER TABLE Bookings ADD CONSTRAINT FK_bookings_vecRegNum FOREIGN KEY (vecRegNum) REFERENCES Vehicles(vecRegNum);
ALTER TABLE Bookings ADD CONSTRAINT FK_bookings_cusID FOREIGN KEY (cusID) REFERENCES Customers(cusID);
ALTER TABLE Bookings ADD CONSTRAINT FK_bookings_pickUpLocID FOREIGN KEY (pickUpLocID) REFERENCES Locations(locationID);
ALTER TABLE Bookings ADD CONSTRAINT FK_bookings_returnLocID FOREIGN KEY (returnLocID) REFERENCES Locations(locationID);
ALTER TABLE Bookings ADD CONSTRAINT FK_bookings_priceType FOREIGN KEY (priceType) REFERENCES SeasonPrices(priceType);

ALTER TABLE Customers ADD CONSTRAINT FK_customers_mainDrivID FOREIGN KEY (mainDrivID) REFERENCES Customers(cusID);

ALTER TABLE Vehicles ADD CONSTRAINT FK_vehicles_base FOREIGN KEY (baseID) REFERENCES Locations(locationID);
ALTER TABLE vehicles ADD CONSTRAINT FK_vehicles_currentLoc FOREIGN KEY (currentLocID) REFERENCES Locations(locationID);

ALTER TABLE Services ADD CONSTRAINT FK_services_vecRegNum FOREIGN KEY (vecRegNum) REFERENCES Vehicles(vecRegNum);

create index IX_cusID on bookings(cusID);
create index IX_pickUpLocID on bookings(pickUpLocID);
create index IX_mainDrivID on customers(mainDrivID);
create index IX_currentLocID on vehicles(currentLocID);
create index IX_baseID on vehicles(baseID);
