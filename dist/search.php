<?php

// Configuration options.
$SQLITE_PATH = ""; // If blank, defaults to "$TMPDIR/species-autocomplete.sqlite3"

// Does the demo SQLite data exist?
if($SQLITE_PATH == "") {
    $SQLITE_PATH = sys_get_temp_dir() . $DIRECTORY_SEPARATOR . "species-autocomplete.php";
}

?>
