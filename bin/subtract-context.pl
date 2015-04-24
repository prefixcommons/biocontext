#!/usr/bin/perl
use strict;
use JSON;
use Data::Dumper;

my $json = new JSON;
$json->pretty(1);

my $C = '@context';

my ($f1,$f2) = @ARGV;

my $c1 = parseJSON($f1);
my $c2 = parseJSON($f2);


foreach my $k (keys %{$c2->{$C}}) {
    ##print STDERR "DELETING: $k\n";
    delete $c1->{$C}->{$k};
}
#print Dumper($c1);
print $json->encode($c1);

exit 0;

sub parseJSON {
    my $f = shift @_;
    print STDERR "Parsing: $f\n";
    open(F, $f) || die($f);
    my $blob = join("",<F>);
    close(F);
    return $json->decode($blob);
}
