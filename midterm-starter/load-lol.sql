-- CS 121 Winter 2022 Midterm (Provided)
-- Commands to load provided CSV files into your 5 tables.
-- Change '\n' to '\r\n' on Windows machines if needed.

SET GLOBAL local_infile = 1; 

LOAD DATA LOCAL INFILE '/Users/dereking/Downloads/midterm-starter/matches.csv' INTO TABLE matches
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/dereking/Downloads/midterm-starter/teams.csv' INTO TABLE teams
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/dereking/Downloads/midterm-starter/played.csv' INTO TABLE played
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/dereking/Downloads/midterm-starter/final_blows.csv' INTO TABLE final_blows
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

LOAD DATA LOCAL INFILE '/Users/dereking/Downloads/midterm-starter/assists.csv' INTO TABLE assists
FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' IGNORE 1 ROWS;

