#!perl

use strict;
use Test::More;
use Geo::Hex2;

require 't/location_data.pl';

my @data = location_data();

plan tests => scalar( @data );

for my $d ( @data ) {
    my ( $lat, $lng, $level, $code ) = @$d;
    my $zone_by_code = Geo::Hex2::getZoneByCode( $code );
    my $zone_by_xy   = Geo::Hex2::getZoneByXY( $zone_by_code->{x}, $zone_by_code->{y}, $level );
    is( $zone_by_xy->{ code }, $code, $code . '-code' );
}
