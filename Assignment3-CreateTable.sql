use mklyu126;

-- USER TABLE
DROP TABLE IF EXISTS USER;
CREATE TABLE USER (
Email VARCHAR(255) PRIMARY KEY,
DateAdded DateTime DEFAULT CURRENT_TIMESTAMP,
NickName VARCHAR(255) UNIQUE NULL,
Profile VARCHAR(255) NULL
);

-- BOOK TABLE
DROP TABLE IF EXISTS BOOK;
CREATE TABLE BOOK (
BookID INT PRIMARY KEY AUTO_INCREMENT,
Title VARCHAR(255),
Year INT(4),
NumRaters INT DEFAULT 0,
Rating DECIMAL(2, 1)
);

-- AUTHOR TABLE
DROP TABLE IF EXISTS AUTHOR;
CREATE TABLE AUTHOR(
AuthorID INT PRIMARY KEY AUTO_INCREMENT,
LastName VARCHAR(255) NULL,
FirstName VARCHAR(255),
MiddleName VARCHAR(255) NULL
);

-- BOOKAUTHOR TABLE
DROP TABLE IF EXISTS BOOKAUTHOR;
CREATE TABLE BOOKAUTHOR(
AuthorID INT,
BookID INT,
PRIMARY KEY (AuthorID, BookID),
FOREIGN KEY (AuthorID) REFERENCES AUTHOR(AuthorID),
FOREIGN KEY (BookID) REFERENCES BOOK(BookID)
);

-- READBOOK TABLE
DROP TABLE IF EXISTS READBOOK;
CREATE TABLE READBOOK(
BookID INT,
Email VARCHAR(255),
DateRead Date,
Rating INT CHECK (Rating BETWEEN 1 and 10),
PRIMARY KEY (BookID, Email),
FOREIGN KEY (BookID) REFERENCES BOOK(BookID),
FOREIGN KEY (Email) REFERENCES USER(Email)
);

-- Insert data into AUTHOR table
INSERT INTO AUTHOR (FirstName, LastName, MiddleName) VALUES
('John', 'Doe', 'A'),
('Jane', 'Smith', NULL),
('Bob', 'Johnson', 'C');

-- Insert data into BOOK table
INSERT INTO BOOK (Title, Year, NumRaters, Rating) VALUES
('The Great Gatsby', 1925, 100, 8.5),
('To Kill a Mockingbird', 1960, 150, 9.2),
('1984', 1949, 120, 7.8);

-- Insert data into BOOKAUTHOR table
INSERT INTO BOOKAUTHOR (AuthorID, BookID) VALUES
(1, 1),
(2, 2),
(3, 3);

-- Insert data into USER table
INSERT INTO USER (Email, NickName, Profile) VALUES
('john.doe@example.com', 'johndoe', 'Reader'),
('jane.smith@example.com', 'janesmith', 'Book Lover'),
('bob.johnson@example.com', 'bobjohnson', 'Author Enthusiast');

-- Insert data into READBOOK table
INSERT INTO READBOOK (BookID, Email, DateRead, Rating) VALUES
(1, 'john.doe@example.com', '2023-01-15', 8),
(2, 'jane.smith@example.com', '2023-02-20', 9),
(3, 'bob.johnson@example.com', '2023-03-10', 7);