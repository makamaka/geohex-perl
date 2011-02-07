use strict;
use Test::More;
use Geo::Hex::V3;

require 't/decode_data.pl';

my @data = decode_data();

for my $d ( @data ) {
    my ( $lat, $lon, $level, $code) = @$d;
    my $zone = Geo::Hex::V3::geohex2zone($code);

    is ( sprintf("%.12f", $zone->{ lat }), sprintf("%.12f", $lat), "$lat - $code" );
    is ( sprintf("%.12f", $zone->{ lon }), sprintf("%.12f", $lon), "$lon - $code" );
}

done_testing;
