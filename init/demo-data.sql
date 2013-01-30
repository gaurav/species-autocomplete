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
    scientificName TEXT,
    nameAccordingTo TEXT,
    family TEXT,
    source TEXT
);

CREATE INDEX names_name ON names(name);

CREATE TABLE autocomplete (
    string TEXT,
    name TEXT,
    score INTEGER   -- We use this to score name matches; higher scored matches appear higher up.
    ,

    CONSTRAINT unique_combination UNIQUE (string, name) ON CONFLICT IGNORE
);

CREATE INDEX autocomplete_string ON autocomplete(string);

-- Add data.
INSERT INTO names (name, canonicalName, acceptedName, family, source) VALUES
    ('panthera tigris', 'Panthera tigris', 'Panthera tigris', 'Felidae', 'http://en.wikipedia.org/wiki/Panthera_tigris');

INSERT INTO names (name, canonicalName, acceptedName, family, source) VALUES
    ('felis tigris', 'Panthera tigris', 'Panthera tigris', 'Felidae', 'http://en.wikipedia.org/wiki/Panthera_tigris');

INSERT INTO names (name, canonicalName, acceptedName, family, source) VALUES
    ('tiger', 'Panthera tigris', 'Panthera tigris', 'Felidae', 'http://en.wikipedia.org/wiki/Panthera_tigris');

INSERT INTO names (name, canonicalName, acceptedName, family, source) VALUES
    ('lion', 'Panthera leo', 'Panthera leo', 'Felidae', 'http://en.wikipedia.org/wiki/Panthera_leo');

INSERT INTO names (name, canonicalName, acceptedName, source) VALUES
    ('cats', 'Felidae', 'Felidae', 'http://en.wikipedia.org/wiki/Felidae');

-- Run regen-index.php to regenerate the index.
