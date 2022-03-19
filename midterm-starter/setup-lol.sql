-- CS 121 Winter 2022 Midterm Exam
-- Part B: DML

-- Remember to use load-lol.sql to test your DML and comment your
-- tables appropriately! DO NOT use any CREATE/USE DATABASE statements
-- in this file.
DROP TABLE IF EXISTS assists;
DROP TABLE IF EXISTS final_blows;
DROP TABLE IF EXISTS played;
DROP TABLE IF EXISTS teams;
DROP TABLE IF EXISTS matches;

-- Table containing professional matches from 2014 and 2018
CREATE TABLE matches (
    -- unique identifier for individual matches
    gamehash CHAR(16) NOT NULL,
    -- eg. "LCK"
    league VARCHAR(5) NOT NULL,
    -- "Summer" or "Spring"
    season CHAR(6) NOT NULL,
    -- eg. "Playoffs"
    match_type VARCHAR(50) NOT NULL,
    year YEAR NOT NULL,
    game_length INT NOT NULL,
    PRIMARY KEY (gamehash)
);

-- Table containing teams for different matches and match results
CREATE TABLE teams (
    -- Team name abbreviation, eg. "TSM"
    team VARCHAR(10) NOT NULL,
    gamehash CHAR(16) NOT NULL,
    -- Red or Blue
    side VARCHAR(4) NOT NULL,
    won BOOL NOT NULL,
    PRIMARY KEY (team, gamehash),
    FOREIGN KEY (gamehash) REFERENCES matches(gamehash)
        ON DELETE CASCADE,
    CHECK (side IN ('red', 'blue')),
    CHECK (won IN (0, 1))
);

-- Table containing information about players that played in matches
CREATE TABLE played (
    -- eg. "WildTurtle"
    player_name VARCHAR(16) NOT NULL,
    gamehash CHAR(16) NOT NULL,
    team_name VARCHAR(10) NOT NULL,
    -- Player role, eg. "Top"
    role VARCHAR(10) NOT NULL,
    -- Name of character the player played, eg. "Gnar"
    champion VARCHAR(30) NOT NULL,
    -- Total amount of gold a player earned over match
    gold INT NOT NULL,
    PRIMARY KEY (player_name, gamehash),
    FOREIGN KEY (gamehash) REFERENCES matches(gamehash)
        ON DELETE CASCADE,
    CHECK (role IN ('Top', 'Jungle', 'Middle', 'ADC', 'Support')),
    CHECK (gold >= 0)
);

-- Table containig information about final blows in the matches
CREATE TABLE final_blows (
    gamehash CHAR(16) NOT NULL,
    -- Time elapsed since start of game when final blow was made
    time_of_blow TIME NOT NULL,
    killed_player VARCHAR(16) NOT NULL,
    killing_player VARCHAR(16) NOT NULL,
    -- x-position of kill location on the game field
    xpos INT NOT NULL,
    -- y-position of kill location on the game field
    ypos INT NOT NULL,
    PRIMARY KEY (gamehash, time_of_blow, killed_player),
    FOREIGN KEY (gamehash) REFERENCES matches(gamehash)
        ON DELETE CASCADE
);

-- Table containing information about assists for final blows
CREATE TABLE assists (
    gamehash CHAR(16) NOT NULL,
    -- Time elapsed since start of game when final blow was made
    time_of_blow TIME NOT NULL,
    killed_player VARCHAR(16) NOT NULL,
    assisting_player VARCHAR(16) NOT NULL,
    PRIMARY KEY (gamehash, time_of_blow, killed_player, assisting_player),
    FOREIGN KEY (gamehash, time_of_blow, killed_player) 
        REFERENCES final_blows(gamehash, time_of_blow, killed_player)
        ON DELETE CASCADE,
    CHECK (assisting_player != killed_player)
);
