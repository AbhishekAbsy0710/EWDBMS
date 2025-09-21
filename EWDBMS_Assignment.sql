Create Database CrunchyAnime;
Use CrunchyAnime;

-- Users in 1NF
CREATE TABLE Users_1NF (
    UserID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Age INT,
    Country VARCHAR(50),
    SubscriptionType VARCHAR(50),
    SubscriptionPrice DECIMAL(5,2),
    SubscriptionDuration VARCHAR(20),
    WatchedAnime VARCHAR(255),
    WatchedGenres VARCHAR(255)
);

-- Anime in 1NF
CREATE TABLE Anime_1NF (
    AnimeID INT PRIMARY KEY,
    Title VARCHAR(100),
    ReleaseYear INT,
    Rating DECIMAL(3,1),
    Studios VARCHAR(255),
    Genres VARCHAR(255),
    VoiceActors VARCHAR(255)
);

-- Sample data (redundant, multi-valued)
INSERT INTO Users_1NF VALUES
(1, 'Alice', 'alice@mail.com', 22, 'Japan', 'Premium', 9.99, 'Monthly', 'Naruto, Attack on Titan', 'Action, Fantasy'),
(2, 'Bob', 'bob@mail.com', 30, 'USA', 'Family', 14.99, 'Monthly', 'Your Name', 'Romance, Drama');

INSERT INTO Anime_1NF VALUES
(1, 'Naruto', 2002, 8.7, 'Studio Pierrot', 'Action, Fantasy', 'Junko Takeuchi'),
(2, 'Attack on Titan', 2013, 9.2, 'Wit Studio', 'Action, Drama', 'Yuki Kaji'),
(3, 'Your Name', 2016, 8.9, 'CoMix Wave Films', 'Romance, Drama', 'Mone Kamishiraishi');

-- 1NF Problems:
-- Users repeat subscription details.
-- Multi-values stored as comma-separated lists.
-- Redundant and hard to query.

-- To Solve 1NF problem creating 2NF tables

-- Subscriptions
CREATE TABLE Subscriptions (
    SubscriptionID INT PRIMARY KEY,
    PlanName VARCHAR(50),
    Price DECIMAL(5,2),
    Duration VARCHAR(20)
);

INSERT INTO Subscriptions VALUES
(1, 'Premium', 9.99, 'Monthly'),
(2, 'Family', 14.99, 'Monthly');

-- Users (now reference subscriptions)
CREATE TABLE Users_2NF (
    UserID INT PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Age INT,
    Country VARCHAR(50),
    SubscriptionID INT,
    FOREIGN KEY (SubscriptionID) REFERENCES Subscriptions(SubscriptionID)
);

INSERT INTO Users_2NF VALUES
(1, 'Alice', 'alice@mail.com', 22, 'Japan', 1),
(2, 'Bob', 'bob@mail.com', 30, 'USA', 2);

-- Anime
CREATE TABLE Anime_2NF (
    AnimeID INT PRIMARY KEY,
    Title VARCHAR(100),
    ReleaseYear INT,
    Rating DECIMAL(3,1)
);

INSERT INTO Anime_2NF VALUES
(1, 'Naruto', 2002, 8.7),
(2, 'Attack on Titan', 2013, 9.2),
(3, 'Your Name', 2016, 8.9);

-- Genres
CREATE TABLE Genres (
    GenreID INT PRIMARY KEY,
    GenreName VARCHAR(50)
);

INSERT INTO Genres VALUES
(1, 'Action'),
(2, 'Fantasy'),
(3, 'Romance'),
(4, 'Drama');

-- Studios
CREATE TABLE Studios (
    StudioID INT PRIMARY KEY,
    StudioName VARCHAR(100),
    Country VARCHAR(50)
);

INSERT INTO Studios VALUES
(1, 'Studio Pierrot', 'Japan'),
(2, 'Wit Studio', 'Japan'),
(3, 'CoMix Wave Films', 'Japan');

-- Voice Actors
CREATE TABLE VoiceActors (
    ActorID INT PRIMARY KEY,
    ActorName VARCHAR(100),
    Nationality VARCHAR(50)
);

INSERT INTO VoiceActors VALUES
(1, 'Junko Takeuchi', 'Japan'),
(2, 'Yuki Kaji', 'Japan'),
(3, 'Mone Kamishiraishi', 'Japan');

-- Fixes 1NF problems but 2NF problems and Solutions are as mentioned below:
-- Subscription details now stored once.
-- Genres, Studios, VoiceActors are separate entities.
-- But still need junction tables for many-to-many relationships.

-- droping unwanted tables 
DROP TABLE IF EXISTS Users_1NF;
DROP TABLE IF EXISTS Anime_1NF;
DROP TABLE IF EXISTS Users_2NF;
DROP TABLE IF EXISTS Anime_2NF;
DROP TABLE IF EXISTS Subscriptions;
DROP TABLE IF EXISTS VoiceActors;
DROP TABLE IF EXISTS Studios;
DROP TABLE IF EXISTS Genres;

