#!perl

use strict;
use Test::More;
use Geo::Hex::V2;

require 't/location_data.pl';

my @data = location_data();

plan tests => scalar( @data );

for my $d ( @data ) {
    my ( $lat, $lng, $level, $code ) = @$d;
    my $zone = Geo::Hex::V2::latlng2zone( $lat, $lng, $level );
    is( $zone->{ code }, $code, $code );
}

