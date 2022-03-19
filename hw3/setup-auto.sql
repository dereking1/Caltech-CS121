DROP TABLE IF EXISTS owns;
DROP TABLE IF EXISTS participated;
DROP TABLE IF EXISTS accident;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS car;

-- Represents data for drivers with each driver's driver_id, name, and address
CREATE TABLE person (
    driver_id CHAR(10) NOT NULL,
    name VARCHAR(15) NOT NULL,
    address VARCHAR(400) NOT NULL,
    PRIMARY KEY (driver_id)
);

-- Represents data for cars with each car's license number, model, and year
CREATE TABLE car (
    license CHAR(7) NOT NULL,
    -- eg. Lamborghini, can be NULL (eg. car model unknown)
    model VARCHAR(10),
    -- Year car was manufactured
    -- eg. 2020
    `year` YEAR,
    PRIMARY KEY (license)
);

-- Represents data for car accidents
-- with each accident's report number, date of accident, location, and summary.
CREATE TABLE accident (
    report_number INT NOT NULL AUTO_INCREMENT,
    -- Stores both date and time accident occured
    -- eg. 2015-04-28 04:12:34
    date_occured DATETIME NOT NULL,
    -- An address or intersection
    -- eg. 1200 East California Boulevard
    location VARCHAR(400) NOT NULL,
    summary VARCHAR(10000),
    PRIMARY KEY (report_number)
);

-- Represents data for drivers and their cars owned,
-- with driver_id and license number of car.
CREATE TABLE owns(
    driver_id CHAR(10) NOT NULL,
    license CHAR(7) NOT NULL,
    PRIMARY KEY (driver_id, license),
    FOREIGN KEY (driver_id) REFERENCES person(driver_id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (license) REFERENCES car(license)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);

-- Represents data for drivers and cars involved in accidents,
-- and damage amount for each accident.
CREATE TABLE participated (
    driver_id CHAR(10) NOT NULL,
    license CHAR(7) NOT NULL,
    report_number INT NOT NULL AUTO_INCREMENT,
    -- Monetary value of damage amount, can be NULL.
    damage_amount NUMERIC(12, 2),
    PRIMARY KEY (driver_id, license, report_number),
    FOREIGN KEY (driver_id) REFERENCES person(driver_id)
	    ON UPDATE CASCADE,
	FOREIGN KEY (license) REFERENCES car(license)
        ON UPDATE CASCADE,
	FOREIGN KEY (report_number) REFERENCES accident(report_number)
        ON UPDATE CASCADE
);