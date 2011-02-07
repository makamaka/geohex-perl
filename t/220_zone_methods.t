use strict;
use Test::More;
use Geo::Hex;

require 't/location_data.pl';

my @data = location_data();

my $geohex = Geo::Hex->new( v => 2 );

my ( $lat, $lon, $level, $code) = @{ shift @data };
my $zone  = $geohex->to_zone($lat, $lon, $level);

isa_ok( $zone, 'Geo::Hex::Zone' );

is( $zone->spec_version, 2, 'spec_version' );
can_ok( $zone, 'hex_size' );
is( scalar( @{ $zone->hex_coords } ), 6, 'hex_coords' );


done_testing;
