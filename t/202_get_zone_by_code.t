#!perl

use strict;
use Test::More;
use Geo::Hex2;

require 't/location_data.pl';

my @data = location_data();

plan tests => scalar( @data ) * 2;

for my $d ( @data ) {
    my ( $lat, $lng, $level, $code ) = @$d;
    my $check = Geo::Hex2::getZoneByLocation( $lat, $lng, $level );
    my $zone  = Geo::Hex2::getZoneByCode( $code );
    is( $zone->{ x }, $check->{ x }, "$code - x" );
    is( $zone->{ y }, $check->{ y }, "$code - y" );
}