-- The 3nf elemated all the problems from 1nf and 2nf 
-- Subscriptions
CREATE TABLE Subscriptions (
    SubscriptionID INT PRIMARY KEY,
    PlanName VARCHAR(50) NOT NULL UNIQUE,
    Price DECIMAL(5,2) NOT NULL,
    Duration VARCHAR(20) NOT NULL
);
INSERT INTO Subscriptions VALUES
(1, 'Basic', 5.99, 'Monthly'),
(2, 'Standard', 8.99, 'Monthly'),
(3, 'Premium', 11.99, 'Monthly'),
(4, 'Family', 15.99, 'Monthly'),
(5, 'Annual Basic', 59.99, 'Yearly'),
(6, 'Annual Standard', 89.99, 'Yearly'),
(7, 'Annual Premium', 119.99, 'Yearly'),
(8, 'Annual Family', 159.99, 'Yearly'),
(9, 'Student', 4.99, 'Monthly'),
(10, 'Trial', 0.00, '7 Days');

-- Users
CREATE TABLE Users (
    UserID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Email VARCHAR(100) NOT NULL UNIQUE,
    Age INT NOT NULL,
    Country VARCHAR(50) NOT NULL,
    SubscriptionID INT NOT NULL,
    FOREIGN KEY (SubscriptionID) REFERENCES Subscriptions(SubscriptionID)
);

-- Index on Country for faster filtering by region
CREATE INDEX idx_users_country ON Users(Country);

INSERT INTO Users VALUES
(1, 'Abhi', 'abhi@mail.com', 27, 'Germany', 3),
(2, 'Bob', 'bob@mail.com', 30, 'USA', 4),
(3, 'Charlie', 'charlie@mail.com', 28, 'UK', 2),
(4, 'Diana', 'diana@mail.com', 25, 'Germany', 1),
(5, 'Ethan', 'ethan@mail.com', 35, 'Canada', 6),
(6, 'Fiona', 'fiona@mail.com', 29, 'Australia', 7),
(7, 'George', 'george@mail.com', 40, 'France', 5),
(8, 'Hana', 'hana@mail.com', 23, 'Japan', 9),
(9, 'Ivan', 'ivan@mail.com', 27, 'Russia', 2),
(10, 'Julia', 'julia@mail.com', 19, 'Brazil', 10);

-- Anime
CREATE TABLE Anime (
    AnimeID INT PRIMARY KEY,
    Title VARCHAR(100) NOT NULL UNIQUE,
    ReleaseYear INT NOT NULL,
    Rating DECIMAL(3,1) NOT NULL
);

-- Index on Rating to speed up queries like top-rated anime
CREATE INDEX idx_anime_rating ON Anime(Rating);

INSERT INTO Anime VALUES
(1, 'Naruto', 2002, 8.7),
(2, 'Attack on Titan', 2013, 9.2),
(3, 'Your Name', 2016, 8.9),
(4, 'Death Note', 2006, 9.0),
(5, 'Suzume', 2024, 7.6),
(6, 'Demon Slayer', 2019, 8.8),
(7, 'One Piece', 1999, 9.0),
(8, 'Dragon Ball Z', 1989, 8.5),
(9, 'Jujutsu Kaisen', 2020, 8.7),
(10, 'Solo Leveling', 2025, 9.6);

-- Genres
CREATE TABLE Genres (
    GenreID INT PRIMARY KEY,
    GenreName VARCHAR(50) NOT NULL UNIQUE
);

INSERT INTO Genres VALUES
(1, 'Action'),
(2, 'Fantasy'),
(3, 'Romance'),
(4, 'Drama'),
(5, 'Adventure'),
(6, 'Horror'),
(7, 'Comedy'),
(8, 'Mystery'),
(9, 'Thriller'),
(10, 'Slice of Life');

-- Anime ↔ Genres
CREATE TABLE AnimeGenre (
    AnimeID INT NOT NULL,
    GenreID INT NOT NULL,
    PRIMARY KEY (AnimeID, GenreID),
    FOREIGN KEY (AnimeID) REFERENCES Anime(AnimeID),
    FOREIGN KEY (GenreID) REFERENCES Genres(GenreID)
);

INSERT INTO AnimeGenre VALUES
(1,1),(1,2),(1,5),          -- Naruto: Action, Fantasy, Adventure
(2,1),(2,4),(2,9),          -- Attack on Titan: Action, Drama, Thriller
(3,3),(3,4),(3,10),         -- Your Name: Romance, Drama, Slice of Life
(4,1),(4,8),(4,9),          -- Death Note: Action, Mystery, Thriller
(5,3),(5,4),(5,10),         -- Suzume: Romance, Drama, Slice of Life
(6,1),(6,2),(6,5),          -- Demon Slayer: Action, Fantasy, Adventure
(7,1),(7,5),(7,7),          -- One Piece: Action, Adventure, Comedy
(8,1),(8,5),(8,7),          -- Dragon Ball Z: Action, Adventure, Comedy
(9,1),(9,2),(9,6),          -- Jujutsu Kaisen: Action, Fantasy, Horror
(10,1),(10,5),(10,4);       -- Solo Leveling: Action, Adventure, Drama

-- Studios
CREATE TABLE Studios (
    StudioID INT PRIMARY KEY,
    StudioName VARCHAR(100) NOT NULL UNIQUE,
    Country VARCHAR(50) NOT NULL
);

INSERT INTO Studios VALUES
(1, 'Studio Pierrot', 'Japan'),
(2, 'Wit Studio', 'Japan'),
(3, 'CoMix Wave Films', 'Japan'),
(4, 'Madhouse', 'Japan'),
(5, 'Bones', 'Japan'),
(6, 'Ufotable', 'Japan'),
(7, 'Toei Animation', 'Japan'),
(8, 'Toei Animation (DBZ)', 'Japan'),
(9, 'MAPPA', 'Japan'),
(10, 'Studio Ghibli', 'Japan');

