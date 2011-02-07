use strict;
use Test::More;
use Geo::Hex::V3;

require 't/encode_data.pl';

my @data = encode_data();

for my $d ( @data ) {
    my ( $lat, $lon, $level, $code) = @$d;
    my $zone = Geo::Hex::V3::latlng2zone($lat, $lon, $level);
    is ( $zone->{ code }, $code, $code );
}

done_testing;
