use strict;
use Test::More;
use Geo::Hex;

require 't/decode_data.pl';

my @data = decode_data();

my $geohex = Geo::Hex->new( v => 3 );

my ( $lat, $lon, $level, $code) = @{ shift @data };
my $zone  = $geohex->to_zone($lat, $lon, $level);

isa_ok( $zone, 'Geo::Hex::Zone' );

is( $zone->spec_version, 3, 'spec_version' );
can_ok( $zone, 'hex_size' );
is( scalar( @{ $zone->hex_coords } ), 6, 'hex_coords' );


done_testing;
