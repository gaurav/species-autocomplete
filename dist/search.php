<?php

// Configuration options.
$SQLITE_PATH = ""; // If blank, defaults to "$TMPDIR/species-autocomplete.sqlite3"

// Does the demo SQLite data exist?
if($SQLITE_PATH == "") {
    $SQLITE_PATH = sys_get_temp_dir() . $DIRECTORY_SEPARATOR . "species-autocomplete.sqlite3";
}

$sqlite = sqlite_open($SQLITE_PATH, $sqlite_error);
if(!$sqlite) {
    die("Could not open '$SQLITE_PATH': $sqlite_error");
}

// Database open! Check for the 'names' table.
if(!sqlite_fetch_column_types("names", $sqlite)) {
    // Build one.
    sqlite_exec("CREATE TABLE names (name, 
}

sqlite_close($sqlite);

?>
