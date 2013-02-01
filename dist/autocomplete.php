<?php

// Configuration options.
$SQLITE_PATH = getenv("HOME") . "/sqlite/species-autocomplete.sqlite3";

// End of configuration options.

// Load SQLite3 database.
try {
    $sqlite = new SQLite3($SQLITE_PATH);
} catch(Exception $e) {
    die("Could not open SQLite3 path '$SQLITE_PATH': $sqlite");
}

$s = $sqlite->prepare("SELECT names.canonicalName, acceptedName, scientificName, nameAccordingTo, family, source FROM autocomplete JOIN names ON autocomplete.canonicalName = names.canonicalName WHERE string = :query ORDER BY score DESC LIMIT 7");
$s->bindValue(":query", strtolower($_GET['term']));
$results = $s->execute();

$results_all = array();
while($row = $results->fetchArray(SQLITE3_ASSOC)) {
    // Hack: convert canonical names from 'abc def' to 'Abc def'.
    $row['canonicalName'][0] = strtoupper($row['canonicalName'][0]);
    array_push($results_all, $row);
}

header("Content-type: text/plain");
print json_encode($results_all);

$sqlite->close();

?>
