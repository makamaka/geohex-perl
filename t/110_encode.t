use strict;
use Test::More;
use Geo::Hex;

my @data = <DATA>;

my $geohex = Geo::Hex->new( v => 1 );

for my $d ( @data ) {
    chomp($d);
    my ( $lat, $lon, $level, $code) = split/ +/, $d;
    is ( $geohex->encode($lat, $lon, $level), $code, $code );
}

done_testing;

__DATA__
35.658395   139.701848  7   wkmP
35.658305   139.700877  1   132KpwT
35.658305   139.700877  15  ff96I
35.658395   139.701848  60  032Lr
34.692489   135.500302  7   rmox
34.692489   135.500302  1   132bBGK
34.692489   135.500302  15  fcaLw
34.692489   135.500302  60  032dD
