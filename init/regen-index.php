<?php

// CONFIGURATION

// If blank, defaults to "$TMPDIR/species-autocomplete.sqlite3"
$SQLITE_PATH = "/tmp/species-autocomplete.sqlite3";

// What is the smallest number of characters at which the autocomplete kicks in?
$MIN_LENGTH = 1;

// END OF CONFIGURATION

// Open a connection to the SQLite database.
try {
    $sqlite = new SQLite3($SQLITE_PATH, SQLITE3_OPEN_READWRITE);
} catch (Exception $e) {
    die("Could not open '$SQLITE_PATH': $e");
}

print "Opened SQLite3 file at '$SQLITE_PATH'.\n";

if(!$sqlite->exec("DELETE FROM autocomplete;")) {
    die("Could not delete rows from autocomplete.");
}
print "Dropped previous autocomplete index.\n";

// Prepare our insert statement.
$insert_ac = $sqlite->prepare("INSERT INTO autocomplete (string, canonicalName, score) VALUES (:string, :name, :score);");

// Load names.
$results = $sqlite->query('SELECT canonicalName FROM names;');
if($results === FALSE) {
    die("Could not read names from database.");
}

$count_names = 0;
$count_words = 0;
$count_ac = 0;
while ($row = $results->fetchArray( SQLITE3_NUM )) {
    $name = $row[0];
    $canon_name = $row[1];
    
    $count_names++;

    // Confusingly, this returns an array of all the words in this
    // string. Fun!
    $words = str_word_count($name, 1);
    
    // But do the whole name too!
    array_push($words, $name);
    
    // TODO: ngrams?

    foreach($words as $word) {
        if(strlen($word) < $MIN_LENGTH) {
            print "Ignoring word '$word', smaller than minimum length ($MIN_LENGTH).\n";
        } else {
            $count_words++;

            for($x = $MIN_LENGTH; $x <= strlen($word); $x++) {
                $ac_bit = strtolower(substr($word, 0, $x));

                # print "Found '$ac_bit' => '$word'.\n";
                $insert_ac->bindValue(':string', $ac_bit, SQLITE3_TEXT);
                $insert_ac->bindValue(':name', $name, SQLITE3_TEXT);
                $insert_ac->bindValue(':score', 0, SQLITE3_INTEGER);
                if(!$insert_ac->execute()) {
                    die("Unable to execute statement '$insert_ac'.");
                }
                $insert_ac->clear();

                $count_ac++;
            }
        }
    }
}

// All done!
$sqlite->close();
print "All done! $count_names names containing $count_words words to generated $count_ac autocomplete possibilities.\n";

?>
