CREATE TABLE Customers (
    customerNo TEXT NOT NULL CHECK(customerNo LIKE 'C_%'),
    name TEXT NOT NULL,
    pronoun TEXT NOT NULL DEFAULT 'they',
    address TEXT NOT NULL,
    email TEXT NOT NULL CHECK(email LIKE '_%@_%._%'),
    phoneNo TEXT NOT NULL,
    PRIMARY KEY (customerNo)
);


CREATE TABLE Cars (
    licenseNo TEXT NOT NULL CHECK(licenseNo LIKE '___-___'),
    model TEXT NOT NULL,
    year INT NOT NULL CHECK (year >= 1885),
    manufacturer TEXT NOT NULL,
    travelDistance INT NOT NULL,
    PRIMARY KEY (licenseNo)
);


CREATE TABLE CarOwners (
    customerNo TEXT NOT NULL,
    licenseNo TEXT NOT NULL,
    PRIMARY KEY (customerNo, licenseNo),
    FOREIGN KEY(customerNo) REFERENCES Customers(customerNo),
    FOREIGN KEY(licenseNo) REFERENCES Cars(licenseNo)
);


CREATE TABLE Maintenances (
    maintenanceNo TEXT NOT NULL CHECK(maintenanceNo LIKE 'M_%'),
    licenseNo TEXT NOT NULL,
    startTime TIME NOT NULL,
    startDate DATE NOT NULL,
    endTime TIME NOT NULL,
    endDate DATE NOT NULL CHECK (endDate >= startDate),
    typeNo TEXT NOT NULL,
    employeeNo TEXT NOT NULL,
    PRIMARY KEY (maintenanceNo),
    FOREIGN KEY(licenseNo) REFERENCES Cars(licenseNo),
    FOREIGN KEY(employeeNo) REFERENCES Employees(employeeNo),
    FOREIGN KEY(typeNo) REFERENCES MaintenanceTypes(typeNo)
);


CREATE TABLE MaintenanceTypes (
    typeNo TEXT NOT NULL CHECK(typeNo LIKE 'MT_%'),
    description TEXT NOT NULL,
    PRIMARY KEY (typeNo)
);


CREATE TABLE Contacts(
    maintenanceNo TEXT NOT NULL,
    customerNo TEXT NOT NULL,
    PRIMARY KEY(maintenanceNo, customerNo),
    FOREIGN KEY(customerNo) REFERENCES Customers(customerNo),
    FOREIGN KEY(maintenanceNo) REFERENCES Maintenances(maintenanceNo)
);


CREATE TABLE SpareParts (
    type TEXT NOT NULL,
    unitPrice REAL NOT NULL CHECK (unitPrice >= 0),
    PRIMARY KEY (type)
);


CREATE TABLE UsedSpareParts (
    type TEXT NOT NULL,
    maintenanceNo TEXT NOT NULL,
    count INT NOT NULL CHECK (count > 0),
    PRIMARY KEY (type, maintenanceNo),
    FOREIGN KEY (type) REFERENCES SpareParts(type),
    FOREIGN KEY (maintenanceNo) REFERENCES Maintenances(maintenanceNo)
);


CREATE TABLE Bills (
    billNo TEXT NOT NULL CHECK(billNo LIKE 'B_%'),
    dueDate DATE NOT NULL CHECK(dueDate >= '1970-01-01'),
    status TEXT NOT NULL DEFAULT 'unpaid' CHECK (
        status IN (
            'unpaid',
            'unpaid, late',
            'paid',
            'cancelled',
            'in debt recovery'
        )
    ),
    total REAL NOT NULL CHECK (total > 0),
    maintenanceNo TEXT NOT NULL,
    payerNo TEXT NOT NULL,
    PRIMARY KEY (billNo),
    FOREIGN KEY (maintenanceNo) REFERENCES Maintenances(maintenanceNo),
    FOREIGN KEY (payerNo) REFERENCES Customers(customerNo)
);


CREATE TABLE Invoices (
    reference INT NOT NULL CHECK (reference > 0),
    billNo TEXT NOT NULL,
    sendingDate DATE NOT NULL CHECK (sendingDate >= '1970-01-01'),
    total REAL NOT NULL CHECK (total > 0),
    PRIMARY KEY (reference),
    FOREIGN KEY (billNo) REFERENCES Bills(billNo)
);


CREATE TABLE Employees(
    employeeNo TEXT NOT NULL CHECK(employeeNo LIKE 'E_%'),
    name TEXT NOT NULL,
    pronoun TEXT NOT NULL DEFAULT 'they',
    address TEXT NOT NULL,
    email TEXT NOT NULL CHECK(email LIKE '_%@_%._%'),
    phoneNo TEXT NOT NULL,
    PRIMARY KEY (employeeNo)
);


CREATE TABLE DaysOff(
    employeeNo TEXT NOT NULL,
    date DATE NOT NULL CHECK (date >= '1970-01-01'),
    PRIMARY KEY (employeeNo, date),
    FOREIGN KEY (employeeNo) REFERENCES Employees(employeeNo)
);


CREATE TABLE MaintenanceTypeOperations (
    typeNo INT NOT NULL,
    operationType TEXT NOT NULL,
    PRIMARY KEY (typeNo, operationType),
    FOREIGN KEY (typeNo) REFERENCES MaintenanceTypes(typeNo),
    FOREIGN KEY (operationType) REFERENCES Operations(type)
);


CREATE TABLE DeviceItems (
    number INT NOT NULL CHECK (number > 0),
    deviceType TEXT NOT NULL,
    purchaseDate DATE CHECK (purchaseDate >= '1970-01-01'),
    condition TEXT NOT NULL DEFAULT 'good' CHECK(
        condition IN (
            'good',
            'broken',
            'broken, maintenance scheduled'
        )
    ),
    PRIMARY KEY (number, deviceType),
    FOREIGN KEY (deviceType) REFERENCES Devices(type)
);


CREATE TABLE Devices (type TEXT NOT NULL, PRIMARY KEY (type));


CREATE TABLE Sessions (
    sessionNo TEXT NOT NULL,
    maintenanceNo TEXT NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    date DATE NOT NULL,
    operationType TEXT NOT NULL,
    PRIMARY KEY (sessionNo),
    FOREIGN KEY (maintenanceNo) REFERENCES Maintenances(maintenanceNo),
    FOREIGN KEY (operationType) REFERENCES Operations(type)
);


CREATE TABLE Operations (
    type TEXT NOT NULL,
    duration REAL NOT NULL CHECK (duration > 0),
    PRIMARY KEY (type)
);


CREATE TABLE DevicesUsedInOperations (
    operationType TEXT NOT NULL,
    deviceType TEXT NOT NULL,
    PRIMARY KEY (operationType, deviceType),
    FOREIGN KEY (operationType) REFERENCES Operations(type),
    FOREIGN KEY (deviceType) REFERENCES Devices(type)
);


CREATE TABLE SessionsToDeviceItems (
    sessionNo TEXT NOT NULL,
    deviceNo INT NOT NULL,
    deviceType TEXT NOT NULL,
    PRIMARY KEY (
        sessionNo,
        deviceNo,
        deviceType
    ),
    FOREIGN KEY (sessionNo) REFERENCES Sessions(sessionNo),
    FOREIGN KEY (deviceNo, deviceType) REFERENCES DeviceItems(number, deviceType)
);

CREATE INDEX CustomerIndexByNo ON Customers(customerNo);

CREATE INDEX CustomerIndexByEmail ON Customers(email);

CREATE INDEX CarIndexByLicense ON Cars(licenseNo);

CREATE INDEX CarOwnersIndexByPrimary ON CarOwners(customerNo, licenseNo);

CREATE INDEX MaintenancesIndexBy ON Maintenances(maintenanceNo);

CREATE INDEX MaintenanceTypesIndexByNo ON MaintenanceTypes(typeNo);

CREATE INDEX ContactsIndexByPrimary ON Contacts(maintenanceNo, customerNo);

CREATE INDEX SparePartsIndexByType ON SpareParts(type);

