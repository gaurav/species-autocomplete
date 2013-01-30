-- Demonstration data for Species Autocomplete.
-- For use in SQLite 3.

-- Drop old tables.
DROP TABLE IF EXISTS names;
DROP TABLE IF EXISTS autocomplete;

-- Create new table.
CREATE TABLE names (
    canonicalName TEXT UNIQUE,
    acceptedName TEXT,
    scientificName TEXT,
    nameAccordingTo TEXT,
    family TEXT,
    source TEXT
);

CREATE INDEX names_name ON names(canonicalName);

CREATE TABLE autocomplete (
    string TEXT,
    canonicalName TEXT,
    score INTEGER   -- We use this to score name matches; higher scored matches appear higher up.
    ,

    CONSTRAINT unique_combination UNIQUE (string, canonicalName) ON CONFLICT IGNORE
);

CREATE INDEX autocomplete_string ON autocomplete(canonicalName);

-- Add data.
INSERT INTO names (canonicalName, acceptedName, family, source) VALUES
    ('Panthera tigris', 'Panthera tigris', 'Felidae', 'http://en.wikipedia.org/wiki/Panthera_tigris');

INSERT INTO names (canonicalName, acceptedName, family, source) VALUES
    ('Panthera leo', 'Panthera leo', 'Felidae', 'http://en.wikipedia.org/wiki/Panthera_leo');

INSERT INTO names (canonicalName, acceptedName, source) VALUES
    ('Felidae', 'Felidae', 'http://en.wikipedia.org/wiki/Felidae');

-- Run regen-index.php to regenerate the index.
