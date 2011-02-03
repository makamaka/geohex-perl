#!perl

use strict;
use Test::More;

BEGIN {
    use_ok( 'Geo::Hex' );
}

diag( "Testing Geo::Hex $Geo::Hex::VERSION" );

is( Geo::Hex->spec_version, 3, 'default spec version' );

my $geohex;

$geohex = Geo::Hex->new();
isa_ok( $geohex, 'Geo::Hex3::Coder' );
is( $geohex->spec_version, 3, 'spec version' );

$geohex = Geo::Hex->new( version => 1 );
isa_ok( $geohex, 'Geo::Hex1::Coder' );
is( $geohex->spec_version, 1, 'spec version' );

$geohex = Geo::Hex->new( v => 2 );
isa_ok( $geohex, 'Geo::Hex2::Coder' );
is( $geohex->spec_version, 2, 'spec version' );

$geohex = Geo::Hex->new( v => 3 );
isa_ok( $geohex, 'Geo::Hex3::Coder' );
is( $geohex->spec_version, 3, 'spec version' );

done_testing;
