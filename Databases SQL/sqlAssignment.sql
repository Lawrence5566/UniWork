
DROP DATABASE IF EXISTS LGC;

CREATE DATABASE IF NOT EXISTS LGC;

USE LGC;

DROP TABLE IF EXISTS Customer;

CREATE TABLE Customer (
	Cust_Email 		VARCHAR(320) 	NOT NULL,
	F_Name 			VARCHAR(57) 	NOT NULL,
	M_Name 			VARCHAR(57),
	L_Name 			VARCHAR(57) 	NOT NULL,
	phone			VARCHAR(15)		NOT NULL,
	
	PRIMARY KEY(Cust_Email)
);

DROP TABLE IF EXISTS Address;

CREATE TABLE Address (
	Address_ID		int 			NOT NULL 
		AUTO_INCREMENT,
	Add_Line_1 		VARCHAR(120) 	NOT NULL,
	Add_Line_2 		VARCHAR(120),
	Add_Line_3 		VARCHAR(120),
	City 			VARCHAR(100) 	NOT NULL,
	Postcode 		VARCHAR(16),
	
	PRIMARY KEY (Address_ID)
);

DROP TABLE IF EXISTS Cust_Addresses;

CREATE TABLE Cust_Addresses (		#junction table
	Address_ID 		int 			NOT NULL,
	Cust_Email 		VARCHAR(320) 	NOT NULL,
	AddressType 	ENUM('billing','shipping') 	NOT NULL 	DEFAULT 'billing',
	
	PRIMARY KEY (Address_ID, Cust_Email)
);

ALTER TABLE Cust_Addresses
ADD FOREIGN KEY (Address_ID) REFERENCES Address(Address_ID)
		ON UPDATE CASCADE;
ALTER TABLE Cust_Addresses
ADD FOREIGN KEY (Cust_Email) REFERENCES Customer(Cust_Email)
		ON UPDATE CASCADE;

DROP TABLE IF EXISTS c;

