use strict;
use Test::More;
use Geo::Hex;

require 't/location_data.pl';

my @data = location_data();

my $geohex = Geo::Hex->new( v => 2 );

# v2 decode test does not exist. so no sufficent test.

for my $d ( @data ) {
    my ( $lat, $lon, $level, $code) = @$d;
    my $zone = $geohex->to_zone($code);

    is ( $zone->level, $level, "$code - level" );

    my $zone2 = $geohex->to_zone($zone->lat, $zone->lon, $zone->level);

    is_deeply( $zone2, $zone );
}

done_testing;
