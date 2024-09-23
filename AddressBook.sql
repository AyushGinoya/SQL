CREATE TABLE Country (
    CountryID INT IDENTITY(1,1) PRIMARY KEY,  
    CountryName VARCHAR(100) UNIQUE,         
    CountryCode VARCHAR(50),                  
    CreationDate DATETIME DEFAULT GETDATE()  
);


INSERT INTO Country (CountryName, CountryCode) 
VALUES 
('India',91 ),
('United States',85 ),
('Canada',88 ),
('United Kingdom',75 ),
('Germany', 76),
('France',100),
('Australia', 102),
('Japan',125 ),
('Brazil',145 ),
('South Africa', 455);

SELECT * FROM country;



CREATE TABLE State (
    StateID INT IDENTITY(1,1) PRIMARY KEY,       
    StateName VARCHAR(100) NOT NULL UNIQUE,       
    StateCode VARCHAR(50),                        
    CountryID INT NOT NULL,                
    CreationDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_Country FOREIGN KEY (CountryID) REFERENCES Country(CountryID)
);


INSERT INTO State (StateName, StateCode, CountryID)
VALUES 
('California', 'CA', 1),
('Texas', 'TX', 1),
('Bavaria', 'BY', 2),
('Queensland', 'QLD', 3),
('Maharashtra', 'MH', 4);


	CREATE TABLE City (
    CityID INT IDENTITY(1,1) PRIMARY KEY,
    CityName VARCHAR(100) NOT NULL UNIQUE,
    PinCode VARCHAR(50),
    STDCode VARCHAR(6),
    StateID INT NOT NULL,
    CreationDate DATETIME NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_State FOREIGN KEY (StateID) REFERENCES State(StateID)
);


INSERT INTO City (CityName, PinCode, STDCode, StateID)
VALUES 
('Los Angeles', '90001', '213', 1),
('Houston', '77001', '713', 2),
('Munich', '80331', '89', 3),
('Brisbane', '4000', '07', 4),
('Mumbai', '400001', '022', 5);


CREATE TABLE ContactCategory (
    ContactCategoryID INT IDENTITY(1,1) PRIMARY KEY,
    ContactCategoryName VARCHAR(255) NOT NULL,
    CreationDate DATETIME NOT NULL DEFAULT GETDATE()
);


CREATE TABLE Contact (
    ContactID INT IDENTITY(1,1) PRIMARY KEY,
    ContactCategoryID INT NOT NULL,
    CountryID INT NOT NULL,
    StateID INT NOT NULL,
    CityID INT NOT NULL,
    Name VARCHAR(100) NOT NULL,
    Gender VARCHAR(50) NOT NULL,
    MobileNo1 VARCHAR(250) NOT NULL,
    WhatsAppNo VARCHAR(50),
    Email VARCHAR(250) NOT NULL,
    Age INT,
    Address VARCHAR(500) NOT NULL,
    FacebookID VARCHAR(500),
    LinkedID VARCHAR(500),
    BirthDate DATETIME,
    BloodGroup VARCHAR(50),
    CONSTRAINT FK_ContactCategory FOREIGN KEY (ContactCategoryID) REFERENCES ContactCategory(ContactCategoryID),
    CONSTRAINT FK_ContactCountry FOREIGN KEY (CountryID) REFERENCES Country(CountryID),
    CONSTRAINT FK_ContactState FOREIGN KEY (StateID) REFERENCES State(StateID),
    CONSTRAINT FK_ContactCity FOREIGN KEY (CityID) REFERENCES City(CityID)
);



INSERT INTO ContactCategory (ContactCategoryName) 
VALUES 
('Family'),
('Friends'),
('Work'),
('Acquaintances'),
('Emergency Contacts'),
('Neighbors'),
('Others');


INSERT INTO Contact (
    ContactCategoryID, CountryID, StateID, CityID, Name, Gender, MobileNo1, WhatsAppNo, Email, Age, Address, FacebookID, LinkedID, BirthDate, BloodGroup
) VALUES 
(1, 1, 1, 1, 'John Doe', 'Male', '9876543210', '9876543210', 'john.doe@example.com', 30, '123 Elm St', NULL, NULL, '1980-01-01', 'A+'),
(2, 1, 1, 1, 'Jane Smith', 'Female', '1234567890', '1234567890', 'jane.smith@example.com', 25, '456 Oak St', 'facebook.com/jane.smith', NULL, '1995-02-02', 'B+'),
(3, 1, 1, 1, 'Michael Johnson', 'Male', '2345678901', '2345678901', 'michael.johnson@example.com', 35, '789 Pine St', 'facebook.com/m.johnson', 'linkedin.com/mjohnson', '1985-03-03', 'O-'),
(4, 2, 3, 4, 'Emily Turner', 'Female', '3456789012', '3456789012', 'emily.turner@example.com', 28, '101 Maple Ave', 'facebook.com/emily.turner', 'linkedin.com/eturner', '1992-04-04', 'AB+'),
(5, 2, 3, 4, 'David Lee', 'Male', '4567890123', '4567890123', 'david.lee@example.com', 40, '202 Birch Lane', NULL, NULL, '1980-05-05', 'A-'),
(6, 1, 2, 3, 'Linda Brown', 'Female', '5678901234', '5678901234', 'linda.brown@example.com', 32, '303 Cedar Rd', 'facebook.com/l.brown', 'linkedin.com/lindabrown', '1988-06-06', 'B-'),
(7, 3, 4, 5, 'Robert King', 'Male', '6789012345', '6789012345', 'robert.king@example.com', 27, '404 Oak Dr', NULL, NULL, '1993-07-07', 'O+');

select * from Contact