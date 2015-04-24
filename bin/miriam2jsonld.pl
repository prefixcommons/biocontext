#!/usr/bin/perl

## I am totally going to hell for writing this script.
## What kind of person transforms ttl using grep?
## This is sick and wrong...

print "{\n";
print "  \"\@context\": {\n";
print "    \"idot\": \"http://identifiers.org/\",\n";

my $n = 0;
while (<>) {
    if (m@void:uriSpace <http://identifiers.org/(\S+)/>@) {
        my $idspace = $1;
        my $uc = uc($idspace);
        print ",\n" if $n;
        print "    \"$uc\": \"http://identifiers.org/$idspace/\"";
        $n++;
    }
}
print "}}\n";
