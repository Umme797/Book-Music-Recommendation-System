CREATE DATABASE LiteralMelodies;
USE LiteralMelodies;

-- Create Genres table
CREATE TABLE Genres (
    genre_id INT PRIMARY KEY,
    name VARCHAR(255),
    description TEXT
);

-- Create Authors table
CREATE TABLE Authors (
    author_id INT PRIMARY KEY,
    name VARCHAR(255),
    birth_year VARCHAR(50),
    nationality VARCHAR(255)
);

-- Create Books table
CREATE TABLE Books (
    book_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255),
    author_id INT,
    genre_id INT,
    publication_year INT,
    description TEXT,
    FOREIGN KEY (author_id) REFERENCES Authors(author_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);

-- Create Musicians table
CREATE TABLE Musicians (
    artist_id INT PRIMARY KEY,
    band_name VARCHAR(255)
);

-- Create Music table
CREATE TABLE Music (
    music_id INT PRIMARY KEY,
    title VARCHAR(255),
    artist_id INT,
    genre_id INT,
    release_year INT,
    duration VARCHAR(10),
    FOREIGN KEY (artist_id) REFERENCES Musicians(artist_id),
    FOREIGN KEY (genre_id) REFERENCES Genres(genre_id)
);

-- Create Book_Music_Recommendations table
CREATE TABLE Book_Music_Recommendations (
    recommendation_id INT PRIMARY KEY,
    book_id INT,
    music_id INT,
    recommendation_strength INT,
    FOREIGN KEY (book_id) REFERENCES Books(book_id),
    FOREIGN KEY (music_id) REFERENCES Music(music_id)
);



-- insert some values into Genre
INSERT INTO Genres VALUES
(100, 'Science Fiction', 'Fiction based on imagined technological advances, often exploring future scenarios'),
(101, 'Fantasy', 'Genre involving magical elements, supernatural beings, and imaginary worlds'),
(102, 'Thriller', 'Suspenseful stories with plot twists and often involving crime or danger'),
(103, 'Romance', 'Stories focusing on love and relationships'),
(104, 'Non-Fiction', 'Factual narratives or informative works');

-- insert some values into Author
INSERT INTO Authors VALUES
(301, 'John Marrs', 'October 15, 1935', 'British'),
(302, 'Naomi Novik', '30 April, 1973', 'American'),
(303, 'Riley Sager', '1974', 'American'),
(304, 'Talia Hibbert', '1995 or 1996', 'British'),
(305, 'James Clear', '1986', 'American');

-- insert some values into Books
INSERT INTO Books VALUES
(001, "The Passengers", 301, 100, 2022, "A mind-bending thriller that explores the implications of advanced AI and consciousness."),
(002, "The Last Graduate", 302, 101, 2023, "A magical academy story with a dark twist, showcasing Novik's talent for world-building."),
(003, "The House Across the Lake ", 303, 102, 2023, "A suspenseful tale of obsession, secrets, and a mysterious neighbor."),
(004, "Act Your Age, Eve Brown", 304, 103, 2022, "The heartwarming conclusion to the beloved Brown sisters series, filled with humor and love."),
(005, "Atomic Habits", 305, 104, 2018, "A practical guide to building good habits and breaking bad ones, offering a roadmap for personal growth.");

-- insert some values into Musicians
INSERT INTO Musicians VALUES
(401, 'Reading Planet, Study Session Club'),
(402, 'James Osland'),
(403, 'Blue Planet Corporation'),
(404, 'Robert J Walsh'),
(405, 'Peter John Nickalls');

-- insert some values into Music
INSERT INTO Music VALUES 
(010, 'Escaping To Fiction', 401, 100, 2023, '03:26:00'),
(020, 'Those Footnotes in the Volume of Life', 402, 101, 2023, '02:36:00'),
(030, 'Passage', 403, 102, 2022, '02:01:00'),
(040, 'Rite of Passage', 404, 103, 2010, '01:18:00'),
(050, 'A Passage in Time', 405, 104, 2016, '02:16:00');

-- insert some values into Book Music Recommendations
INSERT INTO Book_Music_Recommendations VALUES
(201, 001, 010, 8),
(202, 002, 020, 7),
(203, 003, 030, 10),
(204, 004, 040, 8),
(205, 005, 050, 9);



SELECT * FROM Genres;
SELECT * FROM Authors;
SELECT * FROM Books;
SELECT * FROM Musicians;
SELECT * FROM Music;
SELECT * FROM Book_Music_Recommendations;



-- Stored Procedure
DELIMITER //
CREATE PROCEDURE InsertBook(
    IN p_Title VARCHAR(255),
    IN p_AuthorId INT,
    IN p_GenreId INT,
    IN p_PublicationYear INT,
    IN p_Description TEXT
)
BEGIN
    INSERT INTO Books (title, author_id, genre_id, publication_year, description)
    VALUES (p_Title, p_AuthorId, p_GenreId, p_PublicationYear, p_Description);
END //
DELIMITER ;

CALL InsertBook('The New Book', 301, 100, 2024, 'A thrilling adventure awaits!');



-- Create BookLog table
CREATE TABLE BookLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    event_type VARCHAR(255),
    event_description TEXT
);


-- Trigger
DELIMITER //
CREATE TRIGGER LogBookDescriptionUpdate
AFTER UPDATE ON Books
FOR EACH ROW
BEGIN
    IF NEW.description <> OLD.description THEN
        INSERT INTO BookLog(event_type, event_description)
        VALUES (
			'Book Description Update', 
			CONCAT(
				'Book ID: ', 
				NEW.book_id, 
				', New Description: ', 
				NEW.description
			)
		);
    END IF;
END //
DELIMITER ;

SELECT * FROM Books;

UPDATE Books SET description = 'A new description' WHERE book_id = 1;