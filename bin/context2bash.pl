#!/usr/bin/perl
use strict;
use JSON;
use Data::Dumper;

my $json = new JSON;
$json->pretty(1);

my $C = '@context';

my $f1 = shift @ARGV;
my $c1 = parseJSON($f1);

my $ctxt = $c1->{'@context'};
if (!$ctxt) {
    $ctxt = $c1;
}
foreach my $k (keys %$ctxt) {
    #my $v = uc($k);
    my $v = $k;
    $v =~ s@[\.\-]@_@g;
    my $uribase = $ctxt->{$k};
    # remove trailing slash, e.g. to write $OBO/GO_nnnn
    $uribase =~ s@/$@@;
    print "export $k=\"$uribase\"\n";
}

exit 0;

sub parseJSON {
    my $f = shift @_;
    print STDERR "Parsing: $f\n";
    open(F, $f) || die($f);
    my $blob = join("",<F>);
    close(F);
    return $json->decode($blob);
}