-- Anime ↔ Studios
CREATE TABLE AnimeStudio (
    AnimeID INT NOT NULL,
    StudioID INT NOT NULL,
    PRIMARY KEY (AnimeID, StudioID),
    FOREIGN KEY (AnimeID) REFERENCES Anime(AnimeID),
    FOREIGN KEY (StudioID) REFERENCES Studios(StudioID)
);

INSERT INTO AnimeStudio VALUES
(1,1),(2,2),(3,3),(4,4),(5,10),
(6,6),(7,7),(8,8),(9,9),(10,5);

CREATE TABLE VoiceActors (
    ActorID INT PRIMARY KEY,
    ActorName VARCHAR(100) NOT NULL,
    Nationality VARCHAR(50) NOT NULL
);

INSERT INTO VoiceActors VALUES
(1, 'Junko Takeuchi', 'Japan'),
(2, 'Yuki Kaji', 'Japan'),
(3, 'Mone Kamishiraishi', 'Japan'),
(4, 'Mamoru Miyano', 'Japan'),
(5, 'Romi Park', 'Japan'),
(6, 'Natsuki Hanae', 'Japan'),
(7, 'Mayumi Tanaka', 'Japan'),
(8, 'Masako Nozawa', 'Japan'),
(9, 'Junya Enoki', 'Japan'),
(10, 'Rumi Hiiragi', 'Japan');

-- Anime ↔ VoiceActors
CREATE TABLE AnimeVoiceActor (
    AnimeID INT NOT NULL,
    ActorID INT NOT NULL,
    PRIMARY KEY (AnimeID, ActorID),
    FOREIGN KEY (AnimeID) REFERENCES Anime(AnimeID),
    FOREIGN KEY (ActorID) REFERENCES VoiceActors(ActorID)
);

INSERT INTO AnimeVoiceActor VALUES
(1,1),(2,2),(3,3),(4,4),(5,10),
(6,6),(7,7),(8,8),(9,9),(10,5);

-- Episodes
CREATE TABLE Episodes (
    EpisodeID INT PRIMARY KEY,
    AnimeID INT NOT NULL,
    Title VARCHAR(100) NOT NULL,
    Duration INT NOT NULL,
    ReleaseDate DATE NOT NULL,
    FOREIGN KEY (AnimeID) REFERENCES Anime(AnimeID)
);

-- Index for quick search of episodes by Anime
CREATE INDEX idx_episodes_anime ON Episodes(AnimeID);

INSERT INTO Episodes VALUES
(1,1,'Enter Naruto Uzumaki!',24,'2002-10-03'),
(2,2,'To You, in 2000 Years',24,'2013-04-07'),
(3,3,'Movie: Your Name',110,'2016-08-26'),
(4,4,'Rebirth',23,'2006-10-04'),
(5,5,'Movie: Suzume',120,'2024-11-11'),
(6,6,'Cruelty',24,'2019-04-06'),
(7,7,'I’m Luffy! The Man Who’s Gonna Be King of the Pirates!',25,'1999-10-20'),
(8,8,'The New Threat',24,'1989-04-26'),
(9,9,'Ryomen Sukuna',24,'2020-10-03'),
(10,10,'Solo Leveling Episode 1',30,'2025-02-01');

-- Reviews
CREATE TABLE Reviews (
    ReviewID INT PRIMARY KEY,
    UserID INT NOT NULL,
    AnimeID INT NOT NULL,
    Rating DECIMAL(3,1) NOT NULL,
    ReviewText TEXT,
    ReviewDate DATE NOT NULL,
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (AnimeID) REFERENCES Anime(AnimeID)
);

INSERT INTO Reviews VALUES
(1,1,1,9.0,'Legendary anime!','2021-01-01'),
(2,2,2,9.5,'Masterpiece!','2021-05-12'),
(3,3,3,8.8,'Emotional and beautiful.','2021-06-15'),
(4,4,4,9.3,'Dark and thrilling.','2021-07-10'),
(5,5,5,7.8,'Beautiful story.','2024-12-01'),
(6,6,6,8.7,'Visually stunning.','2019-09-01'),
(7,7,7,9.4,'Epic adventure.','1999-10-20'),
(8,8,8,8.5,'Classic action.','1989-05-01'),
(9,9,9,8.9,'Modern favorite.','2020-10-10'),
(10,10,10,9.6,'Ultimate leveling adventure.','2025-03-01');

