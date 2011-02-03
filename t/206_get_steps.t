#!perl

use strict;
use Test::More;
use Geo::Hex2;
use Data::Dumper;

my @data = map { chomp $_; [ split/,/,$_ ]  } grep { length $_ > 1 } <DATA>;

plan tests => scalar( @data );

for my $d ( @data ) {
    local $TODO = "getSteps is not yet completely implemented.";

    my ( $code1, $code2, $steps, $valid ) = @$d;

    next unless defined $code1;

    my $start_zone = getZoneByCode( $code1 );
    my $end_zone   = getZoneByCode( $code2 );
    print Dumper([ $start_zone, $end_zone ]);
    is( Geo::Hex2::getSteps( $start_zone, $end_zone ), $steps, "$code1 - $code2" );
}

=pod

http://twitter.com/sa2da/status/25189854522
技術仕様未整備のため、随時お答えします。
2ゾーンどちらかを原点としたHex座標系の第2、4象限は座標値の絶対値の和、
第1、3は絶対値のより大きな値がステップ数となります。

http://kokogiko.net/m/archives/002279.html

=cut

# hex code, hex code,予想される値,出力される値
__DATA__
aaa,aac,1,2
bac,bae,1,2
bae,baa,2,3
bae,bad,3,4
cga,cfe,2,8
caa,cca,1,2
caa,ccc,1,2
eyf,ejy,2,31
eke,eqc,4,5
