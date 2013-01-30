<?php

// Configuration options.
$SQLITE_PATH = "/tmp/species-autocomplete.sqlite3";

// End of configuration options.

// Load SQLite3 database.
try {
    $sqlite = new SQLite3($SQLITE_PATH);
} catch(Exception $e) {
    die("Could not open SQLite3 path '$SQLITE_PATH': $sqlite");
}

$s = $sqlite->prepare("SELECT names.name, canonicalName, acceptedName, source FROM names JOIN autocomplete ON names.name = autocomplete.name WHERE string = :query");
$s->bindValue(":query", $_GET['q']);
$results = $s->execute();

$results_all = array();
while($row = $results->fetchArray(SQLITE3_NUM)) {
    array_push($results_all, $row);
}

header("Content-type: text/plain");
print json_encode($results_all);

$sqlite->close();

?>
