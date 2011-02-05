use strict;
use Test::More;
use Geo::Hex1;


my $hex    = <DATA>; chomp($hex);
my @points = <DATA>; chomp(@points);

my @tpoints = @{geohex2polygon($hex)};

foreach my $i ( 0..$#tpoints ) {
    my ( $lat,  $lng  ) = split(/,/,$points[$i]);
    my ( $tlat, $tlng ) = @{ $tpoints[$i] };
    is $lat,   sprintf('%.6f',$tlat);
    is $lng,   sprintf('%.6f',$tlng);
}

done_testing;

__DATA__
wkmP
35.654108,139.693874
35.659008,139.697374
35.659008,139.704374
35.654108,139.707874
35.649208,139.704374
35.649208,139.697374
35.654108,139.693874
