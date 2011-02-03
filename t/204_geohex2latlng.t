#!perl

use strict;
use Test::More;
use Geo::Hex;

require 't/location_data.pl';

my @data = location_data();

plan tests => scalar( @data );

for my $d ( @data ) {
    my ( $lat, $lng, $lev, $code ) = @$d;
    my ( $center_lat, $center_lng, $decoded_lev ) = geohex2latlng( $code );
    is( latlng2geohex( $center_lat, $center_lng, $decoded_lev ), $code, $code );
}

