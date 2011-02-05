use strict;
use Test::More;
use Geo::Hex1;

for (<DATA>) {
    chomp;
    my ($hex,$dist,@geohexes)  = split/ +/;

    my @tgeohexes     = @{distance2geohexes($hex,$dist)};
    my %geohexes = map { $_ => 1 } @geohexes;

    for my $tgeohex ( @tgeohexes ) {
        ok delete $geohexes{$tgeohex}, "Testing $tgeohex";
    }
    
    foreach my $key ( keys %geohexes ) {
        die "Some hexes are not tested: $key";
    }
};

done_testing;

__DATA__
8sijg   1   8sijh   8siig   8siif   8sijf   8sikg   8sikh
8sijg   2   8sijh   8siig   8siif   8sijf   8sikg   8sikh   8sili   8siki   8siji   8siih   8sihg   8sihf   8sihe   8siie   8sije   8sikf   8silg   8silh