-- Watch history (User ↔ Anime ↔ Episode)
CREATE TABLE WatchHistory (
    UserID INT NOT NULL,
    AnimeID INT NOT NULL,
    EpisodeID INT NOT NULL,
    WatchDate DATE NOT NULL,
    Progress DECIMAL(5,2) NOT NULL,
    PRIMARY KEY (UserID, AnimeID, EpisodeID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (AnimeID) REFERENCES Anime(AnimeID),
    FOREIGN KEY (EpisodeID) REFERENCES Episodes(EpisodeID)
);

-- Index for quickly finding recent watches
CREATE INDEX idx_watchhistory_date ON WatchHistory(WatchDate);

INSERT INTO WatchHistory VALUES
(1,1,1,'2021-02-10',100.0),
(2,2,2,'2021-06-15',100.0),
(3,3,3,'2021-06-20',100.0),
(4,4,4,'2021-07-15',90.0),
(5,5,5,'2024-12-05',80.0),
(6,6,6,'2019-09-15',100.0),
(7,7,7,'1999-10-25',100.0),
(8,8,8,'1989-05-10',95.0),
(9,9,9,'2020-10-15',100.0),
(10,10,10,'2025-02-05',100.0);

-- Charecters
CREATE TABLE Characters (
    CharacterID INT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL,
    Role VARCHAR(50) NOT NULL,
    AnimeID INT NOT NULL,
    ActorID INT NOT NULL,
    FOREIGN KEY (AnimeID) REFERENCES Anime(AnimeID),
    FOREIGN KEY (ActorID) REFERENCES VoiceActors(ActorID)
);

INSERT INTO Characters VALUES
(1,'Naruto Uzumaki','Main',1,1),
(2,'Eren Yeager','Main',2,2),
(3,'Mitsuha Miyamizu','Main',3,3),
(4,'Light Yagami','Main',4,4),
(5,'Suzume Iwato','Main',5,10),
(6,'Tanjiro Kamado','Main',6,6),
(7,'Monkey D. Luffy','Main',7,7),
(8,'Goku','Main',8,8),
(9,'Yuji Itadori','Main',9,9),
(10,'Sung Jin-Woo','Main',10,5);

-- More anime watched history for views
-- Insert NEW episodes for trend demonstration

INSERT INTO Episodes VALUES
(11,1,'Naruto Special Recap',24,'2003-03-10'),
(12,2,'Battle of Trost',24,'2013-07-01'),
(13,3,'Your Name - Bonus',15,'2016-08-12'),
(14,4,'Confrontation',24,'2007-01-05'),
(15,5,'Suzume Ending Special',10,'2024-12-20'),
(16,6,'Training Arc',24,'2020-11-18'),
(17,7,'Alabasta Arc Start',24,'2000-12-25'),
(18,8,'Frieza Saga',24,'1990-01-10'),
(19,9,'Cursed Training',24,'2021-02-14'),
(20,10,'Solo Leveling Episode 2',30,'2025-04-01');

INSERT INTO WatchHistory VALUES
(1,1,11,'2021-03-10',100.0),
(2,2,12,'2021-07-01',95.0),
(3,3,13,'2021-08-12',100.0),
(4,4,14,'2022-01-05',80.0),
(5,5,15,'2024-12-20',100.0),
(6,6,16,'2020-11-18',100.0),
(7,7,17,'2000-12-25',100.0),
(8,8,18,'1990-01-10',90.0),
(9,9,19,'2021-02-14',100.0),
(10,10,20,'2025-04-01',100.0);

-- Audit Table for Review 
 CREATE TABLE ReviewAudit (
    AuditID INT AUTO_INCREMENT PRIMARY KEY,
    ReviewID INT NOT NULL,
    UserID INT NOT NULL,
    AnimeID INT NOT NULL,
    OldRating DECIMAL(3,1),
    NewRating DECIMAL(3,1),
    ActionType VARCHAR(20) NOT NULL,
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (ReviewID) REFERENCES Reviews(ReviewID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID),
    FOREIGN KEY (AnimeID) REFERENCES Anime(AnimeID)
);


-- Views
CREATE VIEW AvgRatingByGenre AS
SELECT 
    g.GenreName,
    ROUND(AVG(a.Rating),2) AS AvgRating,
    COUNT(ag.AnimeID) AS AnimeCount
FROM Genres g
JOIN AnimeGenre ag ON g.GenreID = ag.GenreID
JOIN Anime a ON ag.AnimeID = a.AnimeID
GROUP BY g.GenreName
ORDER BY AvgRating DESC;

-- Purpose:
-- This view helps CrunchyAnime admins understand which genres perform best based on average ratings and popularity. For example, if Action has the highest rating and most anime, it shows user demand trends.

CREATE VIEW MonthlyWatchTrend AS
SELECT 
    DATE_FORMAT(wh.WatchDate, '%Y-%m') AS Month,
    COUNT(DISTINCT wh.UserID) AS ActiveUsers,
    COUNT(wh.AnimeID) AS EpisodesWatched
FROM WatchHistory wh
GROUP BY DATE_FORMAT(wh.WatchDate, '%Y-%m')
ORDER BY Month;

-- Purpose:
-- This view tracks platform engagement over time. It shows how many episodes were watched each month and how many unique users were active. CrunchyAnime can use this to see seasonal spikes (e.g., new anime releases) or drops in activity.

CREATE VIEW TopWatchedAnime AS
SELECT 
    a.Title,
    COUNT(wh.UserID) AS TotalViews,
    COUNT(DISTINCT wh.UserID) AS UniqueUsers
FROM WatchHistory wh
JOIN Anime a ON wh.AnimeID = a.AnimeID
GROUP BY a.Title
ORDER BY TotalViews DESC
LIMIT 5;

-- Purpose:
-- This view shows which anime are most popular on the platform. Admins can use it to promote trending anime or recommend similar shows.
-- View: Average Ratings by Subscription Type

CREATE VIEW AvgRatingBySubscription AS
SELECT 
    s.PlanName AS SubscriptionPlan,
    COUNT(r.ReviewID) AS TotalReviews,
    ROUND(AVG(r.Rating), 2) AS AvgRatingGiven,
    COUNT(DISTINCT u.UserID) AS UniqueUsers
FROM Users u
JOIN Subscriptions s ON u.SubscriptionID = s.SubscriptionID
LEFT JOIN Reviews r ON u.UserID = r.UserID
GROUP BY s.PlanName
ORDER BY AvgRatingGiven DESC;

-- This view joins Users with Subscriptions and Reviews. Grouped by SubscriptionPlan. 
-- Shows:
-- Total number of reviews by users of each plan. Average rating they gave (rounded to 2 decimals). Number of unique users in that subscription plan. Orders results by highest average rating first.

CREATE OR REPLACE VIEW MonthlyWatchTrend AS
SELECT 
    DATE_FORMAT(wh.WatchDate, '%Y-%m') AS Month,
    COUNT(DISTINCT wh.UserID) AS ActiveUsers,
    COUNT(wh.EpisodeID) AS EpisodesWatched,
    COUNT(DISTINCT wh.AnimeID) AS UniqueAnimeWatched
FROM WatchHistory wh
GROUP BY DATE_FORMAT(wh.WatchDate, '%Y-%m')
ORDER BY Month;

-- Joins and windowed function

SELECT 
    g.GenreName,
    ROUND(AVG(a.Rating),2) AS AvgRating,
    COUNT(DISTINCT a.AnimeID) AS AnimeCount
FROM Genres g
JOIN AnimeGenre ag ON g.GenreID = ag.GenreID
JOIN Anime a ON ag.AnimeID = a.AnimeID
GROUP BY g.GenreName
HAVING COUNT(a.AnimeID) > 2
ORDER BY AvgRating DESC;

-- Logic:
-- Joins Anime, Genres, and AnimeGenre
-- Groups by genre
-- Filters genres that have at least 3 anime (HAVING COUNT > 2)
-- Orders by rating
-- Insight:
-- This tells CrunchyAnime which genres are both popular and highly rated, guiding marketing and future acquisitions.

SELECT 
    a.Title,
    COUNT(DISTINCT wh.UserID) AS UniqueViewers,
    COUNT(wh.EpisodeID) AS TotalEpisodesWatched
FROM Anime a
JOIN WatchHistory wh ON a.AnimeID = wh.AnimeID
GROUP BY a.Title
ORDER BY UniqueViewers DESC, TotalEpisodesWatched DESC
LIMIT 5;

-- Logic:
-- Counts how many unique users watched each anime.
-- Orders by popularity.
-- Insight:
-- Helps CrunchyAnime identify its most-watched anime, useful for promoting, renewing licenses, or recommending to new users.

SELECT 
    s.PlanName,
    COUNT(u.UserID) AS Subscribers,
    ROUND(SUM(CASE WHEN wh.Progress = 100.0 THEN 1 ELSE 0 END) / COUNT(wh.EpisodeID) * 100, 2) AS CompletionRate
FROM Users u
JOIN Subscriptions s ON u.SubscriptionID = s.SubscriptionID
JOIN WatchHistory wh ON u.UserID = wh.UserID
GROUP BY s.PlanName
ORDER BY Subscribers DESC;

-- Logic:
-- Joins Users, Subscriptions, and WatchHistory
-- Uses CASE to calculate % of fully completed episodes
-- Groups by subscription plan
-- Insight:
-- Shows whether Premium users actually consume more anime vs. Trial or Basic users, helping decide on pricing/plan improvements.

SELECT 
    ranked.StudioName,
    ranked.Title,
    ranked.Rating
FROM (
    SELECT 
        s.StudioName,
        a.Title,
        a.Rating,
        ROW_NUMBER() OVER (PARTITION BY s.StudioName ORDER BY a.Rating DESC) AS RankNum
    FROM Anime a
    JOIN AnimeStudio ast ON a.AnimeID = ast.AnimeID
    JOIN Studios s ON ast.StudioID = s.StudioID
) AS ranked
WHERE ranked.RankNum = 1;

-- Logic:
-- Uses ROW_NUMBER() to rank anime per studio by rating.
-- Picks the top-rated anime for each studio.
-- Insight:
-- CrunchyAnime can highlight “Best Anime by Studio” in recommendations or negotiate with top-performing studios.

-- Subquery
SELECT 
    u.Name,
    u.Email,
    COUNT(wh.EpisodeID) AS EpisodesWatched
FROM Users u
JOIN WatchHistory wh ON u.UserID = wh.UserID
GROUP BY u.UserID
HAVING COUNT(wh.EpisodeID) >= (
    SELECT AVG(EpisodeCount)
    FROM (
        SELECT COUNT(EpisodeID) AS EpisodeCount
        FROM WatchHistory
        GROUP BY UserID
    ) sub
)
ORDER BY EpisodesWatched DESC;

-- Logic:
-- Counts episodes watched per user.
-- Compares it against the average episodes watched across all users using a subquery.
-- Filters only those who watched above average.
-- Insight:
-- Identifies super-fans / heavy users, who are ideal for targeted offers, early access, or beta testing features.

SELECT 
    Year,
    Title,
    TotalViews,
    RankNum
FROM (
    SELECT 
        YEAR(wh.WatchDate) AS Year,
        a.Title,
        COUNT(wh.EpisodeID) AS TotalViews,
        RANK() OVER (PARTITION BY YEAR(wh.WatchDate) ORDER BY COUNT(wh.EpisodeID) DESC) AS RankNum
    FROM WatchHistory wh
    JOIN Anime a ON wh.AnimeID = a.AnimeID
    GROUP BY YEAR(wh.WatchDate), a.Title
) ranked
WHERE RankNum <= 3
ORDER BY Year, RankNum;


-- Logic:
-- Groups data by year and anime title.
-- Counts how many episodes were watched per anime in each year.
-- Uses RANK() with PARTITION BY year to assign rankings.
-- Filters to keep only the top 3 anime per year.
-- Insight:
-- This tells CrunchyAnime which anime dominated each year. It’s perfect for:
-- Annual reports
-- Trending lists like “Top 3 Anime of 2021”
-- Spotting seasonal popularity changes (e.g., a surge in shonen anime in 2020).


EXPLAIN 
SELECT 
    u.Name,
    u.Email,
    COUNT(wh.EpisodeID) AS EpisodesWatched
FROM Users u
JOIN WatchHistory wh ON u.UserID = wh.UserID
GROUP BY u.UserID
HAVING COUNT(wh.EpisodeID) >= (
    SELECT AVG(EpisodeCount)
    FROM (
        SELECT COUNT(EpisodeID) AS EpisodeCount
        FROM WatchHistory
        GROUP BY UserID
    ) sub
)
ORDER BY EpisodesWatched DESC;

-- track time of each query
SELECT 
    DIGEST_TEXT AS QuerySample,
    COUNT_STAR AS Executions,
    AVG_TIMER_WAIT/1000000000000 AS AvgExecTimeSec
FROM performance_schema.events_statements_summary_by_digest 
ORDER BY AvgExecTimeSec DESC
LIMIT 10;

SET profiling = 1;
SELECT 
    u.Name,
    u.Email,
    COUNT(wh.EpisodeID) AS EpisodesWatched
FROM Users u
JOIN WatchHistory wh ON u.UserID = wh.UserID
GROUP BY u.UserID
HAVING COUNT(wh.EpisodeID) >= (
    SELECT AVG(EpisodeCount)
    FROM (
        SELECT COUNT(EpisodeID) AS EpisodeCount
        FROM WatchHistory
        GROUP BY UserID
    ) sub
)
ORDER BY EpisodesWatched DESC;
SHOW PROFILES;

-- Optimization Strategy
-- Creating index to allow MySQL to quickly find all watch records for a given user, reducing scan time.
CREATE INDEX idx_watchhistory_user ON WatchHistory(UserID);

-- Instead of recalculating averages repeatedly, this can compute them once with a Common Table Expression (CTE):
WITH UserEpisodeCounts AS (
    SELECT UserID, COUNT(EpisodeID) AS EpisodeCount
    FROM WatchHistory
    GROUP BY UserID
),
AverageCount AS (
    SELECT AVG(EpisodeCount) AS AvgEpisodes FROM UserEpisodeCounts
)
SELECT 
    u.Name,
    u.Email,
    ue.EpisodeCount
FROM Users u
JOIN UserEpisodeCounts ue ON u.UserID = ue.UserID
CROSS JOIN AverageCount avgc
WHERE ue.EpisodeCount >= avgc.AvgEpisodes
ORDER BY ue.EpisodeCount DESC;

-- The CTE calculates user totals once, then compares against the average.
-- No repeated subqueries, making it significantly faster.

-- CAP Theorem Application in Distributed Databases
/*The Three Components of CAP Theorem
Consistency (C):
Every read receives the most recent write or an error. In other words, all nodes in the distributed system return the same up-to-date data at any given time.
Availability (A):
Every request receives a response, even if it may not reflect the most recent write. The system continues to serve users without interruption.
Partition Tolerance (P):
The system continues to function even if communication between nodes is lost or delayed (i.e., the network is partitioned).
Why All Three Cannot Be Guaranteed
A distributed system cannot provide Consistency, Availability, and Partition Tolerance simultaneously. During a network partition, the system must choose between:
Consistency: blocking some requests until data is synchronized.
Availability: serving potentially stale data to ensure the system is responsive.
Thus, in the presence of a partition, designers must compromise on either C or A while always tolerating P.
Case Study: Online Banking System
For an online banking system, the priority is:
Consistency (C): Balances and transactions must always reflect the correct and up-to-date state. If Alice transfers money to Bob, both accounts must show accurate balances — no stale data allowed.
Partition Tolerance (P): Banking services are global and run across distributed servers. They must remain operational even if part of the network is down.
Availability (A) is compromised: If a network partition occurs, the system may temporarily block access rather than show outdated or inconsistent account balances. Users may see a "service unavailable" error instead of incorrect financial information.
This trade-off makes sense: it is better to have a short downtime than risk showing or executing incorrect transactions.
Reflection
Understanding the CAP theorem helps database designers make informed trade-offs:
For banking, prioritize accuracy (Consistency + Partition Tolerance).
For social media, prioritize speed and availability (Availability + Partition Tolerance), even if posts or likes appear slightly delayed.
For ride-hailing, prioritize quick matching and responsiveness (Availability + Partition Tolerance), accepting some brief inconsistencies.
By recognizing these trade-offs, designers can align database behavior with business needs and user expectations when building scalable distributed systems.

1. Consistency (C)
Definition:
Consistency means that every read operation returns the most recent write. In other words, all nodes in a distributed system have the same, synchronized view of the data at any given point in time.
How It Works:
When a client writes data to one node, that write must be replicated to all other nodes before the system considers the operation successful.
Any subsequent read must reflect that most recent write, regardless of which node is queried.
Advantages:
Guarantees strong data integrity.
Prevents issues such as stale or conflicting data.
Disadvantages / Trade-offs:
May require waiting until data is replicated across all nodes before responding to the client.
Can increase latency, especially in geo-distributed systems.
May result in temporary unavailability during network partitions because the system would rather reject a request than return stale data.
Real-World Example:
Online Banking: If you transfer money from Account A to Account B, you must immediately see the updated balance on all devices. Showing an old balance could lead to overdrafts or double spending.
2. Availability (A)
Definition:
Availability means that every request receives a (non-error) response — even if it may not reflect the latest data.
How It Works:
The system always returns some data when queried, even if some nodes are unreachable or data replication is still in progress.
It prioritizes responsiveness over strict accuracy.
Advantages:
Guarantees uptime — users rarely see downtime or error messages.
Improves user experience in high-traffic or global systems.
Disadvantages / Trade-offs:
Risk of serving stale data if the latest update hasn’t reached all nodes yet.
May require conflict resolution later (eventual consistency).
Real-World Example:
Social Media Platforms: When you like a post, the system shows it as liked immediately, even if the updated like count might take a few seconds to appear globally. This gives users a smooth experience.
3. Partition Tolerance (P)
Definition:
Partition tolerance means that the system continues to operate even if network failures or partitions occur that prevent some nodes from communicating with others.
How It Works:
The system is designed to handle network splits (called partitions) where part of the cluster becomes isolated.
It uses techniques like replication, retry mechanisms, and consensus algorithms to keep functioning.
Advantages:
Makes the system robust and fault-tolerant.
Ensures service continuity during outages or network disruptions.
Disadvantages / Trade-offs:
To maintain service during a partition, the system must sacrifice either Consistency (serve potentially stale data) or Availability (refuse some requests).
Implementing partition tolerance adds architectural complexity.
Real-World Example:
Global E-commerce Websites: If a data center in Europe loses connection to the main cluster, users in Europe can still browse and add items to their cart while synchronization happens later.
Key Takeaway
Consistency: "Everyone sees the same truth, at the same time."
Availability: "The system always answers, even if it’s not the latest truth."
Partition Tolerance: "The system survives network failures and keeps running."

Why a Distributed Database System Cannot Guarantee All Three (C, A, P) at the Same Time
A distributed database spreads data across multiple servers or locations to improve performance, scalability, and fault tolerance. However, because these servers must communicate over a network, failures and delays are inevitable.
The CAP Theorem states that during a network partition (when some servers cannot communicate with others), a distributed system must choose between:
Consistency (C): making sure all nodes always return the same, most recent data.
Availability (A): keeping the system responsive and serving every request.
It cannot guarantee both at the same time, because:
If the system chooses Consistency:
It must wait for all nodes to synchronize before responding.
This means some users might not get any response until the network is restored — sacrificing Availability.
If the system chooses Availability:
It will continue responding with data from whichever node is available, even if that data is outdated.
This means the system is no longer strictly Consistent, because different users might see different versions of the data.
Partition Tolerance (P) is non-negotiable — network issues are unavoidable in distributed systems, so the system must handle them. The real trade-off is between Consistency and Availability when partitions occur.
In Simple Terms
A distributed system can’t guarantee C, A, and P all together because:
When network failures happen, you can either pause operations to keep data consistent (sacrificing availability) OR keep the system running with possible stale data (sacrificing consistency) — but not both.

Real-World Analogy for CAP Theorem
Imagine you and your friend are co-owners of a bank with branches in two cities. You both keep a copy of the account ledger (database).
One day, the internet between the two branches goes down (network partition).
Now, a customer comes to deposit money:
Option 1: Prioritize Consistency (C + P)
You refuse to update the ledger until you can confirm with your friend's branch that they have the same updated copy.
The ledger stays consistent.
The customer must wait (Availability is sacrificed).
Option 2: Prioritize Availability (A + P)
You immediately record the deposit in your branch’s ledger, even though you can’t sync with your friend’s branch right now.
The customer is happy and served.
Your friend’s branch will still show the old balance until you sync later (Consistency is sacrificed).
You cannot both guarantee that the ledgers stay perfectly in sync and serve the customer immediately while the connection is down.

CAP Theorem Application: Online Banking System
Chosen System: Online Banking
Which Two Properties It Prioritizes
Consistency (C): 
Reason: In banking, it is critical that all users see the correct, up-to-date balance.
Example: If Alice transfers $100 to Bob, both their accounts must reflect this transaction correctly and immediately — otherwise, money could be lost or duplicated.
Impact: Strong consistency prevents double-spending, incorrect balances, or overdrafts.
Partition Tolerance (P): 
Reason: Banks operate globally, and network issues between data centers are unavoidable.
Example: Even if the network between two branches is temporarily down, the system must be able to handle the partition without crashing.
Impact: Ensures the banking system continues to function, at least in a controlled way, during network failures.
Which Property It Compromises
Availability (A): 
Reason: During a network partition, the system may choose to block or delay some transactions rather than risk showing outdated or inconsistent data.
Example: If you try to withdraw money when the system cannot confirm your actual balance, it may temporarily deny the request (“Service unavailable”) until the network issue is resolved.
Impact: Customers might face short service interruptions, but this is safer than allowing transactions with wrong balances.
Justification
Online banking systems must be 100% accurate with data because financial transactions are highly sensitive. Sacrificing availability for a short period is acceptable if it avoids errors like double withdrawals or incorrect account balances.
In other words:
Banking systems are CP systems (Consistency + Partition Tolerance)
They compromise Availability during failures to ensure financial integrity.

Reflection: Importance of CAP Theorem
Understanding the CAP Theorem enables database designers to make smarter trade-offs when building distributed systems. Since network failures are inevitable, designers must decide whether to prioritize consistency, availability, or a balance of both. This ensures that the system meets business needs while remaining reliable and scalable.
Key Takeaways:
Aligns system design with business priorities – e.g., financial apps choose consistency, social media prefers availability.
Guides technology selection – helps choose between SQL (strong consistency) and NoSQL (eventual consistency).
Improves fault tolerance – ensures predictable behavior during network failures and system partitions.

Reflection: Importance of CAP Theorem for Database Designers
Understanding the CAP Theorem is essential for database designers because it helps them make informed trade-offs when building and scaling distributed systems. In real-world scenarios, network failures and partitions are unavoidable, so designers must choose which properties (Consistency, Availability, Partition Tolerance) are most critical for their application.
For mission-critical systems like banking, designers prioritize Consistency + Partition Tolerance to ensure accurate transactions, even if it means short downtime.
For real-time consumer apps like ride-hailing or social media, designers often prioritize Availability + Partition Tolerance, allowing slightly stale data but keeping the system responsive for users.
By applying CAP principles, database architects can:
Aligns system design with business priorities – e.g., financial apps choose consistency, social media prefers availability.
Guides technology selection – helps choose between SQL (strong consistency) and NoSQL (eventual consistency).
Improves fault tolerance – ensures predictable behavior during network failures and system partitions.
Plan for failover strategies that match business requirements.
Optimize user experience by balancing correctness and uptime.
Improves fault tolerance – ensures predictable behavior during network failures and system partitions.

In short, CAP theorem guides the balance between user experience, data integrity, and fault tolerance, leading to systems that behave predictably under stress and scale effectively as demand grows.
*/

-- Stored Procedure

DELIMITER $$

CREATE PROCEDURE GetUserWatchSummary(IN p_UserID INT)
BEGIN
    SELECT 
        u.Name AS UserName,
        a.Title AS AnimeTitle,
        e.Title AS EpisodeTitle,
        wh.Progress AS WatchProgress,
        COALESCE(r.Rating, 'No Rating') AS UserRating
    FROM Users u
    JOIN WatchHistory wh ON u.UserID = wh.UserID
    JOIN Anime a ON wh.AnimeID = a.AnimeID
    JOIN Episodes e ON wh.EpisodeID = e.EpisodeID
    LEFT JOIN Reviews r ON r.UserID = u.UserID AND r.AnimeID = a.AnimeID
    WHERE u.UserID = p_UserID
    ORDER BY a.Title, e.ReleaseDate;
END$$

DELIMITER ;

/*Explanation
Input parameter: p_UserID → the ID of the user whose history we want.
Joins:
Users → to get the user’s name.
WatchHistory → to get episodes watched and progress.
Anime + Episodes → to get anime and episode titles.
Reviews → to retrieve ratings if they exist.
Orders results by anime title and episode release date.

Why This Is Useful
Gives personalized analytics for a user in a single query.
Useful for user profile pages ("Continue Watching" section).
Demonstrates parameterized stored procedure, which is often required in database projects.
*/
DELIMITER $$

CREATE PROCEDURE GetTopRatedAnime(IN p_Limit INT)
BEGIN
    SELECT 
        a.Title AS AnimeTitle,
        ROUND(AVG(r.Rating), 2) AS AvgRating,
        COUNT(r.ReviewID) AS TotalReviews
    FROM Anime a
    JOIN Reviews r ON a.AnimeID = r.AnimeID
    GROUP BY a.AnimeID, a.Title
    ORDER BY AvgRating DESC, TotalReviews DESC
    LIMIT p_Limit;
END$$

DELIMITER ;


/*Explanation
Input Parameter: p_Limit → number of top-rated anime to return (e.g., 5).
Aggregates reviews using AVG(r.Rating) and counts how many reviews each anime has.
Orders by highest rating first, then by number of reviews (to break ties).
Limits output to the top N records.

Why This Is Useful
Gives a dynamic top list that can be used on the homepage (“Top Rated Anime This Week”).
Helps business teams quickly identify fan-favorite anime.
Showcases your ability to use aggregation, ordering, and parameterized stored procedures together.
*/

-- Trigger: Track INSERT (new reviews)
DELIMITER $$

CREATE TRIGGER trg_after_review_insert
AFTER INSERT ON Reviews
FOR EACH ROW
BEGIN
    INSERT INTO ReviewAudit (ReviewID, UserID, AnimeID, NewRating, ActionType)
    VALUES (NEW.ReviewID, NEW.UserID, NEW.AnimeID, NEW.Rating, 'INSERT');
END$$

DELIMITER ;

-- Trigger: Track UPDATE (rating changes)
DELIMITER $$

CREATE TRIGGER trg_after_review_update
AFTER UPDATE ON Reviews
FOR EACH ROW
BEGIN
    INSERT INTO ReviewAudit (ReviewID, UserID, AnimeID, OldRating, NewRating, ActionType)
    VALUES (NEW.ReviewID, NEW.UserID, NEW.AnimeID, OLD.Rating, NEW.Rating, 'UPDATE');
END$$

DELIMITER ;

/*
What is this trigger used for: Tracks when a review is added or modified.
Why it matters: Prevents manipulation (e.g., fake ratings, spam), provides accountability.
Business impact: Supports fraud detection, user trust, and compliance.
*/

-- Insert value to trigger review insert 
INSERT INTO Reviews (ReviewID, UserID, AnimeID, Rating, ReviewText, ReviewDate)
VALUES (11, 1, 2, 8.5, 'Good but pacing was slow.', '2025-09-16');

-- Update value to trigger review update 
UPDATE Reviews
SET Rating = 9.0, ReviewText = 'Actually, masterpiece after rewatch!'
WHERE ReviewID = 11;

-- check ReviewAudit table to check the triggers
SELECT * FROM ReviewAudit;