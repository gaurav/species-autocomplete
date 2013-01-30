-- Demonstration data for Species Autocomplete.
-- For use in SQLite 3.

-- Drop old tables.
DROP TABLE IF EXISTS names;
DROP TABLE IF EXISTS autocomplete;

-- Create new table.
CREATE TABLE names (
    name TEXT,
    canonicalName TEXT,
    acceptedName TEXT,
    source TEXT
);

CREATE INDEX names_name ON names(name);

CREATE TABLE autocomplete (
    string TEXT,
    name TEXT
);

CREATE INDEX autocomplete_string ON autocomplete(string);

-- Add data.
INSERT INTO names (name, canonicalName, acceptedName, source) VALUES
    ('panthera tigris', 'panthera tigris', 'panthera tigris', 'http://en.wikipedia.org/wiki/Panthera_tigris');

INSERT INTO names (name, canonicalName, acceptedName, source) VALUES
    ('felis tigris', 'panthera tigris', 'panthera tigris', 'http://en.wikipedia.org/wiki/Panthera_tigris');

INSERT INTO names (name, canonicalName, acceptedName, source) VALUES
    ('tiger', 'panthera tigris', 'panthera tigris', 'http://en.wikipedia.org/wiki/Panthera_tigris');

INSERT INTO names (name, canonicalName, acceptedName, source) VALUES
    ('lion', 'panthera leo', 'panthera leo', 'http://en.wikipedia.org/wiki/Panthera_leo');

INSERT INTO names (name, canonicalName, acceptedName, source) VALUES
    ('cats', 'felidae', 'felidae', 'http://en.wikipedia.org/wiki/Felidae');

-- Run regen-index.php to regenerate the index.
