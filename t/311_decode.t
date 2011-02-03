use strict;
use Test::More;
use Geo::Hex;

require 't/decode_data.pl';

my @decode_data = decode_data();

my $geohex = Geo::Hex->new( v => 3 );

for my $d ( @decode_data ) {
    my ( $check_lat, $check_lon, $check_level, $code) = @$d;
    my ( $lat, $lon, $level ) = $geohex->decode($code);
    is ( sprintf("%.12f", $lat),   sprintf("%.12f", $check_lat),   "$code - lat" );
    is ( sprintf("%.12f", $lon),   sprintf("%.12f", $check_lon),   "$code - lon" );
    is ( sprintf("%.12f", $level), sprintf("%.12f", $check_level), "$code - level" );
}

done_testing;
