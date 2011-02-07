#!perl

use strict;
use Test::More;
use Geo::Hex::V2;

require 't/location_data.pl';

my @data = location_data();

plan tests => scalar( @data ) * 2;

for my $d ( @data ) {
    my ( $lat, $lng, $level, $code ) = @$d;
    my $check = Geo::Hex::V2::latlng2zone( $lat, $lng, $level );
    my $zone  = Geo::Hex::V2::geohex2zone( $code );
    is( $zone->{ x }, $check->{ x }, "$code - x" );
    is( $zone->{ y }, $check->{ y }, "$code - y" );
}

