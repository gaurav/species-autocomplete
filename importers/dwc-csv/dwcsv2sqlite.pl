#!/usr/bin/perl -w

use 5.012;

use strict;
use warnings;

use Data::Dumper;
use Text::CSV;

=head1 NAME

dwcsv2sqlite.pl -- Convert DwC-CSV files into SQLite tables

=head1 SYNOPSIS

    dwcsv2sqlite.pl input.csv table_name > sqlite-import.psv

=cut

# 1. Figure out inputs.
die "Expects one arguments: the input DarwinCSV file."
    unless exists $ARGV[0];

my $INPUT_FILE = $ARGV[0];

# 2. Load the entire file into memory.
my $csv = Text::CSV->new({ 
    binary => 1,
    blank_is_undef => 1
});

open(my $input, '<:encoding(utf8)', $INPUT_FILE)
    or die "Could not open '$INPUT_FILE' for input: $!";

# We need headers on the CSV file.
$csv->column_names($csv->getline($input));

say STDERR "Please wait, loading entire file.";
my %identifiers;
while(my $line = $csv->getline_hr($input)) {
    $identifiers{$line->{'taxonID'}} = $line;
}
close($input);

say STDERR "Done: " . (scalar keys %identifiers) . " identifiers loaded.";

# 3. Identify families for all species.
say STDERR "Identifying families for all species.";
foreach my $identifier (keys %identifiers) {
    my $c = $identifiers{$identifier};

    next unless($c->{'taxonRank'} eq 'Species');

    $c->{'family'} = find_family($c->{'taxonID'});
}
say STDERR "Identification of families completed.";

# 4. Write out accepted name usages.
say STDERR "Determining accepted name usages for all species.";
foreach my $identifier (keys %identifiers) {
    my $c = $identifiers{$identifier};

    next unless($c->{'taxonRank'} eq 'Species');

    $c->{'acceptedNameUsage'} = find_accepted_name($c->{'taxonID'});
}
say STDERR "Accepted name usages determined for all species.";

# 5. Write this out as pipe-delimited for SQLite to use.
say STDERR "Writing output.";

# say "canonicalName|acceptedName|family|source"
my %canonicalNames;
my $count_lines = 0;
my $count_duplicates = 0;
foreach my $id (keys %identifiers) {
    my $c = $identifiers{$id};

    next unless($c->{'taxonRank'} eq 'Species');
    next unless($c->{'taxonomicStatus'} eq 'accepted' || $c->{'taxonomicStatus'} eq 'valid');

    my $canonName = get_canonical_name($c->{'scientificName'});
    next if(not defined $canonName);

    if(exists $canonicalNames{$canonName}) {
        say STDERR "Duplicate canonical name '$canonName' detected, ignoring.";
        $count_duplicates++;
        next;
    }
    $canonicalNames{$canonName} = 1;

    my $line = 
        $canonName .
        '|' . $c->{'acceptedNameUsage'} .
        '|' . $c->{'scientificName'} .
        '|ITIS download of December 27, 2012' .
        '|' . $c->{'family'} .
        "|http://www.itis.gov/servlet/SingleRpt/SingleRpt?search_topic=TSN&search_value=$id"
    ;

    # Make sure we don't have extraneous pipe symbols in here.
    unless(6 == scalar split('\|', $line)) {
        die "Taxon $id contains a pipe symbol, please remove! " .
            "Splits: " . join(' :: ', split('\|', $line));
    }

    say $line;
    $count_lines++;
}

say STDERR "Output successful, $count_lines lines written, $count_duplicates duplicates skipped.";

say STDERR "\nCommands for SQLite: .import filename.psv";

exit;

# Helper code.
sub get_canonical_name {
    my($name) = @_;

    # From TaxRef: canonical
    # ^\\s*([A-Z][a-z]+)\\s+([a-z]+)(?:\\s+([a-z]+))?\\b"); // \\s+[a-z]+(?:\\s+[a-z]+))\\b
    if($name =~ /^\s*([A-Z][a-z]+)\s+([a-z]+)(?:\s+([a-z]+))?\b/) {
        return "$1 $2 $3" if defined $3;
        return "$1 $2";
    }

    # From TaxRef: monomial
    # "^\\s*([A-Z](?:[a-z]+|[A-Z]+))\\b"
    if($name =~ /^\s*([A-Z](?:[a-z]+|[A-Z]+))\b/) {
        return $1;
    }

    say STDERR "WARNING: Could not determine the canonical name for '$name'.";
    return undef;
}

sub find_family {
    my($taxon_id) = @_;

    my $c = $identifiers{$taxon_id};
    if(not defined $c) {
        say STDERR "File doesn't contain referenced taxon '$taxon_id'.";
        return "(incomplete)";
    }

    return $c->{'scientificName'} if($c->{'taxonRank'} eq 'Family');

    my $taxStatus = $c->{'taxonomicStatus'};
    if($taxStatus eq 'valid' || $taxStatus eq 'accepted') {
        # Do nothing, keep going up.
    } elsif($taxStatus eq 'invalid' || $taxStatus eq 'not accepted') {
        # Switch over to the accepted name and look for a family there.
        return find_family($c->{'acceptedNameUsageID'});
    } else {
        die "Unknown taxonomic status: '$taxStatus' for taxon id '$taxon_id'.";
    }

    return "(unknown)" if not defined $c->{'parentNameUsageID'};

    return find_family($c->{'parentNameUsageID'});
}

sub find_accepted_name { 
    my($taxon_id) = @_;

    my $c = $identifiers{$taxon_id};
    if(not defined $c) {
        say STDERR "File doesn't contain referenced taxon '$taxon_id'.";
        return "(incomplete)";
    }

    return $c->{'scientificName'} if(not defined $c->{'acceptedNameUsageID'});

    my $taxStatus = $c->{'taxonomicStatus'};
    if($taxStatus eq 'valid' || $taxStatus eq 'accepted') {
        # Do nothing, keep going up.
        die "Valid species '$taxon_id' doesn't have an acceptedNameUsageID; why?";

    } elsif($taxStatus eq 'invalid' || $taxStatus eq 'not accepted') {
        # Switch over to the accepted name and look for a family there.
        return find_accepted_name($c->{'acceptedNameUsageID'});

    } else {
        die "Unknown taxonomic status: '$taxStatus' for taxon id '$taxon_id'.";
    }

    # We should never get here, but just in case ...
    die "Should never get here.";
}
