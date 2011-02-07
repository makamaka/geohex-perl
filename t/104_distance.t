use strict;
use Test::More;
use Geo::Hex::V1;

for ( <DATA> ) {
    chomp;
    my ($hex1,$hex2,$dist)  = split/ +/;
    my $tdist = geohex2distance($hex1,$hex2);
    is $tdist, $dist;
};

done_testing;

__DATA__
wknR    wkoR    1
wknR    wkoS    1
wknR    wknS    1
wknR    wkmR    1
wknR    wkmQ    1
wknR    wknQ    1
wknR    wkmO    3
wknR    wklS    3
8sikg   8sihc   4
