CREATE TABLE IF NOT EXISTS SUPPLIER (
             SUPPLIERID INT NOT NULL AUTO_INCREMENT,
             `NAME` VARCHAR (255) NOT NULL,
             SHORTNAME VARCHAR (25) NOT NULL,
             EMAIL VARCHAR (50) NOT NULL,             
             PHONENUMBER VARCHAR (20) NOT NULL,
             PRIMARY KEY (`NAME`),
             UNIQUE(SUPPLIERID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS MEDICAL_ITEM (
             ITEMID INT NOT NULL AUTO_INCREMENT,
             `NAME` VARCHAR (255) NOT NULL,
             `TYPE` ENUM('Device', 'Medicine'),
             UNIT VARCHAR (50) NOT NULL,
             UNIQUE(ITEMID),
             PRIMARY KEY (`NAME`, `TYPE`)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS BENEFICIARY (
             BENEFICIARYID INT NOT NULL AUTO_INCREMENT,
             `NAME` VARCHAR (255) NOT NULL,
             SHORTNAME VARCHAR (20) NOT NULL,
             EMAIL VARCHAR (50) NOT NULL,             
             PHONENUMBER VARCHAR (20) NOT NULL,
             PRIMARY KEY (`NAME`),
             UNIQUE(BENEFICIARYID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS DONOR (
             DONORID INT NOT NULL AUTO_INCREMENT,
             ORGNAME VARCHAR (255) NOT NULL,
             ORGLINK VARCHAR (255) NOT NULL,
             EMAIL VARCHAR (50) NOT NULL,             
             PHONENUMBER VARCHAR (20) NOT NULL,
             PRIMARY KEY (ORGNAME),
             UNIQUE(DONORID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS MEDICAL_NEED (
             NEEDID INT NOT NULL AUTO_INCREMENT,
             ITEMID INT NOT NULL,
             BENEFICIARYID INT NOT NULL,
             `PERIOD` DATE NOT NULL,
             URGENCY ENUM('Normal', 'Critical', 'Urgent'),
             PRIMARY KEY (ITEMID, BENEFICIARYID, `PERIOD`),
             UNIQUE(NEEDID),
             FOREIGN KEY (ITEMID) REFERENCES MEDICAL_ITEM(ITEMID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS QUOTATION (
             QUOTATIONID INT NOT NULL AUTO_INCREMENT,
             SUPPLIERID INT NOT NULL,
             ITEMID INT NOT NULL,
             BRANDNAME VARCHAR (50) NOT NULL,
             AVAILABLEQTY INT NOT NULL DEFAULT 0,
             `EXPIRYDATE` DATE NOT NULL,
             UNITPRICE DECIMAL(15, 2) NOT NULL DEFAULT 0,
             REGULATORYINFO VARCHAR (100) NOT NULL,
             PRIMARY KEY (SUPPLIERID, ITEMID),
             UNIQUE(QUOTATIONID),
             FOREIGN KEY (SUPPLIERID) REFERENCES SUPPLIER(SUPPLIERID), 
             FOREIGN KEY (ITEMID) REFERENCES MEDICAL_ITEM(ITEMID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AID_PACKAGE (
             PACKAGEID INT NOT NULL AUTO_INCREMENT,
             NAME VARCHAR (20) NOT NULL,
             `DESCRIPTION` VARCHAR (1500) NOT NULL,
             `STATUS` ENUM('Draft', 'Published',
             	 'Awaiting Payment', 'Ordered', 'Shipped',
             	 'Received at MoH', 'Delivered'),
             PRIMARY KEY (PACKAGEID),
             UNIQUE(PACKAGEID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AID_PACKAGE_ITEM (
			 PACKAGEITEMID INT NOT NULL AUTO_INCREMENT,
             QUOTATIONID INT NOT NULL,
             NEEDID INT NOT NULL,
             PACKAGEID INT NOT NULL,
             QTY INT NOT NULL DEFAULT 0,
             TOTALAMOUNT DECIMAL(15, 2) NOT NULL DEFAULT 0,
             PRIMARY KEY (QUOTATIONID, NEEDID, PACKAGEID),
             UNIQUE(PACKAGEITEMID),
             FOREIGN KEY (QUOTATIONID) REFERENCES QUOTATION(QUOTATIONID),
             FOREIGN KEY (NEEDID) REFERENCES MEDICAL_NEED(NEEDID), 
             FOREIGN KEY (PACKAGEID) REFERENCES AID_PACKAGE(PACKAGEID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS AID_PACKAGAE_UPDATE (
             PACKAGAEUPDATEID INT NOT NULL AUTO_INCREMENT,
             PACKAGEID INT NOT NULL,
             `UPDATE` VARCHAR (1500) NOT NULL,
             `DATE`  DATETIME NOT NULL,
             PRIMARY KEY (PACKAGAEUPDATEID),
             UNIQUE(PACKAGAEUPDATEID),
             FOREIGN KEY (PACKAGEID) REFERENCES AID_PACKAGE(PACKAGEID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS PLEDGE (
             PLEDGEID INT NOT NULL AUTO_INCREMENT,
             PACKAGEID INT NOT NULL,
             DONORID INT NOT NULL,
             `STATUS` ENUM('Pledged', 'Payment Initiated', 'Payment Confirmed'),
             PRIMARY KEY (PACKAGEID, DONORID),
             UNIQUE(PLEDGEID),
             FOREIGN KEY (PACKAGEID) REFERENCES AID_PACKAGE(PACKAGEID),
             FOREIGN KEY (DONORID) REFERENCES DONOR(DONORID)
)ENGINE INNODB;

CREATE TABLE IF NOT EXISTS PLEDGE_UPDATE (
             PLEDGEUPDATEID INT NOT NULL AUTO_INCREMENT,
             PLEDGEID INT NOT NULL,
             `UPDATE` VARCHAR (1500) NOT NULL,
             `DATE`  DATETIME NOT NULL,
             PRIMARY KEY (PLEDGEUPDATEID),
             UNIQUE(PLEDGEUPDATEID),
             FOREIGN KEY (PLEDGEID) REFERENCES PLEDGE(PLEDGEID)
)ENGINE INNODB;