use strict;
use Test::More;
use Geo::Hex;

require 't/decode_data.pl';

my @decode_data = decode_data();

my $geohex = Geo::Hex->new( v => 3 );

for my $d ( @decode_data ) {
    my ( $lat, $lon, $level, $code) = @$d;

    my $zone  = $geohex->to_zone($lat, $lon, $level);
    my $zone1 = $geohex->to_zone($code);

    my $zone2 = $geohex->to_zone($zone1->lat, $zone1->lon, $zone1->level);


    is( $zone1->x . '/' . $zone1->y, $zone->x . '/' . $zone->y, 
                                    sprintf('%s - %s/%s', $code,  @{$zone}{qw/x y/} ) );
    is( $zone2->x . '/' . $zone2->y, $zone->x . '/' . $zone->y, 
                                    sprintf('%s - %s/%s', $code,  @{$zone}{qw/x y/} ) );

    is ( sprintf("%.12f", $zone1->lat),   sprintf("%.12f", $lat),   "$code 1 - lat" );
    is ( sprintf("%.12f", $zone1->lon),   sprintf("%.12f", $lon),   "$code 1 - lon" );

    is ( sprintf("%.11f", $zone2->lat),   sprintf("%.11f", $lat),   "$code 2 - lat" );
    is ( sprintf("%.11f", $zone2->lon),   sprintf("%.11f", $lon),   "$code 2 - lon" );

#    is_deeply( $zone1, $zone, $code );
}

done_testing;
