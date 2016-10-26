#!/usr/bin/perl
use strict;

#my $blob = `curl -L http://purl.obolibrary.org/obo/pr.obo | head -1000`;
#my @lines = split(/\n/,$blob);

open(F,'pr-old.obo') || die;
my @lines = <F>;
close(F);

print "{\n";
print "  \"\@context\": {\n";
#print "    \"idot\": \"http://identifiers.org/\",\n";

my $n = 0;
foreach (@lines) {
    #print STDERR "$_\n";
    if (m@idspace:\s+(\S+)\s+(\S+)@) {
        my ($idspace, $base) = ($1, $2);
        ##my $uc = uc($idspace);
        print ",\n" if $n;
        print "    \"$idspace\": \"$base\"";
        $n++;
    }
}
print "}}\n";
