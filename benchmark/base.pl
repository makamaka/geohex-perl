#!/usr/bin/perl
use strict;
use warnings;
use Geo::Hex;
use Benchmark ':all';

print Geo::Hex->VERSION,"\n";

require 'benchmark/location_data.pl';

my @data = location_data();


cmpthese timethese(
    -1 => {

        latlng2geohex => sub {
            for my $d ( @data ) {
                my ( $lat, $lng, $lev, $code ) = @$d;
                latlng2geohex( $lat, $lng, $lev );
            }
        },

        geohex2latlng => sub {
            for my $d ( @data ) {
                my ( $lat, $lng, $lev, $code ) = @$d;
                geohex2latlng( $code );
            }
        },

        getZoneByLocation => sub {
            for my $d ( @data ) {
                my ( $lat, $lng, $lev, $code ) = @$d;
                Geo::Hex::getZoneByLocation( $lat, $lng, $lev );
            }
        },

        getZoneByCode => sub {
            for my $d ( @data ) {
                my ( $lat, $lng, $lev, $code ) = @$d;
                Geo::Hex::getZoneByCode( $code );
            }
        },


#        getZoneByXY => sub {
#            for my $d ( @data ) {
#                my ( $lat, $lng, $lev, $code ) = @$d;
#                Geo::Hex::getZoneByXY( $zone_by_code->{x}, $zone_by_code->{y}, $level );
#            }
#        },

    }
);
