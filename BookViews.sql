use mklyu126;

/**
 * Shows Users ID and their read history
 */
CREATE VIEW Books_Users_Read AS
SELECT u.Email, u.NickName ,b.Title, rb.DateRead
FROM USER u
JOIN READBOOK rb 
	ON u.Email = rb.Email
JOIN BOOK b
	ON b.BookID = rb.BookID

/**
 * Shows Authors and Books they have written
 */
CREATE VIEW Books_BY_Multiple_AUTHORS AS
SELECT a.FirstName, a.LastName, b.Title, b.`Year` 
FROM BOOKAUTHOR ba 
JOIN AUTHOR a
	ON a.AuthorID = ba.AuthorID
JOIN BOOK b
	ON b.BookID = ba.BookID 
ORDER BY b.Title ASC

/*
 * Sees books and ratings
 */
CREATE VIEW Users_Book_NumRaters AS
SELECT rb.BookID, rb.Email, b.Title, rb.Rating,b.NumRaters 
FROM READBOOK rb
JOIN BOOK b
ON rb.BookID = b.BookID 


-- Triggers for delete users and delete all READBOOK data
CREATE TRIGGER before_user_delete
BEFORE DELETE ON USER
FOR EACH ROW
DELETE FROM READBOOK WHERE Email = OLD.Email

-- Trigger to ensure books cannot be deleted
CREATE TRIGGER prevent_book_deletion_before_delete
BEFORE DELETE ON BOOK 
FOR EACH ROW 
BEGIN 
	SIGNAL SQLSTATE '45000' 
SET MESSAGE_TEXT = 'Books cannot be deleted';
END;

-- Trigger to ensure dateAdded cannot be modified, also sets DateAdded to be on current timestamp upon creation of a new user
CREATE TRIGGER set_dateadded_prevent_update_before_insert
BEFORE INSERT ON USER 
FOR EACH ROW 
BEGIN 
	IF NEW.DateAdded IS NULL THEN 
		SET NEW.DateAdded = CURRENT_TIMESTAMP;
	END IF;
	
	IF NEW.DateAdded <> CURRENT_TIMESTAMP THEN
		SIGNAL SQLSTATE '45000'
		SET MESSAGE_TEXT = 'Modification of DateAdded column is not allowed';
	END IF;
END;



-- Triggers to update NumRaters when users rate a book during INSERT
CREATE TRIGGER update_numRaters_count_after_insert
AFTER INSERT ON READBOOK
FOR EACH ROW
UPDATE BOOK
SET NumRaters = NumRaters + 1,
Rating = (SELECT AVG(Rating) FROM READBOOK WHERE READBOOK.BookID = NEW.BookID)
WHERE BookID = NEW.BookID;

-- Triggers to update NumRaters when users rate a book during REMOVE
CREATE TRIGGER update_numRaters_count_after_DELETE
AFTER DELETE ON READBOOK
FOR EACH ROW
UPDATE BOOK
SET NumRaters = NumRaters - 1,
Rating = (SELECT AVG(Rating) FROM READBOOK WHERE READBOOK.BookID = OLD.BookID)
WHERE BookID = OLD.BookID;



/**
 * This is where the test is 
 */

-- Test to see what happends if we delete a user
DELETE FROM USER 
WHERE USER.Email = 'user2@example.com'

-- Test to see what happens if we delete a book
DELETE FROM BOOK
WHERE BOOK.Title = '1984'

-- Attempt to add invalid user
INSERT INTO USER (Email, DateAdded, NickName, Profile)
VALUES('invalid@gmail.com', '2023-01-01 12:00:00', 'Mike', 'InvalidProfile');

-- Attempt to change primary key in USER
UPDATE USER
SET Email= 'test@gmail.com'
WHERE NickName = 'johndoe'

-- Attempt to add a book with multiple authors



-- Test to see what happened to rating and NumRaters when we add a user
INSERT INTO READBOOK (BookID, Email, DateRead, Rating) VALUES
(4, 'user6@example.com', '2021-03-15', 2)

-- Views the Ratings
SELECT *
FROM BOOK b 





    
-- Triggers for Preventing Books to be deleted
-- CREATE TRIGGER after_book_delete
-- AFTER DELETE ON BOOK
-- FOR EACH ROW
-- INSERT INTO BOOK (Title, Year, NumRaters, Rating) VALUES (OLD.Title, OLD.Year, OLD.NumRaters, OLD.Rating);





