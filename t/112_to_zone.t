use strict;
use Test::More;
use Geo::Hex;

my @data = <DATA>;

my $geohex = Geo::Hex->new( v => 1 );

for my $d ( @data ) {
    chomp($d);
    my ( $code, $lat, $lon, $level ) = split/ +/, $d;

    my $zone  = $geohex->to_zone($lat, $lon, $level);
    my $zone1 = $geohex->to_zone($code);

    my $zone2 = $geohex->to_zone($zone1->lat, $zone1->lon, $zone1->level);


    is( $zone1->x . '/' . $zone1->y, $zone->x . '/' . $zone->y, 
                                    sprintf('%s - %s/%s', $code,  @{$zone}{qw/x y/} ) );
    is( $zone2->x . '/' . $zone2->y, $zone->x . '/' . $zone->y, 
                                    sprintf('%s - %s/%s', $code,  @{$zone}{qw/x y/} ) );

    is ( sprintf("%.6f", $zone1->lat),   sprintf("%.6f", $lat),   "$code 1 - lat" );
    is ( sprintf("%.6f", $zone1->lon),   sprintf("%.6f", $lon),   "$code 1 - lon" );

    is ( sprintf("%.6f", $zone2->lat),   sprintf("%.6f", $lat),   "$code 2 - lat" );
    is ( sprintf("%.6f", $zone2->lon),   sprintf("%.6f", $lon),   "$code 2 - lon" );
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
