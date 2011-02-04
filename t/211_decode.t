use strict;
use Test::More;
use Geo::Hex;

require 't/location_data.pl';

my @data = location_data();

my $geohex = Geo::Hex->new( v => 2 );

# v2 decode test does not exist.

for my $d ( @data ) {
    my ( $check_lat, $check_lon, $check_level, $code) = @$d;
    my ( $lat, $lon, $level ) = $geohex->decode($code);

    is ( $level, $check_level, "$code - level" );
    is ( $geohex->encode( $lat, $lon, $level ), $code, 'decode-encode match' );
}

done_testing;
