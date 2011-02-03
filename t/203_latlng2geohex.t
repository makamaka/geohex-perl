#!perl

use strict;
use Test::More;
use Geo::Hex2;

require 't/location_data.pl';

my @data = location_data();

plan tests => scalar( @data );

for my $d ( @data ) {
    my ( $lat, $lng, $lev, $code ) = @$d;
    is( latlng2geohex( $lat, $lng, $lev ), $code, $code );
}