CREATE INDEX UsedSparePartsIndexByPrimary ON UsedSpareParts(type, maintenanceNo);

CREATE INDEX BillsIndexByBillNo ON Bills(billNo);

CREATE INDEX InvoicesIndexByRef ON Invoices(reference);

CREATE INDEX EmployeesIndexByNo ON Employees(employeeNo);

CREATE INDEX DaysOffIndexByPrimary ON DaysOff(employeeNo, date);

CREATE INDEX MaintenanceTypeOperationsIndexByPr ON MaintenanceTypeOperations(typeNo, operationType);

CREATE INDEX DeviceItemsIndexByPrimary ON DeviceItems(number, deviceType);

CREATE INDEX DevicesIndexByType ON Devices(type);

CREATE INDEX SessionsIndexByNo ON Sessions(sessionNo);

CREATE INDEX OperationsIndexByType ON Operations(type);

CREATE INDEX DevicesUsedInOperationsIndexByPr ON DevicesUsedInOperations(operationType, deviceType);

CREATE INDEX SessionsToDeviceItemsIndexByNo ON SessionsToDeviceItems(sessionNo, deviceNo, deviceType);

CREATE INDEX MaintenancesIndexByDate ON Maintenances(startDate);

CREATE INDEX SessionsIndexByDate ON Sessions(date);

/* Kaikki korjaamon korjattavat audot vuoden aikana*/
CREATE VIEW CarsThisYear AS
    SELECT licenseNo
    FROM Cars, Maintenances
    WHERE Cars.licenseNo = Maintenances.licenseNo
    AND Maintenances.startDate >= '2021-01-01' AND Maintenances.endDate < '2022-01-01';


/* Kaikki varatut koneet ja niiden varatut ajat*/
CREATE VIEW DeviceItemReservations AS
    SELECT SessionsToDeviceItems.deviceNo, Sessions.startTime, Sessions.endTime
    FROM Sessions, SessionsToDeviceItems
    WHERE Sessions.startTime = SessionsToDeviceItems.startingTime
    AND Session.maintenanceNo = SessionsToDeviceItems.maintenanceNo;


INSERT INTO Customers(
        customerNo,
        name,
        pronoun,
        address,
        email,
        phoneNo
    )
VALUES (
        'C123456',
        'Alpha Alfanen',
        'he',
        'Happystreet 1',
        'alphaal@outlook.com',
        '+ 358401234567'
    );


INSERT INTO Customers(
        customerNo,
        name,
        pronoun,
        address,
        email,
        phoneNo
    )
VALUES (
        'C219453',
        'Alpha Betalainen',
        'she',
        'Happystreet 2',
        'alpha.bet@outlook.com',
        '+ 358405678999'
    );


INSERT INTO Customers(
        customerNo,
        name,
        address,
        email,
        phoneNo
    )
VALUES (
        'C368102',
        'Beta Meiller',
        'Sadstreet 2',
        'beta.meil@outlook.com',
        '+358403216543'
    );


INSERT INTO Customers(
        customerNo,
        name,
        address,
        email,
        phoneNo
    )
VALUES (
        'C696969',
        'Amooz Mozes',
        'BonkJail 1',
        'Amooz@outlook.com',
        '044 696 9999'
    );


INSERT INTO Customers(
        customerNo,
        name,
        pronoun,
        address,
        email,
        phoneNo
    )
VALUES (
        'C555222',
        'Maari Talo',
        'she',
        'Boom3R street 1',
        'Maari@hotmail.com',
        '0449816734'
    );


INSERT INTO Customers(
        customerNo,
        name,
        pronoun,
        address,
        email,
        phoneNo
    )
VALUES (
        'C675312',
        'Zum Zum',
        'she',
        'Swaggerden 123',
        'ZuumZ@hotmail.com',
        '0408089090'
    );


INSERT INTO Customers(
        customerNo,
        name,
        address,
        pronoun,
        email,
        phoneNo
    )
VALUES (
        'C126666',
        'Maija Makupala',
        'Pihapolku 1',
        'she',
        'upala@gmail.com',
        '0201194910'
    );


INSERT INTO Customers(
        customerNo,
        name,
        pronoun,
        address,
        email,
        phoneNo
    )
VALUES (
        'C19128823',
        'Billy Ailich',
        'He',
        'EDgyroom 3',
        'billey@gmail.com',
        '0310976283'
    );

INSERT INTO Customers(
        customerNo,
        name,
        pronoun,
        address,
        email,
        phoneNo
    )
VALUES (
        'C07239478',
        'Taki Hei',
        'He',
        'Panikstrasse 9',
        'TH@gmail.com',
        '02329384723'
    );

INSERT INTO Customers(
        customerNo,
        name,
        pronoun,
        address,
        email,
        phoneNo
    )
VALUES (
        'C66666606',
        'Philia Or',
        'she',
        'Somstreetkek 4',
        'Philor@gmail.com',
        '04412331839'
    );




INSERT INTO Cars(
        licenseNo,
        model,
        year,
        manufacturer,
        travelDistance
    )
VALUES('ABC-123', 'Bugatti', 1975, 'Volkswagen', 34257);


INSERT INTO Cars(
        licenseNo,
        model,
        year,
        manufacturer,
        travelDistance
    )
VALUES('DEF-456', 'Pensiamo', 2013, 'Ferrari', 318087);


INSERT INTO Cars(
        licenseNo,
        model,
        year,
        manufacturer,
        travelDistance
    )
VALUES('GHI-789', 'Domani', 1978, 'Tesla', 526030);


INSERT INTO Cars(
        licenseNo,
        model,
        year,
        manufacturer,
        travelDistance
    )
VALUES('JKL-123', 'Vinci', 2014, 'Ferrari', 641461);


INSERT INTO Cars(
        licenseNo,
        model,
        year,
        manufacturer,
        travelDistance
    )
VALUES('MNO-456', 'Freddo', 1974, 'Jaguar', 367447);


INSERT INTO Cars(
        licenseNo,
        model,
        year,
        manufacturer,
        travelDistance
    )
VALUES('PQR-789', 'Bugatti', 2003, 'Ferrari', 280022);


INSERT INTO Cars(
        licenseNo,
        model,
        year,
        manufacturer,
        travelDistance
    )
VALUES('STU-123', 'Freddo', 1997, 'Ferrari', 79337);


INSERT INTO Cars(
        licenseNo,
        model,
        year,
        manufacturer,
        travelDistance
    )
VALUES('VWX-456', 'Vinci', 1993, 'Jaguar', 757126);


INSERT INTO Cars(
        licenseNo,
        model,
        year,
        manufacturer,
        travelDistance
    )
VALUES('YZÅ-789', 'Freddo', 1986, 'Jaguar', 605094);



INSERT INTO CarOwners(customerNo, licenseNo)
VALUES('C19128823', 'ABC-123');


INSERT INTO CarOwners(customerNo, licenseNo)
VALUES('C19128823', 'DEF-456');


INSERT INTO CarOwners(customerNo, licenseNo)
VALUES('C07239478', 'GHI-789');


INSERT INTO CarOwners(customerNo, licenseNo)
VALUES('C07239478', 'JKL-123');


INSERT INTO CarOwners(customerNo, licenseNo)
VALUES('C219453', 'JKL-123');


INSERT INTO CarOwners(customerNo, licenseNo)
VALUES('C07239478', 'MNO-456');


INSERT INTO CarOwners(customerNo, licenseNo)
VALUES('C66666606', 'PQR-789');


INSERT INTO CarOwners(customerNo, licenseNo)
VALUES('C126666', 'STU-123');


INSERT INTO CarOwners(customerNo, licenseNo)
VALUES('C555222', 'VWX-456');


INSERT INTO CarOwners(customerNo, licenseNo)
VALUES('C123456', 'VWX-456');


INSERT INTO CarOwners(customerNo, licenseNo)
VALUES('C126666', 'YZÅ-789');


INSERT INTO CarOwners(customerNo, licenseNo)
VALUES('C219453', 'YZÅ-789');




