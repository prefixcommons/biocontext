#!/usr/bin/perl
use strict;
use JSON;
use Data::Dumper;

my $json = new JSON;
$json->pretty(1);

my $C = '@context';

# MIRIAM, GO
my ($f1,$f2) = @ARGV;

my $mir = parseJSON($f1);
my $goxs = parseJSON($f2);

my $dm = {};

foreach my $db (@$goxs) {
    foreach (@{$db->{generic_urls}}) {
        my $dom = get_domain($_);
        push(@{$dm->{$dom}},$db->{database});
    }
}

print Dumper($dm);

exit 0;

sub parseJSON {
    my $f = shift @_;
    print STDERR "Parsing: $f\n";
    open(F, $f) || die($f);
    my $blob = join("",<F>);
    close(F);
    return $json->decode($blob);
}

sub get_domain {
    my $url = shift;
    $url =~ s@/.*@@g;
    if ($url =~ /(\w+)\.(\w+)$/) {
        return $1;
    }
}
