DROP TABLE IF EXISTS track;
DROP TABLE IF EXISTS artist;
DROP TABLE IF EXISTS album;
DROP TABLE IF EXISTS playlist;

-- Represents data for Spotify playlists.
CREATE TABLE playlist (
    -- A playlist's Unique Resource Identifier
    playlist_uri CHAR(22) NOT NULL,
    playlist_name VARCHAR(250) NOT NULL,
    PRIMARY KEY (playlist_uri)
);

-- Represents data for albums on Spotify.
CREATE TABLE album (
    -- An album's Unique Resource Identifier
    album_uri CHAR(22) NOT NULL,
    album_name VARCHAR(250) NOT NULL,
    release_date DATE NOT NULL,
    PRIMARY KEY (album_uri)
);

-- Represents data for artists on Spotify.
CREATE TABLE artist (
    -- An artist's Unique Resource Identifier
    artist_uri CHAR(22) NOT NULL,
    artist_name VARCHAR(250) NOT NULL,
    PRIMARY KEY (artist_uri)
);

-- Represents data for tracks on Spotify.
CREATE TABLE track (
    track_uri CHAR(22) NOT NULL,
    track_name VARCHAR(250) NOT NULL,
    artist_uri CHAR(22) NOT NULL,
    album_uri CHAR(22) NOT NULL,
    playlist_uri CHAR(22) NOT NULL,
    -- Duration in milliseconds
    -- eg. 180000
    duration_ms INT NOT NULL,
    preview_url VARCHAR(100),
    popularity TINYINT NOT NULL, 
    added_at TIMESTAMP NOT NULL,
    added_by VARCHAR(250),
    PRIMARY KEY (track_uri),
    FOREIGN KEY (artist_uri) REFERENCES artist(artist_uri)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (album_uri) REFERENCES album(album_uri)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
	FOREIGN KEY (playlist_uri) REFERENCES playlist(playlist_uri)
        ON UPDATE CASCADE
        ON DELETE CASCADE
);