INSERT INTO Employees(
        employeeNo,
        name,
        pronoun,
        address,
        email,
        phoneNo
    )
VALUES (
        'E1',
        'Matti Meikäläinen',
        'they',
        'Kujatie 2',
        'mmeika@gmail.com',
        '0201294910'
    );


INSERT INTO Employees(
        employeeNo,
        name,
        pronoun,
        address,
        email,
        phoneNo
    )
VALUES (
        'E2',
        'Maija Makupala',
        'she',
        'Pihapolku 1',
        'mmmakupala@gmail.com',
        '0201194910'
    );


INSERT INTO Employees(
        employeeNo,
        name,
        pronoun,
        address,
        email,
        phoneNo
    )
VALUES (
        'E3',
        'Mustikka Piirakka',
        'she',
        'Tienviitta 8',
        'mansikkaleivos@gmail.com',
        '0211194910'
    );


INSERT INTO Employees(
        employeeNo,
        name,
        pronoun,
        address,
        email,
        phoneNo
    )
VALUES (
        'E4',
        'Tieto Kanta',
        'they',
        'Otakaari 3',
        'sql@aalto.fi',
        '0211199910'
    );



INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-08-02');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-07-20');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-01-23');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-06-02');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2021-11-06');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-04-26');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-12-17');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-01-01');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-05-28');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2021-09-12');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-11-05');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-04-25');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-01-03');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2021-02-12');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2021-10-28');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-06-14');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-04-22');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2021-09-27');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2021-08-18');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-08-15');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-03-17');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-04-21');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-06-12');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-08-17');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2021-07-28');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-11-03');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-10-27');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2021-05-09');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2021-10-10');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-12-21');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-11-21');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-06-22');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-06-15');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2021-07-09');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-01-04');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-11-15');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2021-02-10');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2020-12-16');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E1', '2022-04-12');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2020-08-11');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2020-12-22');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2022-12-04');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2021-08-19');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2021-10-03');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2022-06-11');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2021-07-25');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2021-02-20');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2020-10-02');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2020-04-24');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2021-09-16');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2022-10-25');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2021-01-28');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2020-03-05');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2020-07-19');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2021-01-08');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2020-09-10');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2022-11-05');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E2', '2021-12-22');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2021-07-28');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2022-02-25');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2022-11-08');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2021-09-26');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2020-04-09');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2022-08-18');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2022-06-23');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2020-11-25');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2021-12-04');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2022-04-18');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2021-08-08');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2021-08-24');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2021-12-07');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E3', '2021-09-04');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2020-01-01');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2022-06-09');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-04-26');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-09-01');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2022-03-26');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-08-06');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2020-04-12');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2022-10-10');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-03-25');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2020-05-22');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-01-20');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2020-06-25');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2020-03-10');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2020-04-03');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2020-10-28');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-04-01');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-03-27');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2022-12-10');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2022-11-20');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-07-01');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-10-24');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-10-06');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2022-10-13');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2020-12-21');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-03-21');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-07-18');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-05-16');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2022-08-18');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2020-10-09');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-02-18');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2021-03-02');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2022-11-12');


INSERT INTO DaysOff(employeeNo, date)
VALUES('E4', '2020-10-26');



INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT5000',
    'Regular maintenance for 5000km.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT10000',
    'Regular maintenance for 10000km.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT15000',
    'Regular maintenance for 15000km.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT20000',
    'Regular maintenance for 20000km.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT25000',
    'Regular maintenance for 25000km.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT1',
    'Oil change and oil filter replacement.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT2',
    'Seasonal tire replacement.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT3',
    'Ignition system check and repair.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT4',
    'Electrical system check and repair.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT5',
    'Windows check and repair'
);



INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT773149',
    'Regular maintenance for 5000km.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT948275',
    'Regular maintenance for 10000km.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT112288',
    'Regular maintenance for 15000km.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT881010',
    'Regular maintenance for 20000km.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT748822',
    'Regular maintenance for 25000km.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT543987',
    'Oil change and oil filter replacement.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT441179',
    'Seasonal tire replacement.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT083587',
    'Ignition system check and repair.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT058315',
    'Electrical system check and repair.'
);

INSERT INTO MaintenanceTypes(typeNo, description)
VALUES(
    'MT751700',
    'Windows check and repair'
);

INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M402871',
        'GHI-789',
        '08:00',
        '2021-05-05',
        '15:30',
        '2021-05-10',
        'MT112288',
        'E4'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M229208',
        'DEF-456',
        '09:30',
        '2022-04-06',
        '08:15',
        '2022-04-12',
        'MT543987',
        'E1'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M669847',
        'DEF-456',
        '12:15',
        '2020-08-06',
        '11:45',
        '2020-08-13',
        'MT058315',
        'E4'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M754587',
        'PQR-789',
        '12:30',
        '2022-11-12',
        '14:15',
        '2022-11-18',
        'MT112288',
        'E4'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M933832',
        'PQR-789',
        '09:15',
        '2021-01-05',
        '14:00',
        '2021-01-07',
        'MT748822',
        'E2'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M708333',
        'JKL-123',
        '14:15',
        '2022-05-01',
        '10:45',
        '2022-05-07',
        'MT112288',
        'E1'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M446745',
        'GHI-789',
        '16:15',
        '2022-11-02',
        '09:00',
        '2022-11-07',
        'MT543987',
        'E2'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M51951',
        'VWX-456',
        '16:45',
        '2021-01-15',
        '11:15',
        '2021-01-22',
        'MT083587',
        'E3'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M986321',
        'GHI-789',
        '09:00',
        '2021-08-03',
        '15:15',
        '2021-08-04',
        'MT748822',
        'E2'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M951827',
        'PQR-789',
        '11:45',
        '2022-07-08',
        '11:15',
        '2022-07-13',
        'MT748822',
        'E2'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M647688',
        'STU-123',
        '12:45',
        '2022-06-10',
        '15:30',
        '2022-06-17',
        'MT058315',
        'E4'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M196368',
        'DEF-456',
        '13:30',
        '2020-05-19',
        '13:15',
        '2020-05-26',
        'MT948275',
        'E1'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M60577',
        'ABC-123',
        '10:15',
        '2022-08-14',
        '15:30',
        '2022-08-18',
        'MT112288',
        'E3'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M746567',
        'DEF-456',
        '15:00',
        '2020-01-16',
        '11:45',
        '2020-01-17',
        'MT881010',
        'E3'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M174819',
        'GHI-789',
        '10:00',
        '2021-06-07',
        '16:15',
        '2021-06-10',
        'MT881010',
        'E1'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M096238',
        'PQR-789',
        '15:15',
        '2020-12-09',
        '14:00',
        '2020-12-16',
        'MT083587',
        'E2'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M452417',
        'DEF-456',
        '10:15',
        '2021-11-05',
        '08:00',
        '2021-11-11',
        'MT748822',
        'E2'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M842900',
        'GHI-789',
        '16:45',
        '2020-10-16',
        '15:00',
        '2020-10-20',
        'MT441179',
        'E4'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M707761',
        'DEF-456',
        '09:30',
        '2020-12-03',
        '12:30',
        '2020-12-07',
        'MT083587',
        'E3'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M837857',
        'PQR-789',
        '14:30',
        '2022-09-02',
        '08:15',
        '2022-09-07',
        'MT083587',
        'E2'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M003188',
        'GHI-789',
        '14:15',
        '2021-09-20',
        '08:00',
        '2021-09-25',
        'MT543987',
        'E1'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M165238',
        'YZÅ-789',
        '09:00',
        '2020-09-05',
        '14:45',
        '2020-09-12',
        'MT773149',
        'E4'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M119535',
        'DEF-456',
        '08:45',
        '2020-08-18',
        '08:00',
        '2020-08-20',
        'MT083587',
        'E2'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M269311',
        'VWX-456',
        '12:45',
        '2020-10-08',
        '09:00',
        '2020-10-12',
        'MT948275',
        'E3'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M68910',
        'PQR-789',
        '10:15',
        '2022-10-18',
        '12:45',
        '2022-10-20',
        'MT948275',
        'E4'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M680213',
        'STU-123',
        '11:00',
        '2022-01-04',
        '14:45',
        '2022-01-05',
        'MT083587',
        'E3'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M572315',
        'ABC-123',
        '13:30',
        '2022-11-10',
        '08:45',
        '2022-11-14',
        'MT441179',
        'E2'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M333839',
        'STU-123',
        '14:15',
        '2020-03-15',
        '16:15',
        '2020-03-16',
        'MT881010',
        'E3'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M926579',
        'GHI-789',
        '10:45',
        '2021-10-20',
        '10:45',
        '2021-10-27',
        'MT112288',
        'E4'
    );


