use strict;
use Test::More;
use Geo::Hex1;

for ( <DATA> ) {
    chomp;
    my ($hex, $lat, $lng, $level) = split/ +/;
    my ($tlat, $tlng, $tlevel) = geohex2latlng($hex);
    is sprintf('%.6f',$tlat), $lat;
    is sprintf('%.6f',$tlng), $lng;
    is $tlevel, $level;
    is latlng2geohex($tlat,$tlng,$tlevel), $hex;
}

done_testing;

__DATA__
wkmP    35.654108   139.700874  7
132KpwT 35.658310   139.700877  1
ff96I   35.652007   139.702372  15
rmox    34.692665   135.501638  7
132bBGK 34.691965   135.500138  1
fcaLw   34.695465   135.495642  15
032dD   34.726980   135.518158  60
032Lr   35.652000   139.657388  60
