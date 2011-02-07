use strict;
use Test::More;
use Geo::Hex;

require 't/location_data.pl';

my @data = location_data();

my $geohex = Geo::Hex->new( v => 1 );

my ( $lat, $lon, $level, $code) = @{ shift @data };
my $zone  = $geohex->to_zone( 'wkmP' );

isa_ok( $zone, 'Geo::Hex::Zone' );

is( $zone->spec_version, 1, 'spec_version' );
can_ok( $zone, 'hex_size' );
is( scalar( @{ $zone->hex_coords } ), 6, 'hex_coords' );

my @polygon = map {
    [ map { sprintf('%.6f', $_) } @$_ ];
} @{ $zone->hex_coords };

is_deeply( \@polygon,
    [
        [35.654108,139.693874],
        [35.659008,139.697374],
        [35.659008,139.704374],
        [35.654108,139.707874],
        [35.649208,139.704374],
        [35.649208,139.697374],
    ]
);

done_testing;
