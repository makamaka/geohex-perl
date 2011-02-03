use strict;
use Test::More;
use Geo::Hex;

require 't/encode_data.pl';
require 't/decode_data.pl';

my @encode_data = encode_data();

my $geohex = Geo::Hex->new( v => 3 );

for my $d ( @encode_data ) {
    my ( $lat, $lon, $level, $code) = @$d;
    is ( $geohex->encode($lat, $lon, $level), $code, $code );
}

done_testing;
