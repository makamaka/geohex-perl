use strict;
use Test::More;
use Geo::Hex3;

require 't/encode_data.pl';
require 't/decode_data.pl';

my @encode_data = encode_data();

plan tests => scalar( @encode_data );

for my $d ( @encode_data ) {
    my ( $lat, $lon, $level, $code) = @$d;
    my $zone = Geo::Hex3::getZoneByLocation($lat, $lon, $level);
    is ( $zone->{ code }, $code, $code );
}
