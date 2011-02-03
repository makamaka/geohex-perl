use strict;
use Test::More;
use Geo::Hex3;

require 't/decode_data.pl';

my @decode_data = decode_data();

plan tests => scalar( @decode_data ) * 2;
#
for my $d ( @decode_data ) {
    my ( $lat, $lon, $level, $code) = @$d;
    my $zone = Geo::Hex3::getZoneByCode($code);

    is ( sprintf("%.12f", $zone->{ lat }), sprintf("%.12f", $lat), "$lat - $code" );
    is ( sprintf("%.12f", $zone->{ lon }), sprintf("%.12f", $lon), "$lon - $code" );
}