INSERT INTO Maintenances(
        maintenanceNo,
        licenseNo,
        startTime,
        startDate,
        endTime,
        endDate,
        typeNo,
        employeeNo
    )
VALUES(
        'M786439',
        'GHI-789',
        '09:45',
        '2020-06-04',
        '16:00',
        '2020-06-06',
        'MT543987',
        'E1'
    );


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M402871', 'C66666606');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M229208', 'C219453');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M669847', 'C219453');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M669847', 'C66666606');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M754587', 'C555222');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M933832', 'C126666');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M933832', 'C219453');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M708333', 'C19128823');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M708333', 'C219453');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M446745', 'C123456');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M51951', 'C696969');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M986321', 'C219453');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M951827', 'C19128823');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M951827', 'C123456');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M647688', 'C675312');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M196368', 'C696969');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M196368', 'C66666606');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M60577', 'C555222');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M746567', 'C219453');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M174819', 'C66666606');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M174819', 'C675312');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M096238', 'C126666');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M452417', 'C675312');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M842900', 'C66666606');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M707761', 'C66666606');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M837857', 'C368102');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M003188', 'C66666606');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M003188', 'C555222');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M165238', 'C675312');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M119535', 'C19128823');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M269311', 'C07239478');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M68910', 'C368102');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M680213', 'C219453');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M572315', 'C696969');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M333839', 'C219453');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M926579', 'C675312');


INSERT INTO Contacts(maintenanceNo, customerNo)
VALUES('M786439', 'C19128823');



INSERT INTO SpareParts(type, unitPrice)
VALUES('roof', 1001.10);


INSERT INTO SpareParts(type, unitPrice)
VALUES('brakes', 91.85);


INSERT INTO SpareParts(type, unitPrice)
VALUES('window', 102.65);


INSERT INTO SpareParts(type, unitPrice)
VALUES('indicator', 24.90);


INSERT INTO SpareParts(type, unitPrice)
VALUES('wheel', 250.20);


INSERT INTO SpareParts(type, unitPrice)
VALUES('door', 670.45);


INSERT INTO SpareParts(type, unitPrice)
VALUES('headlight', 110.95);


INSERT INTO SpareParts(type, unitPrice)
VALUES('wing mirror', 230.75);


INSERT INTO SpareParts(type, unitPrice)
VALUES('windscreen', 900.99);


INSERT INTO SpareParts(type, unitPrice)
VALUES('bumbers', 55.5);


