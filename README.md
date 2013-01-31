species-autocomplete
====================

A [Phylotastic 2](http://evoio.org/wiki/Phylotastic) project to autocomplete species names over the web. This
project consists of three components:

1. The `init` folder contains the files necessary to set up the SQLite database.
`init.sql` is the initialization script for the database. You can then run
`demo-data.sql` for really basic starting data, or you can add the names you
want into the `names` table. Finally, run `regen-index.php` to regenerate the
names index. This takes a LONG time; I hope to look into faster approaches at
some point.

2. The `importers` folder contains files which can help you add data from
various sources. A generic DarwinCSV to SQLite script is provided, which
converts a DarwinCSV file into a pipe-delimited file for input into SQLite.
It's designed around http://gaurav.github.com/itis-dwca/, which requires
two important processing steps:

    1. AcceptedNameUsageIDs need to be translated into AcceptedNameUsages.
    2. ParentNameUsageIDs need to be translated into Family.

3. The `dist` folder contains the files you need to incorporate into your
website: `index.html`, which displays the drop-down list, and `autocomplete.php`,
which searches a local SQLite database for the autocomplete names. 

For more information, please [get in touch](http://www.ggvaidya.com/contact-me.html).
