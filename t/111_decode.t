use strict;
use Test::More;
use Geo::Hex;

my @data = <DATA>;

my $geohex = Geo::Hex->new( v => 1 );

# v2 decode test does not exist.

for my $d ( @data ) {
    chomp($d);
    my ( $code, $check_lat, $check_lon, $check_level ) = split/ +/, $d;
    my ( $lat, $lon, $level ) = $geohex->decode($code);

    is ( $level, $check_level, "$code - level" );
    is ( $geohex->encode( $lat, $lon, $level ), $code, 'decode-encode match' );
}

done_testing;

__DATA__
wkmP    35.654108   139.700874  7
132KpwT 35.658310   139.700877  1
ff96I   35.652007   139.702372  15
rmox    34.692665   135.501638  7
132bBGK 34.691965   135.500138  1
fcaLw   34.695465   135.495642  15
032dD   34.726980   135.518158  60
032Lr   35.652000   139.657388  60
