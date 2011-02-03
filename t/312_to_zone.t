use strict;
use Test::More;
use Geo::Hex;

require 't/decode_data.pl';

my @decode_data = decode_data();

my $geohex = Geo::Hex->new( v => 3 );

for my $d ( @decode_data ) {
    my ( $lat, $lon, $level, $code) = @$d;
    my $zone = $geohex->to_zone($code);
    is ( sprintf("%.12f", $zone->lat),   sprintf("%.12f", $lat),   "$code - lat" );
    is ( sprintf("%.12f", $zone->lon),   sprintf("%.12f", $lon),   "$code - lon" );
    is ( sprintf("%.12f", $zone->level), sprintf("%.12f", $level), "$code - level" );

    my $zone2 = $geohex->to_zone($zone->lat, $zone->lon, $zone->level);

    is_deeply( $zone2, $zone );
}

done_testing;
