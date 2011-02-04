use strict;
use Test::More;
use Geo::Hex;

require 't/location_data.pl';

my @data = location_data();

my $geohex = Geo::Hex->new( v => 2 );

for my $d ( @data ) {
    my ( $lat, $lon, $level, $code) = @$d;
    is ( $geohex->encode($lat, $lon, $level), $code, $code );
}

done_testing;
