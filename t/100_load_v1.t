use Test::More tests => 1;

BEGIN {
use_ok( 'Geo::Hex::V1' );
}

diag( "Testing Geo::Hex::V1 ", Geo::Hex::V1->VERSION );