CREATE TABLE Supplier (
	Supp_Email 		VARCHAR(320) 	NOT NULL,
	Supp_Name 		VARCHAR(80) 	NOT NULL,
	Supp_Address_ID int 			NOT NULL,
	
	PRIMARY KEY(Supp_Email),
	FOREIGN KEY (Supp_Address_ID) REFERENCES Address(Address_ID) 
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Customer_Order;

CREATE TABLE Customer_Order (
	Order_ID INT 
		NOT NULL
		AUTO_INCREMENT,
	Order_Date			DATE 		NOT NULL,
	Order_Status 		ENUM('received','processing','paid','complete') 	NOT NULL,
	Invoice_Date 		DATE,
	Dispach_date 		DATE,
	Cust_Email 			VARCHAR(320) 	NOT NULL	DEFAULT 1,
	
	PRIMARY KEY(Order_Id),
	FOREIGN KEY (Cust_Email) REFERENCES Customer(Cust_Email) 
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Plant;

CREATE TABLE Plant (
	Plant_ID 		INT 				NOT NULL
		AUTO_INCREMENT,
	Latin_Name 		VARCHAR(80) 		NOT NULL UNIQUE,
	Pop_Name 		VARCHAR(80) 		NOT NULL,
	Quant_In_Stock 	SMALLINT UNSIGNED 			NOT NULL,
	Category ENUM('A','B','C','D','E','F') NOT NULL,
	Spread 			VARCHAR(8),
	Height 			VARCHAR(8),
	Fol_colour 		VARCHAR(10),
	Flower_colour 	VARCHAR(10),
	Flower_Period 	VARCHAR(10),
	Aftercare 		TEXT,
	Descr 			TEXT,
	Season 			ENUM('Spring','Summer','Autumn','Winter'),
	How_Grow 		TEXT,
	
	PRIMARY KEY(Plant_ID)
);

DROP TABLE IF EXISTS Purchase_item;

CREATE TABLE Purchase_item (
	Order_ID 		INT 				NOT NULL,
	Plant_ID 		INT 				NOT NULL,
	Quantity		SMALLINT UNSIGNED 	NOT NULL	DEFAULT 1,
	
	PRIMARY KEY(Order_ID, Plant_ID),
	FOREIGN KEY(Order_ID) REFERENCES Customer_Order(Order_Id)
		ON UPDATE CASCADE,
	FOREIGN KEY(Plant_ID) REFERENCES Plant(Plant_ID)
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Prices;

CREATE TABLE Prices (
	Plant_ID 		INT 				NOT NULL,
	Price_Per_Plant DECIMAL(10,2) 		NOT NULL,
	Curr_Discount 	DECIMAL(10,2) 		DEFAULT 0,
	
	PRIMARY KEY(Plant_ID),
	FOREIGN KEY(Plant_ID) REFERENCES Plant(Plant_ID)
		ON UPDATE CASCADE
);

DROP TRIGGER IF EXISTS Check_discount_On_Insert;
DROP TRIGGER IF EXISTS Check_discount_On_Update;

DELIMITER $$
CREATE TRIGGER Check_discount_On_Insert
BEFORE INSERT ON Prices
FOR EACH ROW
BEGIN 
	IF NEW.Curr_Discount > 100 OR NEW.Curr_Discount < 0 THEN
		SET NEW.Curr_Discount = 0;
	END IF;
END $$
DELIMITER ;

DELIMITER $$
CREATE TRIGGER Check_discount_On_Update
BEFORE UPDATE ON Prices
FOR EACH ROW
BEGIN 
	IF NEW.Curr_Discount > 1 OR NEW.Curr_Discount <= 0 THEN
		SET NEW.Curr_Discount = 0;
	END IF;
END $$
DELIMITER ;

DROP TABLE IF EXISTS Purchase_Order;

CREATE TABLE Purchase_Order (
	Purch_Order_ID 		INT 			NOT NULL
		AUTO_INCREMENT,
	Order_Date	DATETIME 				NOT NULL,
	Order_Status ENUM('received','paid','complete') NOT NULL
		DEFAULT 'received',
	Payment_Date 		DATE,
	Delivery_Date 		DATE,
	Supp_Email 			VARCHAR(320) 	NOT NULL,
	
	PRIMARY KEY(Purch_Order_ID),
	FOREIGN KEY(Supp_Email) REFERENCES Supplier(Supp_Email)
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS Contract;

CREATE TABLE Contract (
	Cust_Email 			VARCHAR(320) 		NOT NULL,
	Start_Date 			DATE				NOT NULL,
	Monthly_Charge 		DECIMAL(10,2) 		NOT NULL,
	End_date 			DATE 				NOT NULL,
	
	PRIMARY KEY (Cust_Email),
	FOREIGN KEY (Cust_Email) REFERENCES Customer(Cust_Email)
		ON UPDATE CASCADE
);

DROP TABLE IF EXISTS LGC_Staff;

CREATE TABLE LGC_Staff (
	NI 					VARCHAR(13) 		NOT NULL,
	F_Name 				VARCHAR(57) 		NOT NULL,
	M_Name 				VARCHAR(57),
	L_Name 				VARCHAR(57) 		NOT NULL,
	Staff_Email 		VARCHAR(320)		NOT NULL,
	Staff_Address_ID 	INT					NOT NULL,
	
	PRIMARY KEY(NI),
	FOREIGN KEY (Staff_Address_ID) REFERENCES Address(Address_ID) 
		ON UPDATE CASCADE
);

INSERT INTO Customer (Cust_Email,F_Name,M_Name,L_Name,phone) VALUES ("consequat.nec@acmattis.edu","Ulysses","Hayley","Luna","0331 555 8344"),("mauris.blandit@magnaCrasconvallis.com","Hammett","Regina","Joseph","0984 519 5606"),("sit@aodiosemper.edu","Zahir","Eagan","Russell","0845 46 45"),("eu.dolor@aliquetlobortisnisi.co.uk","Thor","Phelan","Matthews","0800 158 1497"),("dictum.magna@PraesentluctusCurabitur.ca","Gemma","Isabelle","Jacobs","(01021) 81940");
INSERT INTO Address (Address_ID,Add_Line_1,Add_Line_2,Add_Line_3,City,Postcode) VALUES (1,"892-6030 Cursus Ave","1546 Id Street","Lanarkshire","East Kilbride","OZ4 3BN"),(2,"6452 Sed Street","9208 Ullamcorper. Road","Cumberland","Penrith","XN5 2RM"),(3,"Ap #373-2526 Cursus Av.","Ap #843-8515 Nullam Rd.","Angus","Dundee","Y6Y 6OQ"),(4,"Ap #931-2563 Porttitor St.","Ap #233-8445 Tempus Street","Caithness","Wick","H71 9BH"),(5,"8540 Elit. Road","8048 Ornare. Street","Devon","Newton Abbot","T8 3JM"),(6,"5928 Enim, Av.","5852 Nulla Road","GL","Caerphilly","DE7 3YS");
INSERT INTO Cust_Addresses(Address_ID,Cust_Email,AddressType) VALUES (1,"consequat.nec@acmattis.edu","billing"),(2,"mauris.blandit@magnaCrasconvallis.com","billing"),(3,"eu.dolor@aliquetlobortisnisi.co.uk","shipping"),(4,"sit@aodiosemper.edu","billing"),(5,"dictum.magna@PraesentluctusCurabitur.ca","shipping"),(6,"consequat.nec@acmattis.edu","shipping");
INSERT INTO Address (Add_Line_1,Add_Line_3,City,Postcode) VALUES ("P.O. Box 945, 9668 Fringilla Street","Essex","Basildon","JX2N 1QM"),("P.O. Box 753, 6007 Nostra, Street","SR","Wandsworth","K5 1PS");
INSERT INTO Supplier (Supp_Email,Supp_Name,Supp_Address_ID) VALUES ("risus@aliquamarcuAliquam.net","Ultrices Associates",7),("scelerisque.sed@justoPraesent.com","Lacus Varius Et Inc.",8);
INSERT INTO Customer_Order (Order_Date,Order_Status,Invoice_Date,Dispach_date,Cust_Email) VALUES ("2017/10/29","complete","17/09/10","2017/03/09","consequat.nec@acmattis.edu"),("2017/01/31","received","2018/06/11","2017/02/09","mauris.blandit@magnaCrasconvallis.com"),("2018/04/11","paid","2018/12/16","2018/08/18","eu.dolor@aliquetlobortisnisi.co.uk");
INSERT INTO Plant(Latin_Name,Pop_Name,Quant_In_Stock) VALUES ("Alnus glutinosa","Black alder",50),("Malus domestica","Apple",50),("Fagus","Beech",50),("Prunus serotina","Black cherry",50),("Morus","Mulberry",50);
INSERT INTO Purchase_item(Order_ID,Plant_ID) VALUES (1,2),(1,4),(1,5),(3,1),(2,3),(2,4),(2,5);
INSERT INTO Prices(Plant_ID,Price_Per_Plant) VALUES (1,3.0),(2,4.5),(3,10.0),(4,10.0),(5,10.0);
INSERT INTO Purchase_Order (Order_Date,Order_Status,Payment_Date,Delivery_Date, Supp_Email) VALUES ("2017/01/03","received", null , null, "risus@aliquamarcuAliquam.net"),("2017/02/03","paid","2017/02/05", null , "risus@aliquamarcuAliquam.net"),("2017/03/03",'complete',"2017/03/05","2017/03/06","scelerisque.sed@justoPraesent.com");
INSERT INTO Contract (Cust_Email,Start_Date,Monthly_Charge,End_date) VALUES ("consequat.nec@acmattis.edu","2018/01/01",30.0,"2019/01/01"),("mauris.blandit@magnaCrasconvallis.com","2018/01/02",30.0,"2019/01/02"),("sit@aodiosemper.edu","2018/03/02",30.0,"2019/03/02");
INSERT INTO Address (Add_Line_1,Add_Line_3,City,Postcode) VALUES ("Ap #404-8548 Integer Street","SU","Lairg","C15 2HD"),("5639 Cursus Ave","WO","Kidderminster","BN1 7VV"),("P.O. Box 651, 4652 Nec Road","Sutherland","Helmsdale","IG30 1FY"),("Ap #544-7050 Sit Rd.","Flintshire","Flint","C7O 7AF"),("P.O. Box 850, 8156 Mauris. Ave","Cardiganshire","Cardigan","JY3L 4ZB");
INSERT INTO LGC_Staff (NI,F_Name,L_Name,Staff_Email,Staff_Address_ID) VALUES ("MN057877J","Yvette","Ramirez","amet.consectetuer@risus.edu",9),("ZZ190252X","Kitra","Gordon","risus.Quisque.libero@maurissagittisplacerat.org",10),("XP241407I","Elton","Lawson","augue.Sed.molestie@Sed.com",11),("XJ649538E","Nell","Chen","Proin@atnisi.com",12),("BZ731427H","Amber","Brady","mollis.Phasellus.libero@pharetraQuisqueac.org",13);

DELETE FROM Contract #deleting someones contract
WHERE Cust_Email = "sit@aodiosemper.edu";

UPDATE Contract
SET Monthly_Charge = 35.0
WHERE Cust_Email = "consequat.nec@acmattis.edu";

UPDATE Prices p
INNER JOIN Plant pl ON p.Plant_ID = pl.Plant_ID 
SET p.Curr_Discount = 80
WHERE pl.Latin_Name = "Alnus glutinosa";

#getting addresses for all customers:
SELECT C.F_Name, L_Name, A.City, Postcode
      FROM Cust_Addresses CA
INNER JOIN Address A ON A.Address_ID = CA.Address_ID
INNER JOIN Customer C ON C.Cust_Email = CA.Cust_Email;

#getting addresses for all suppliers:
SELECT Supplier.Supp_Name, Address.Add_Line_1, Add_Line_3, City, Postcode
      FROM Supplier
RIGHT JOIN Address ON Supplier.Supp_Address_ID = Address.Address_ID;

#getting all customers, and showing if they have contracts:
SELECT Customer.F_Name,L_name, Contract.Start_Date,Monthly_Charge,End_date
      FROM Customer
LEFT JOIN Contract ON Customer.Cust_Email = Contract.Cust_Email;

#select all customers and staff and show all emails
SELECT Customer.F_Name,L_Name,Cust_Email FROM Customer
UNION
SELECT LGC_Staff.F_Name,L_Name,Staff_Email FROM LGC_Staff
ORDER BY F_Name;

#creating copys of tables:
DROP TABLE IF EXISTS copy_of_Customer;
CREATE TABLE copy_of_Customer LIKE Customer;
INSERT INTO copy_of_Customer SELECT * FROM Customer;

DROP TABLE IF EXISTS copy_of_Address;
CREATE TABLE copy_of_Address LIKE Address;
INSERT INTO copy_of_Address SELECT * FROM Address;

DROP TABLE IF EXISTS copy_of_Cust_Addresses;
CREATE TABLE copy_of_Cust_Addresses LIKE Cust_Addresses;
ALTER TABLE copy_of_Cust_Addresses
ADD FOREIGN KEY (Address_ID) REFERENCES copy_of_Address(Address_ID)
		ON UPDATE CASCADE,
ADD FOREIGN KEY (Cust_Email) REFERENCES copy_of_Customer(Cust_Email)
		ON UPDATE CASCADE;
INSERT INTO copy_of_Cust_Addresses SELECT * FROM Cust_Addresses;

DROP TABLE IF EXISTS copy_of_Supplier;
CREATE TABLE copy_of_Supplier LIKE Supplier;
ALTER TABLE copy_of_Supplier
ADD FOREIGN KEY (Supp_Address_ID) REFERENCES copy_of_Address(Address_ID);
INSERT INTO copy_of_Supplier SELECT * FROM Supplier;

DROP TABLE IF EXISTS copy_of_Customer_Order;
CREATE TABLE copy_of_Customer_Order LIKE Customer_Order;
ALTER TABLE copy_of_Customer_Order
ADD FOREIGN KEY (Cust_Email) REFERENCES copy_of_Customer(Cust_Email) 
		ON UPDATE CASCADE;
INSERT INTO copy_of_Customer_Order SELECT * FROM Customer_Order;

DROP TABLE IF EXISTS copy_of_Plant;
CREATE TABLE copy_of_Plant LIKE Plant;
INSERT INTO copy_of_Plant SELECT * FROM Plant;

DROP TABLE IF EXISTS copy_of_Purchase_item;
CREATE TABLE copy_of_Purchase_item LIKE Purchase_item;
ALTER TABLE copy_of_Purchase_item
ADD FOREIGN KEY(Order_ID) REFERENCES copy_of_Customer_Order(Order_Id)
		ON UPDATE CASCADE,
ADD FOREIGN KEY(Plant_ID) REFERENCES copy_of_Plant(Plant_ID)
		ON UPDATE CASCADE;
INSERT INTO copy_of_Purchase_item SELECT * FROM Purchase_item;

DROP TABLE IF EXISTS copy_of_Prices;
CREATE TABLE copy_of_Prices LIKE Prices;
ALTER TABLE copy_of_Prices
ADD FOREIGN KEY(Plant_ID) REFERENCES copy_of_Plant(Plant_ID)
		ON UPDATE CASCADE;
INSERT INTO copy_of_Prices SELECT * FROM Prices;

DROP TABLE IF EXISTS copy_of_Purchase_Order;
CREATE TABLE copy_of_Purchase_Order LIKE Purchase_Order;
ALTER TABLE copy_of_Purchase_Order
ADD FOREIGN KEY(Supp_Email) REFERENCES copy_of_Supplier(Supp_Email)
		ON UPDATE CASCADE;
INSERT INTO copy_of_Purchase_Order SELECT * FROM Purchase_Order;

DROP TABLE IF EXISTS copy_of_Contract;
CREATE TABLE copy_of_Contract LIKE Contract;
ALTER TABLE copy_of_Contract
ADD FOREIGN KEY (Cust_Email) REFERENCES copy_of_Customer(Cust_Email)
		ON UPDATE CASCADE;
INSERT INTO copy_of_Contract SELECT * FROM Contract;

DROP TABLE IF EXISTS copy_of_LGC_Staff;
CREATE TABLE copy_of_LGC_Staff LIKE LGC_Staff;
ALTER TABLE copy_of_LGC_Staff
ADD FOREIGN KEY (Staff_Address_ID) REFERENCES copy_of_Address(Address_ID) 
		ON UPDATE CASCADE;
INSERT INTO copy_of_LGC_Staff SELECT * FROM LGC_Staff;


#creating user in database:
DROP USER IF EXISTS 'newUser'@'localhost';
CREATE USER 'newUser'@'localhost' IDENTIFIED BY 'password'; #create user with no perms
GRANT SELECT ON LGC.* TO 'newUser'@'localhost' IDENTIFIED BY 'password'; #grant select
REVOKE DROP ON LGC.* FROM 'newUser'@'localhost';	#remove drop perms in case user has it


DROP PROCEDURE IF EXISTS delete_from_database;

#creating procedure that deletes a given customer by their email from tables
DELIMITER //
CREATE PROCEDURE delete_from_database
(IN email_to_delete VARCHAR(320))
BEGIN
	SET @address_to_delete = (
	SELECT Address_ID
	FROM Cust_Addresses
	WHERE Cust_Email = email_to_delete);
	
	DELETE FROM Cust_Addresses
	WHERE Cust_Email = email_to_delete;
	
	DELETE FROM Address
	WHERE Address_ID = @address_to_delete;
	
	DELETE FROM Contract
	WHERE Cust_Email = email_to_delete;
	
	DELETE p 
	FROM Purchase_item p
	INNER JOIN Customer_Order co ON co.Order_ID = p.Order_ID
	WHERE co.Cust_Email = email_to_delete;
	
	DELETE FROM Customer_Order
	WHERE Cust_Email = email_to_delete;
	
	DELETE FROM Customer
	WHERE Cust_Email = email_to_delete;
END //
DELIMITER ;

#example call:
CALL delete_from_database('mauris.blandit@magnaCrasconvallis.com');