INSERT INTO SpareParts(type, unitPrice)
VALUES('seat', 110.2);


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('indicator', 'M402871', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('brakes', 'M402871', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('seat', 'M402871', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wheel', 'M229208', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('roof', 'M229208', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('seat', 'M229208', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('indicator', 'M229208', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('roof', 'M669847', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('bumbers', 'M669847', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('seat', 'M669847', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('window', 'M754587', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('headlight', 'M754587', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('headlight', 'M933832', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('seat', 'M933832', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('window', 'M933832', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wing mirror', 'M708333', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('indicator', 'M708333', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('indicator', 'M446745', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('windscreen', 'M446745', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('brakes', 'M51951', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('door', 'M51951', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('headlight', 'M986321', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('bumbers', 'M986321', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('brakes', 'M986321', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('seat', 'M951827', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wheel', 'M951827', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('bumbers', 'M951827', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('roof', 'M647688', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('door', 'M647688', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('headlight', 'M647688', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('bumbers', 'M196368', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('headlight', 'M60577', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('seat', 'M746567', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('indicator', 'M746567', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('window', 'M746567', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('seat', 'M174819', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('brakes', 'M174819', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('seat', 'M096238', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('brakes', 'M096238', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('roof', 'M096238', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('indicator', 'M452417', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('indicator', 'M842900', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('bumbers', 'M842900', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('brakes', 'M842900', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('indicator', 'M707761', '2');



INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wing mirror', 'M707761', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('roof', 'M837857', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wing mirror', 'M837857', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('headlight', 'M837857', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('seat', 'M003188', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('window', 'M003188', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wheel', 'M003188', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('window', 'M165238', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('brakes', 'M165238', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('windscreen', 'M165238', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('roof', 'M119535', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wheel', 'M119535', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wing mirror', 'M119535', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('door', 'M269311', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('roof', 'M269311', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('bumbers', 'M269311', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('window', 'M269311', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('windscreen', 'M68910', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wing mirror', 'M68910', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('roof', 'M68910', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('seat', 'M68910', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wing mirror', 'M680213', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('window', 'M680213', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wing mirror', 'M572315', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wheel', 'M572315', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('bumbers', 'M333839', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('seat', 'M333839', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wheel', 'M333839', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('brakes', 'M926579', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('window', 'M926579', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('seat', 'M926579', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('window', 'M786439', '1');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('windscreen', 'M786439', '3');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('bumbers', 'M786439', '2');


INSERT INTO UsedSpareParts(type, maintenanceNo, count)
VALUES('wheel', 'M786439', '1');



INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B492768',
        '2021-09-07',
        'unpaid, late',
        6370.49,
        'M402871',
        'C219453'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(926901, 'B492768', '2021-09-12', 6370.49);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(926902, 'B492768', '2021-09-19', 6375.49);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(926903, 'B492768', '2021-09-26', 6380.49);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(926904, 'B492768', '2021-10-03', 6385.49);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B344558',
        '2020-03-08',
        'unpaid',
        4930.37,
        'M229208',
        'C368102'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(435317, 'B344558', '2020-03-13', 4930.37);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B734522',
        '2022-11-05',
        'in debt recovery',
        1006.69,
        'M669847',
        'C07239478'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(642922, 'B734522', '2022-11-12', 1006.69);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B16974',
        '2022-08-20',
        'in debt recovery',
        7262.65,
        'M754587',
        'C07239478'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(879530, 'B16974', '2022-08-22', 7262.65);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(879531, 'B16974', '2022-08-29', 7267.65);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(879532, 'B16974', '2022-09-05', 7272.65);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(879533, 'B16974', '2022-09-12', 7277.65);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(879534, 'B16974', '2022-09-19', 7282.65);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(879535, 'B16974', '2022-09-26', 7287.65);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B159500',
        '2020-04-16',
        'cancelled',
        6291.95,
        'M933832',
        'C555222'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(989639, 'B159500', '2020-04-18', 6291.95);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B321305',
        '2020-07-20',
        'cancelled',
        4741.23,
        'M708333',
        'C66666606'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(198467, 'B321305', '2020-07-26', 4741.23);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B971522',
        '2021-02-07',
        'unpaid',
        3032.63,
        'M446745',
        'C66666606'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(766446, 'B971522', '2021-02-09', 3032.63);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B346294',
        '2020-08-16',
        'unpaid, late',
        1925.21,
        'M51951',
        'C07239478'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(519779, 'B346294', '2020-08-21', 1925.21);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(519780, 'B346294', '2020-08-28', 1930.21);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(519781, 'B346294', '2020-09-04', 1935.21);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B387746',
        '2021-06-09',
        'paid',
        3408.73,
        'M986321',
        'C555222'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(572399, 'B387746', '2021-06-11', 3408.73);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B818625',
        '2022-04-12',
        'in debt recovery',
        6552.12,
        'M951827',
        'C123456'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(445547, 'B818625', '2022-04-13', 6552.12);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(445548, 'B818625', '2022-04-20', 6557.12);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(445549, 'B818625', '2022-04-27', 6562.12);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(445550, 'B818625', '2022-05-04', 6567.12);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B457763',
        '2020-04-07',
        'paid',
        5439.86,
        'M647688',
        'C368102'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(806488, 'B457763', '2020-04-09', 5439.86);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B269303',
        '2022-04-15',
        'cancelled',
        6427.95,
        'M196368',
        'C07239478'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(132740, 'B269303', '2022-04-20', 6427.95);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B633845',
        '2022-02-05',
        'unpaid',
        4603.72,
        'M60577',
        'C66666606'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(820280, 'B633845', '2022-02-11', 4603.72);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(820281, 'B633845', '2022-02-08', 4608.72);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B632188',
        '2022-07-02',
        'unpaid, late',
        5831.96,
        'M746567',
        'C66666606'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(71115, 'B632188', '2022-07-06', 5831.96);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(71116, 'B632188', '2022-07-13', 5836.96);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(71117, 'B632188', '2022-07-20', 5841.96);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B812427',
        '2020-06-20',
        'paid',
        2358.47,
        'M174819',
        'C555222'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(258260, 'B812427', '2020-06-26', 2358.47);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B871436',
        '2022-07-10',
        'unpaid, late',
        6561.9,
        'M096238',
        'C126666'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(907131, 'B871436', '2022-07-14', 6561.9);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(907132, 'B871436', '2022-07-21', 6566.9);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B650390',
        '2022-02-02',
        'unpaid, late',
        1263.41,
        'M452417',
        'C675312'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(394701, 'B650390', '2022-02-03', 1263.41);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(394702, 'B650390', '2022-02-10', 1268.41);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B979681',
        '2020-03-14',
        'cancelled',
        7013.39,
        'M842900',
        'C675312'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(153829, 'B979681', '2020-03-20', 7013.39);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B484546',
        '2021-11-15',
        'cancelled',
        7859.47,
        'M707761',
        'C675312'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(331543, 'B484546', '2021-11-22', 7859.47);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B960773',
        '2022-09-04',
        'cancelled',
        3451.84,
        'M837857',
        'C07239478'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(888878, 'B960773', '2022-09-08', 3451.84);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B690769',
        '2020-01-07',
        'paid',
        1609.19,
        'M003188',
        'C66666606'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(353460, 'B690769', '2020-01-10', 1609.19);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(353461, 'B690769', '2020-01-17', 1614.19);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B692818',
        '2020-05-11',
        'unpaid',
        2900.11,
        'M165238',
        'C19128823'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(611724, 'B692818', '2020-05-16', 2900.11);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B396762',
        '2021-01-04',
        'unpaid',
        6383.01,
        'M119535',
        'C123456'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(250560, 'B396762', '2021-01-11', 6383.01);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B351825',
        '2020-02-09',
        'cancelled',
        5635.17,
        'M269311',
        'C66666606'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(540164, 'B351825', '2020-02-13', 5635.17);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(540165, 'B351825', '2020-02-20', 5640.17);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B625515',
        '2021-06-04',
        'paid',
        5180.17,
        'M68910',
        'C555222'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(429543, 'B625515', '2021-06-07', 5180.17);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(429544, 'B625515', '2021-0614', 5185.17);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B298912',
        '2020-09-12',
        'cancelled',
        2582.86,
        'M680213',
        'C19128823'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(880559, 'B298912', '2020-09-17', 2582.86);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B992632',
        '2022-09-06',
        'paid',
        2739.74,
        'M572315',
        'C19128823'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(651953, 'B992632', '2022-09-10', 2739.74);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(651954, 'B992632', '2022-09-17', 2744.74);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B117089',
        '2021-09-19',
        'paid',
        1676.1,
        'M333839',
        'C368102'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(995273, 'B117089', '2021-09-23', 1676.1);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B410024',
        '2022-02-19',
        'unpaid, late',
        5282.92,
        'M926579',
        'C19128823'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(195939, 'B410024', '2022-02-24', 5282.92);


INSERT INTO Bills(billNo, dueDate, status, total, maintenanceNo, payerNo)
VALUES(
        'B938510',
        '2022-07-09',
        'paid',
        728.09,
        'M786439',
        'C123456'
    );


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(768610, 'B938510', '2022-07-10', 728.09);


INSERT INTO Invoices(reference, billNo, sendingDate, total)
VALUES(768611, 'B938510', '2022-07-17', 733.09);



INSERT INTO Devices(type)
VALUES('Hydraulic Bottle Jack');


INSERT INTO Devices(type)
VALUES('Waste Oil Drainer');


INSERT INTO Devices(type)
VALUES('Tyre Changing Handle');


INSERT INTO Devices(type)
VALUES('Gravity Feed Paint Gun');


INSERT INTO Devices(type)
VALUES('Wheel Alignment System');


INSERT INTO Devices(type)
VALUES('Automotive Scissor Lift');



INSERT INTO DeviceItems(number, deviceType, purchaseDate, condition)
VALUES(
        10702,
        'Hydraulic Bottle Jack',
        '2000-02-10',
        'good'
    );


INSERT INTO DeviceItems(number, deviceType, purchaseDate, condition)
VALUES(
        80702,
        'Hydraulic Bottle Jack',
        '2009-09-10',
        'broken'
    );


INSERT INTO DeviceItems(number, deviceType, purchaseDate, condition)
VALUES(
        88702,
        'Hydraulic Bottle Jack',
        '2007-03-10',
        'good'
    );


INSERT INTO DeviceItems(number, deviceType, purchaseDate, condition)
VALUES(91379, 'Waste Oil Drainer', '2003-03-10', 'good');


INSERT INTO DeviceItems(number, deviceType, purchaseDate, condition)
VALUES(80101, 'Waste Oil Drainer', '2003-03-10', 'good');


INSERT INTO DeviceItems(number, deviceType, purchaseDate, condition)
VALUES(
        10820,
        'Tyre Changing Handle',
        '2003-03-10',
        'good'
    );


INSERT INTO DeviceItems(number, deviceType, purchaseDate, condition)
VALUES(
        10850,
        'Tyre Changing Handle',
        '2010-03-10',
        'good'
    );


INSERT INTO DeviceItems(number, deviceType, purchaseDate, condition)
VALUES(
        76666,
        'Gravity Feed Paint Gun',
        '2010-03-10',
        'good'
    );


INSERT INTO DeviceItems(number, deviceType, purchaseDate, condition)
VALUES(
        69506,
        'Gravity Feed Paint Gun',
        '2010-03-10',
        'good'
    );


INSERT INTO DeviceItems(number, deviceType, purchaseDate, condition)
VALUES(
        68868,
        'Wheel Alignment System',
        '2010-03-10',
        'good'
    );


INSERT INTO DeviceItems(number, deviceType, purchaseDate, condition)
VALUES(
        755544,
        'Automotive Scissor Lift',
        '2010-03-10',
        'good'
    );


INSERT INTO DeviceItems(number, deviceType, purchaseDate, condition)
VALUES(
        99999,
        'Automotive Scissor Lift',
        '2010-03-10',
        'good'
    );



INSERT INTO Operations(type, duration)
VALUES(
    'Check fluids',
    '0.5'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Check battery',
    '0.5'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Check tires',
    '1'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Replace tires',
    '2'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Check filters',
    '1'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Check spark plugs',
    '1'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Check belts',
    '1'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Replace windshield wipers',
    '2'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Check engine',
    '1'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Repair engine',
    '2'
);


INSERT INTO Operations(type, duration)
VALUES(
    'Fill liquid',
    '1'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Replace filter',
    '1'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Check electrical system',
    '0.5'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Repair electrical system',
    '2'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Check windows',
    '0.5'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Repair windows',
    '3'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Clean interior',
    '1'
);

INSERT INTO Operations(type, duration)
VALUES(
    'Clean exterior',
    '1'
);



INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Check tires', 'Automotive Scissor Lift');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Replace tires', 'Tyre Changing Handle');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Check filters', 'Automotive Scissor Lift');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Check filters', 'Tyre Changing Handle');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Check filters', 'Wheel Alignment System');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Check spark plugs', 'Hydraulic Bottle Jack');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Check spark plugs', 'Tyre Changing Handle');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Check spark plugs', 'Automotive Scissor Lift');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Check belts', 'Wheel Alignment System');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES(
        'Replace windshield wipers',
        'Automotive Scissor Lift'
    );


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES(
        'Replace windshield wipers',
        'Tyre Changing Handle'
    );


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Check engine', 'Waste Oil Drainer');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Check engine', 'Tyre Changing Handle');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Repair engine', 'Gravity Feed Paint Gun');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Fill liquid', 'Tyre Changing Handle');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Replace filter', 'Hydraulic Bottle Jack');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Replace filter', 'Gravity Feed Paint Gun');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Check windows', 'Waste Oil Drainer');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Check windows', 'Automotive Scissor Lift');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Check windows', 'Gravity Feed Paint Gun');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Repair windows', 'Hydraulic Bottle Jack');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Clean exterior', 'Tyre Changing Handle');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Clean exterior', 'Waste Oil Drainer');


INSERT INTO DevicesUsedInOperations(operationType, deviceType)
VALUES('Clean exterior', 'Automotive Scissor Lift');



INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT773149', 'Check filters');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT773149', 'Check battery');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT773149', 'Repair engine');

INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT948275', 'Check engine');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT948275', 'Repair electrical system');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT948275', 'Replace tires');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT948275', 'Clean interior');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT112288', 'Repair engine');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT112288', 'Check filters');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT112288', 'Fill liquid');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT112288', 'Check engine');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT112288', 'Repair electrical system');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT881010', 'Replace filter');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT881010', 'Replace tires');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT881010', 'Check fluids');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT748822', 'Check fluids');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT748822', 'Repair electrical system');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT543987', 'Clean interior');

INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT543987', 'Check spark plugs');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT543987', 'Fill liquid');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT543987', 'Repair engine');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT543987', 'Clean exterior');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT441179', 'Replace tires');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT441179', 'Check electrical system');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT083587', 'Check filters');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT083587', 'Check engine');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT083587', 'Repair windows');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT083587', 'Check tires');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT083587', 'Check electrical system');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT083587', 'Repair engine');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT083587', 'Replace windshield wipers');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT058315', 'Clean interior');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT058315', 'Replace tires');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT058315', 'Check belts');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT058315', 'Check engine');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT058315', 'Check spark plugs');

INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT058315', 'Check filters');


INSERT INTO MaintenanceTypeOperations(typeNo, operationType)
VALUES('MT751700', 'Fill liquid');



INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S5505',
        'M402871',
        '16:00',
        '17:00',
        '2021-03-03',
        'Check filters'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S5505', '80702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S683287',
        'M402871',
        '12:00',
        '15:00',
        '2021-02-19',
        'Replace tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S683287', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S683287', '10850', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S982645',
        'M402871',
        '14:00',
        '16:15',
        '2022-05-18',
        'Replace filter'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S982645', '91379', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S982645', '76666', 'Gravity Feed Paint Gun');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S982645', '10850', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S956727',
        'M402871',
        '16:15',
        '19:30',
        '2022-02-16',
        'Check tires'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S613311',
        'M402871',
        '13:45',
        '14:15',
        '2020-01-05',
        'Replace filter'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S613311', '10850', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S604621',
        'M229208',
        '09:15',
        '10:00',
        '2022-02-02',
        'Replace tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S604621', '755544', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S604621', '80101', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S895182',
        'M669847',
        '12:45',
        '13:45',
        '2021-06-11',
        'Replace windshield wipers'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S895182', '68868', 'Wheel Alignment System');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S895182', '88702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S396258',
        'M669847',
        '14:30',
        '17:30',
        '2020-08-13',
        'Check electrical system'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S396258', '80702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S55890',
        'M669847',
        '10:45',
        '11:30',
        '2021-04-13',
        'Clean interior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S55890', '10702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S55890', '91379', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S55890', '80702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S402580',
        'M669847',
        '12:45',
        '13:30',
        '2022-07-05',
        'Check tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S402580', '69506', 'Gravity Feed Paint Gun');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S372321',
        'M669847',
        '09:00',
        '10:45',
        '2022-01-14',
        'Clean exterior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S372321', '755544', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S372321', '80101', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S372321', '99999', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S885351',
        'M669847',
        '13:30',
        '15:00',
        '2020-08-06',
        'Check windows'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S885351', '80702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S885351', '10702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S485731',
        'M754587',
        '08:45',
        '09:00',
        '2021-09-17',
        'Replace windshield wipers'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S485731', '80101', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S661974',
        'M754587',
        '16:45',
        '17:30',
        '2021-02-11',
        'Check engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S661974', '80702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S661974', '10850', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S428679',
        'M754587',
        '11:45',
        '14:00',
        '2022-05-08',
        'Fill liquid'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S428679', '10820', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S696417',
        'M754587',
        '10:15',
        '12:45',
        '2021-10-19',
        'Check electrical system'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S696417', '10820', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S696417', '76666', 'Gravity Feed Paint Gun');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S696417', '10702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S959858',
        'M754587',
        '11:45',
        '14:00',
        '2020-11-14',
        'Check spark plugs'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S959858', '76666', 'Gravity Feed Paint Gun');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S126149',
        'M933832',
        '16:30',
        '19:45',
        '2021-07-18',
        'Check battery'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S126149', '10850', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S126149', '80101', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S821338',
        'M933832',
        '16:15',
        '19:15',
        '2020-05-10',
        'Replace filter'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S821338', '755544', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S821338', '76666', 'Gravity Feed Paint Gun');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S821338', '99999', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S988364',
        'M933832',
        '09:30',
        '11:45',
        '2022-06-09',
        'Check engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S988364', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S988364', '80702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S292762',
        'M933832',
        '11:15',
        '13:30',
        '2020-07-06',
        'Clean interior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S292762', '91379', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S844238',
        'M933832',
        '11:15',
        '13:30',
        '2021-04-20',
        'Check belts'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S844238', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S844238', '76666', 'Gravity Feed Paint Gun');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S844238', '69506', 'Gravity Feed Paint Gun');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S500032',
        'M708333',
        '14:00',
        '16:15',
        '2020-11-07',
        'Fill liquid'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S500032', '76666', 'Gravity Feed Paint Gun');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S626860',
        'M708333',
        '08:30',
        '09:15',
        '2021-02-06',
        'Check fluids'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S626860', '10850', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S626860', '80101', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S473702',
        'M708333',
        '15:15',
        '16:30',
        '2021-04-14',
        'Check belts'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S473702', '88702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S473702', '69506', 'Gravity Feed Paint Gun');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S473702', '755544', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S61342',
        'M708333',
        '11:00',
        '12:30',
        '2022-02-01',
        'Check filters'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S61342', '10702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S61342', '755544', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S323674',
        'M708333',
        '11:15',
        '14:30',
        '2022-10-11',
        'Check windows'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S323674', '755544', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S323674', '10820', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S323674', '10702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S860471',
        'M708333',
        '14:30',
        '17:30',
        '2022-06-05',
        'Clean exterior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S860471', '76666', 'Gravity Feed Paint Gun');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S860471', '80702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S165642',
        'M708333',
        '13:15',
        '14:15',
        '2021-01-05',
        'Replace filter'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S165642', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S165642', '88702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S165642', '80101', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S611323',
        'M446745',
        '09:45',
        '11:30',
        '2020-07-06',
        'Check engine'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S259435',
        'M446745',
        '11:15',
        '14:15',
        '2022-02-09',
        'Check fluids'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S259435', '91379', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S214541',
        'M446745',
        '13:00',
        '14:00',
        '2022-02-17',
        'Check battery'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S294689',
        'M446745',
        '12:00',
        '14:45',
        '2021-04-10',
        'Check engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S294689', '10820', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S294689', '80101', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S294689', '10850', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S719113',
        'M51951',
        '08:00',
        '11:30',
        '2022-08-15',
        'Check filters'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S393598',
        'M51951',
        '10:00',
        '12:45',
        '2022-11-12',
        'Repair electrical system'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S393598', '80702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S393598', '10702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S393598', '91379', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S164930',
        'M51951',
        '13:45',
        '15:00',
        '2021-09-06',
        'Replace tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S164930', '88702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S946449',
        'M51951',
        '13:15',
        '15:00',
        '2020-12-14',
        'Check engine'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S974917',
        'M51951',
        '11:15',
        '13:45',
        '2020-05-10',
        'Clean interior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S974917', '755544', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S974917', '10820', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S988878',
        'M51951',
        '10:45',
        '12:45',
        '2020-06-02',
        'Check tires'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S572806',
        'M51951',
        '08:15',
        '09:30',
        '2020-07-15',
        'Check belts'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S572806', '10850', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S572806', '10820', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S715423',
        'M51951',
        '09:30',
        '10:30',
        '2021-04-08',
        'Check fluids'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S715423', '10850', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S277431',
        'M986321',
        '14:15',
        '15:45',
        '2020-04-13',
        'Check battery'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S277431', '755544', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S125423',
        'M986321',
        '08:45',
        '09:15',
        '2020-02-09',
        'Check tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S125423', '10702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S868313',
        'M986321',
        '13:00',
        '14:30',
        '2022-07-04',
        'Check battery'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S868313', '68868', 'Wheel Alignment System');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S335753',
        'M986321',
        '11:15',
        '14:00',
        '2022-12-02',
        'Clean interior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S335753', '80702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S956285',
        'M986321',
        '09:30',
        '10:45',
        '2022-08-04',
        'Repair windows'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S956285', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S956285', '10820', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S879665',
        'M951827',
        '16:45',
        '18:45',
        '2022-05-07',
        'Replace windshield wipers'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S879665', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S879665', '68868', 'Wheel Alignment System');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S879665', '80101', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S617890',
        'M951827',
        '12:30',
        '14:30',
        '2021-08-16',
        'Check tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S617890', '91379', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S617890', '88702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S617890', '68868', 'Wheel Alignment System');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S331263',
        'M951827',
        '12:30',
        '14:15',
        '2020-10-11',
        'Check engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S331263', '76666', 'Gravity Feed Paint Gun');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S331263', '10702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S331263', '88702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S442841',
        'M951827',
        '16:30',
        '19:30',
        '2020-01-11',
        'Repair windows'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S442841', '69506', 'Gravity Feed Paint Gun');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S745821',
        'M647688',
        '13:00',
        '15:30',
        '2020-08-14',
        'Fill liquid'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S745821', '10850', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S745821', '755544', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S668882',
        'M647688',
        '12:30',
        '14:00',
        '2022-10-12',
        'Fill liquid'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S668882', '91379', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S668882', '10702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S981917',
        'M647688',
        '12:15',
        '14:00',
        '2020-03-06',
        'Repair electrical system'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S981917', '91379', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S466277',
        'M196368',
        '15:45',
        '17:30',
        '2020-10-08',
        'Check engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S466277', '10850', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S466277', '76666', 'Gravity Feed Paint Gun');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S501593',
        'M196368',
        '10:30',
        '13:00',
        '2020-08-01',
        'Check tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S501593', '755544', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S501593', '91379', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S501593', '69506', 'Gravity Feed Paint Gun');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S828372',
        'M60577',
        '16:00',
        '17:30',
        '2020-11-08',
        'Check electrical system'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S828372', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S828372', '88702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S348179',
        'M60577',
        '12:15',
        '15:15',
        '2022-08-18',
        'Check engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S348179', '80702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S348179', '99999', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S181027',
        'M60577',
        '14:15',
        '17:15',
        '2021-01-16',
        'Check electrical system'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S181027', '755544', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S782790',
        'M60577',
        '12:30',
        '13:00',
        '2021-10-20',
        'Check engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S782790', '80101', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S606602',
        'M60577',
        '08:00',
        '10:45',
        '2022-12-07',
        'Check spark plugs'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S606602', '80702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S606602', '80101', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S606602', '68868', 'Wheel Alignment System');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S105691',
        'M746567',
        '14:30',
        '15:00',
        '2020-01-04',
        'Fill liquid'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S105691', '755544', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S105691', '80702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S974415',
        'M746567',
        '13:30',
        '15:00',
        '2020-09-18',
        'Replace windshield wipers'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S974415', '755544', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S974415', '10702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S974415', '99999', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S446405',
        'M746567',
        '15:45',
        '18:30',
        '2021-01-03',
        'Check belts'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S85253',
        'M746567',
        '09:45',
        '12:00',
        '2022-02-07',
        'Replace windshield wipers'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S85253', '80702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S85253', '10850', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S246465',
        'M746567',
        '12:30',
        '13:00',
        '2021-03-18',
        'Check windows'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S246465', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S246465', '755544', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S246465', '91379', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S613489',
        'M746567',
        '16:15',
        '17:30',
        '2022-01-03',
        'Check electrical system'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S272167',
        'M746567',
        '14:45',
        '15:30',
        '2020-09-06',
        'Check fluids'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S272167', '10850', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S272167', '69506', 'Gravity Feed Paint Gun');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S190081',
        'M174819',
        '09:30',
        '12:45',
        '2021-03-19',
        'Check fluids'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S190081', '88702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S190081', '99999', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S78981',
        'M174819',
        '13:45',
        '14:45',
        '2022-11-10',
        'Repair engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S78981', '10820', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S78981', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S78981', '88702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S938641',
        'M174819',
        '11:45',
        '14:00',
        '2022-03-17',
        'Clean exterior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S938641', '69506', 'Gravity Feed Paint Gun');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S115361',
        'M096238',
        '09:15',
        '10:30',
        '2020-11-16',
        'Check tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S115361', '755544', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S115361', '91379', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S281470',
        'M096238',
        '11:30',
        '13:30',
        '2021-01-13',
        'Fill liquid'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S281470', '10820', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S281470', '80101', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S515192',
        'M096238',
        '10:30',
        '11:15',
        '2020-10-15',
        'Fill liquid'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S515192', '80702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S768108',
        'M452417',
        '15:30',
        '18:45',
        '2021-02-12',
        'Check engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S768108', '88702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S447004',
        'M452417',
        '13:00',
        '14:15',
        '2021-04-12',
        'Repair engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S447004', '80101', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S447004', '755544', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S555975',
        'M452417',
        '09:00',
        '11:00',
        '2021-11-03',
        'Repair electrical system'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S555975', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S555975', '69506', 'Gravity Feed Paint Gun');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S555975', '80101', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S742751',
        'M842900',
        '13:15',
        '16:15',
        '2021-12-05',
        'Check electrical system'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S742751', '80702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S742751', '91379', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S742751', '755544', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S707098',
        'M842900',
        '08:00',
        '09:15',
        '2021-07-08',
        'Check belts'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S665921',
        'M842900',
        '09:30',
        '12:00',
        '2020-06-06',
        'Check tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S665921', '755544', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S665921', '10850', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S439853',
        'M842900',
        '11:15',
        '12:15',
        '2020-02-12',
        'Check belts'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S841823',
        'M842900',
        '08:45',
        '10:30',
        '2020-12-18',
        'Clean interior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S841823', '755544', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S841823', '68868', 'Wheel Alignment System');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S841823', '10702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S554306',
        'M842900',
        '16:00',
        '19:45',
        '2020-09-12',
        'Check tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S554306', '91379', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S554306', '76666', 'Gravity Feed Paint Gun');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S987080',
        'M842900',
        '15:00',
        '17:00',
        '2020-01-13',
        'Clean exterior'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S396367',
        'M707761',
        '13:45',
        '16:15',
        '2020-01-18',
        'Repair engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S396367', '10702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S396367', '68868', 'Wheel Alignment System');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S36932',
        'M707761',
        '14:30',
        '15:15',
        '2021-06-05',
        'Check tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S36932', '10820', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S36932', '91379', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S558801',
        'M707761',
        '15:00',
        '18:45',
        '2022-11-19',
        'Replace tires'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S122141',
        'M837857',
        '12:30',
        '14:45',
        '2022-03-17',
        'Fill liquid'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S122141', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S122141', '10702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S614016',
        'M003188',
        '09:00',
        '10:45',
        '2020-02-14',
        'Clean exterior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S614016', '76666', 'Gravity Feed Paint Gun');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S614016', '755544', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S104191',
        'M003188',
        '13:15',
        '14:15',
        '2021-06-03',
        'Check spark plugs'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S104191', '755544', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S104191', '99999', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S781263',
        'M003188',
        '09:15',
        '11:15',
        '2022-10-11',
        'Repair electrical system'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S781263', '80702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S781263', '10702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S884709',
        'M165238',
        '13:15',
        '15:45',
        '2020-05-09',
        'Check battery'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S884709', '80702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S884709', '91379', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S369501',
        'M165238',
        '16:15',
        '18:00',
        '2021-10-05',
        'Check tires'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S862952',
        'M165238',
        '08:30',
        '10:30',
        '2020-09-18',
        'Check tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S862952', '99999', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S92269',
        'M165238',
        '10:30',
        '12:30',
        '2020-10-01',
        'Replace filter'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S769238',
        'M165238',
        '15:15',
        '17:45',
        '2021-04-04',
        'Check windows'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S769238', '88702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S769238', '10702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S9166',
        'M119535',
        '16:45',
        '19:45',
        '2020-04-03',
        'Clean interior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S9166', '69506', 'Gravity Feed Paint Gun');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S9166', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S9166', '68868', 'Wheel Alignment System');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S965330',
        'M119535',
        '14:15',
        '17:45',
        '2022-10-02',
        'Replace tires'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S55826',
        'M119535',
        '16:30',
        '18:45',
        '2021-06-04',
        'Repair engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S55826', '10702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S55826', '88702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S821353',
        'M119535',
        '10:00',
        '11:45',
        '2020-09-15',
        'Replace filter'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S821353', '68868', 'Wheel Alignment System');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S361285',
        'M269311',
        '08:30',
        '10:30',
        '2020-03-14',
        'Check fluids'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S361285', '10702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S361285', '10820', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S742123',
        'M269311',
        '13:00',
        '14:00',
        '2022-11-18',
        'Replace tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S742123', '68868', 'Wheel Alignment System');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S279692',
        'M269311',
        '10:00',
        '12:15',
        '2020-08-08',
        'Replace tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S279692', '10820', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S279692', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S279692', '80101', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S68508',
        'M269311',
        '15:45',
        '18:45',
        '2021-12-20',
        'Check battery'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S68508', '99999', 'Automotive Scissor Lift');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S68508', '88702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S352829',
        'M269311',
        '11:15',
        '13:45',
        '2020-04-03',
        'Check tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S352829', '755544', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S449076',
        'M269311',
        '09:15',
        '12:30',
        '2021-01-16',
        'Check spark plugs'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S449076', '10702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S386850',
        'M269311',
        '10:15',
        '11:45',
        '2021-09-14',
        'Replace tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S386850', '76666', 'Gravity Feed Paint Gun');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S709946',
        'M269311',
        '15:00',
        '16:00',
        '2021-10-05',
        'Clean exterior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S709946', '10820', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S709946', '80101', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S435859',
        'M68910',
        '10:00',
        '12:45',
        '2022-09-07',
        'Clean exterior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S435859', '68868', 'Wheel Alignment System');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S435859', '91379', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S435859', '88702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S24137',
        'M68910',
        '15:15',
        '17:30',
        '2021-06-08',
        'Replace tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S24137', '80101', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S24137', '80702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S24137', '68868', 'Wheel Alignment System');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S108288',
        'M68910',
        '12:00',
        '13:00',
        '2021-02-09',
        'Repair engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S108288', '10702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S108288', '91379', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S521118',
        'M68910',
        '12:30',
        '15:30',
        '2022-10-13',
        'Repair electrical system'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S521118', '80101', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S521118', '68868', 'Wheel Alignment System');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S521118', '80702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S890739',
        'M68910',
        '09:30',
        '12:45',
        '2022-10-02',
        'Check tires'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S312621',
        'M68910',
        '14:45',
        '17:45',
        '2022-10-03',
        'Check filters'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S312621', '10702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S312621', '10850', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S268222',
        'M680213',
        '14:00',
        '17:00',
        '2021-02-15',
        'Check fluids'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S181370',
        'M572315',
        '08:15',
        '10:45',
        '2021-09-13',
        'Check filters'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S181370', '10820', 'Tyre Changing Handle');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S181370', '80101', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S772654',
        'M572315',
        '09:00',
        '10:45',
        '2022-12-19',
        'Clean interior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S772654', '99999', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S474652',
        'M572315',
        '10:00',
        '13:30',
        '2021-02-07',
        'Check fluids'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S474652', '68868', 'Wheel Alignment System');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S100535',
        'M333839',
        '12:30',
        '15:30',
        '2022-05-15',
        'Check engine'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S895412',
        'M333839',
        '11:30',
        '13:45',
        '2021-07-12',
        'Replace windshield wipers'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S895412', '10820', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S395302',
        'M926579',
        '15:30',
        '18:15',
        '2020-07-05',
        'Replace windshield wipers'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S395302', '80702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S984477',
        'M926579',
        '14:45',
        '17:15',
        '2021-01-10',
        'Check belts'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S984477', '88702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S984477', '10702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S817308',
        'M926579',
        '10:45',
        '13:00',
        '2022-07-11',
        'Check engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S817308', '80702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S817308', '91379', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S817308', '99999', 'Automotive Scissor Lift');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S81942',
        'M926579',
        '13:45',
        '14:30',
        '2021-07-06',
        'Replace filter'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S81942', '88702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S650569',
        'M926579',
        '15:45',
        '16:15',
        '2021-05-15',
        'Check windows'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S650569', '80101', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S650569', '10850', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S10211',
        'M926579',
        '13:30',
        '15:15',
        '2020-12-18',
        'Check fluids'
    );


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S82180',
        'M786439',
        '16:45',
        '18:00',
        '2022-05-08',
        'Check fluids'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S82180', '10850', 'Tyre Changing Handle');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S607113',
        'M786439',
        '16:30',
        '17:30',
        '2022-05-18',
        'Clean exterior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S607113', '80101', 'Waste Oil Drainer');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S726735',
        'M786439',
        '12:15',
        '13:00',
        '2021-12-13',
        'Check tires'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S726735', '68868', 'Wheel Alignment System');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S480652',
        'M786439',
        '08:45',
        '10:45',
        '2022-06-02',
        'Clean interior'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S480652', '80702', 'Hydraulic Bottle Jack');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S480652', '10702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S40955',
        'M786439',
        '16:15',
        '19:30',
        '2020-02-06',
        'Check windows'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S40955', '10702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S813790',
        'M786439',
        '12:00',
        '13:00',
        '2020-04-13',
        'Check belts'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S813790', '80101', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S813790', '88702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S153670',
        'M786439',
        '14:30',
        '17:15',
        '2022-11-05',
        'Replace filter'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S153670', '80101', 'Waste Oil Drainer');


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S153670', '80702', 'Hydraulic Bottle Jack');


INSERT INTO Sessions(
        sessionNo,
        maintenanceNo,
        startTime,
        endTime,
        date,
        operationType
    )
VALUES(
        'S21110',
        'M786439',
        '14:45',
        '16:00',
        '2020-01-18',
        'Repair engine'
    );


INSERT INTO SessionsToDeviceItems(sessionNo, deviceNo, deviceType)
VALUES('S21110', '99999', 'Automotive Scissor Lift');