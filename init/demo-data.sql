-- Demonstration data for Species Autocomplete.
-- For use in SQLite 3.

INSERT INTO names (canonicalName, acceptedName, family, source) VALUES
    ('Panthera tigris', 'Panthera tigris', 'Felidae', 'http://en.wikipedia.org/wiki/Panthera_tigris');

INSERT INTO names (canonicalName, acceptedName, family, source) VALUES
    ('Panthera leo', 'Panthera leo', 'Felidae', 'http://en.wikipedia.org/wiki/Panthera_leo');

INSERT INTO names (canonicalName, acceptedName, source) VALUES
    ('Felidae', 'Felidae', 'http://en.wikipedia.org/wiki/Felidae');

-- Run regen-index.php to regenerate the index.
