species-autocomplete
====================

A Phylotastic 2 project to autocomplete species names over the web.

USAGE: This project has been designed in two parts, but in general, it
should work if the files in the 'dist' directory are copied into your
public folder. 'dist/species-autocomplete' contains files used the
Javascript components, i.e. the scripts themselves and associated CSS
files. 'dist/search.php' actually carries out the script against a local
SQLite directory; by default, it will create an SQLite file in your
temporary directory and populate it with a bunch of names. You can 
configure it to use an existing SQLite database.

