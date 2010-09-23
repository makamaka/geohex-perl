package Geo::Hex;

use warnings;
use strict;
use Carp;

use POSIX       qw/floor ceil/;
use Math::Round qw/round/;
use Math::Trig qw( tan atan );

our $VERSION = '0.02_01';
use vars qw(@ISA @EXPORT);
use Exporter;
@ISA    = qw(Exporter);
@EXPORT = qw(latlng2geohex geohex2latlng getZoneByLocation getZoneByCode);

# code from http://geohex.net/hex_v2.03_core.js

# Constants

use constant PI => Math::Trig::pi();

my $h_key       = 'abcdefghijklmnopqrstuvwxyz0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
my @h_key       = split( //, $h_key );
my $h_base      = 20037508.34;
my $h_deg       = PI * ( 30.0 / 180.0 );
my $h_k         = tan($h_deg);
my $h_range     = 21;


sub latlng2geohex {
    return getZoneByLocation(@_)->{code};
}

sub geohex2latlng{
    my $_code    = shift;
    my $level    = index($h_key, substr($_code,0,1));
    my $zone     = getZoneByCode($_code);
    return ( ( map { $zone->{$_} } qw/lat lon/ ), $level);
}

sub getZoneByLocation {
    my ( $_lat, $_lon, $_level ) = @_;
    $_level = 16 if ( !defined($_level) );
    my $hex_pos;
    my $h_size = __setHexSize($_level);
    my $zone   = {};

    my $z_xy   = __loc2xy($_lon, $_lat);

    my $lon_grid = $z_xy->[0];
    my $lat_grid = $z_xy->[1];
    my $unit_x   = 6.0 * $h_size;
    my $unit_y   = 6.0 * $h_size * $h_k;
    my $h_pos_x  = ( $lon_grid + $lat_grid / $h_k ) / $unit_x;
    my $h_pos_y  = ( $lat_grid - $h_k * $lon_grid ) / $unit_y;
    my $h_x_0    = floor($h_pos_x);
    my $h_y_0    = floor($h_pos_y);
#    my $h_x_q    = floor(($h_pos_x - $h_x_0) * 100.0) / 100.0;
#    my $h_y_q    = floor(($h_pos_y - $h_y_0) * 100.0) / 100.0;
    my $h_x_q    = $h_pos_x - $h_x_0; # v2.03
    my $h_y_q    = $h_pos_y - $h_y_0; # v2.03
    my $h_x      = round($h_pos_x);
    my $h_y      = round($h_pos_y);

    my $h_max    = round( $h_base / $unit_x + $h_base / $unit_y );

    if ( $h_y_q > - $h_x_q + 1.0 ) {
        if ( ( $h_y_q < 2.0 * $h_x_q ) && ( $h_y_q > 0.5 * $h_x_q ) ) {
            $h_x = $h_x_0 + 1.0;
            $h_y = $h_y_0 + 1.0;
        }
    } elsif ( $h_y_q < - $h_x_q + 1.0 ){
        if ( ( $h_y_q > ( 2.0 * $h_x_q ) - 1.0 ) && ( $h_y_q < ( 0.5 * $h_x_q) + 0.5 ) ) {
            $h_x = $h_x_0;
            $h_y = $h_y_0;
        }
    }

    my $h_lat = ( $h_k * $h_x * $unit_x + $h_y * $unit_y ) / 2.0;
    my $h_lon = ( $h_lat - $h_y * $unit_y ) / $h_k;

    my $z_loc   = __xy2loc($h_lon, $h_lat);
    my $z_loc_x = $z_loc->[0];
    my $z_loc_y = $z_loc->[1];
    if ( $h_base - $h_lon < $h_size ) {
       $z_loc_x = 180.0;
       my $h_xy = $h_x;
       $h_x     = $h_y;
       $h_y     = $h_xy;
    }

    my $h_x_p =0;
    my $h_y_p =0;
    if ( $h_x < 0.0 ) {
        $h_x_p = 1.0;
    }
    if ( $h_y < 0.0 ) {
        $h_y_p = 1.0;
    }
    my $h_x_abs = abs( $h_x ) * 2.0 + $h_x_p;
    my $h_y_abs = abs( $h_y ) * 2.0 + $h_y_p;

    my $h_x_10000 = floor( ( $h_x_abs % 77600000 ) / 1296000.0 );
    my $h_x_1000  = floor( ( $h_x_abs % 1296000  ) / 216000.0 );
    my $h_x_100   = floor( ( $h_x_abs % 216000   ) / 3600.0 );
    my $h_x_10    = floor( ( $h_x_abs % 3600     ) / 60.0 );
    my $h_x_1     = floor( ( $h_x_abs % 3600     ) % 60 );

    my $h_y_10000 = floor( ( $h_y_abs % 77600000) / 1296000.0 );
    my $h_y_1000  = floor( ( $h_y_abs % 1296000 ) / 216000.0 );
    my $h_y_100   = floor( ( $h_y_abs % 216000  ) / 3600.0 );
    my $h_y_10    = floor( ( $h_y_abs % 3600    ) / 60.0 );
    my $h_y_1     = floor( ( $h_y_abs % 3600    ) % 60 );

    my $h_code    = $h_key[$_level % 60];

    if ( $h_max >= 1296000.0 / 2.0 ) {
        $h_code = $h_code . $h_key[$h_x_10000] . $h_key[$h_y_10000];
    }
    if ( $h_max >= 216000.0  / 2.0 ) {
        $h_code = $h_code . $h_key[$h_x_1000]  . $h_key[$h_y_1000];
    }
    if ( $h_max >= 3600.0    / 2.0 ) {
        $h_code = $h_code . $h_key[$h_x_100]   . $h_key[$h_y_100];
    }
    if ( $h_max >= 60.0      / 2.0 ) {
        $h_code = $h_code . $h_key[$h_x_10]    . $h_key[$h_y_10];
    }
    $h_code = $h_code . $h_key[$h_x_1] . $h_key[$h_y_1];

    $zone->{lat}  = $z_loc_y;
    $zone->{lon}  = $z_loc_x;
    $zone->{x}    = $h_x;
    $zone->{y}    = $h_y;
    $zone->{code} = $h_code;
    return $zone;
}

sub getZoneByCode {
    my $_code    = shift;
    my @_code    = split(//,$_code);
    my $c_length = @_code;
    my $zone     = {};
    my $level    = index($h_key, $_code[0]);
    my $scl      = $level;
    my $h_size   = __setHexSize( $level );
    my $unit_x   = 6.0 * $h_size;
    my $unit_y   = 6.0 * $h_size * $h_k;
    my $h_max    = round($h_base / $unit_x + $h_base / $unit_y);
    my $h_x=0;
    my $h_y=0;

    if( $h_max >= 1296000.0 / 2.0 ) {
        $h_x = index($h_key, $_code[1]) * 1296000.0 + index($h_key, $_code[3]) * 216000.0 + 
               index($h_key, $_code[5]) * 3600.0    + index($h_key, $_code[7]) * 60.0     + index($h_key, $_code[9]);
        $h_y = index($h_key, $_code[2]) * 1296000.0 + index($h_key, $_code[4]) * 216000.0 + 
               index($h_key, $_code[6]) * 3600.0    + index($h_key, $_code[8]) * 60.0     + index($h_key, $_code[10]);
    } elsif ( $h_max >= 216000.0 / 2.0 ) {
        $h_x = index($h_key, $_code[1]) * 216000.0  + index($h_key, $_code[3]) * 3600.0   +
               index($h_key, $_code[5]) * 60.0      + index($h_key, $_code[7]);
        $h_y = index($h_key, $_code[2]) * 216000.0  + index($h_key, $_code[4]) * 3600.0   +
               index($h_key, $_code[6]) * 60.0      + index($h_key, $_code[8]);
    } elsif ( $h_max >= 3600.0 / 2.0 ) {
        $h_x = index($h_key, $_code[1]) * 3600.0    + index($h_key, $_code[3]) * 60.0     + index($h_key, $_code[5]);
        $h_y = index($h_key, $_code[2]) * 3600.0    + index($h_key, $_code[4]) * 60.0     + index($h_key, $_code[6]);
    } elsif ( $h_max >= 60.0 / 2.0 ) {
        $h_x = index($h_key, $_code[1]) * 60.0      + index($h_key, $_code[3]);
        $h_y = index($h_key, $_code[2]) * 60.0      + index($h_key, $_code[4]);
    } else {
        $h_x = index($h_key, $_code[1]);
        $h_y = index($h_key, $_code[2]);
    }

    $h_x        = ( $h_x % 2 ) ? -($h_x - 1.0) / 2.0 : $h_x / 2.0;
    $h_y        = ( $h_y % 2 ) ? -($h_y - 1.0) / 2.0 : $h_y / 2.0;
    my $h_lat_y = ( $h_k * $h_x * $unit_x + $h_y * $unit_y ) / 2.0;
    my $h_lon_x = ( $h_lat_y - $h_y * $unit_y ) / $h_k;

    my $h_ll    = __xy2loc($h_lon_x, $h_lat_y);
    my $h_lon   = $h_ll->[0];
    my $h_lat   = $h_ll->[1];
    $zone->{code} = $_code;
    $zone->{lat}  = $h_lat;
    $zone->{lon}  = $h_lon;
    $zone->{x}    = $h_x;
    $zone->{y}    = $h_y;
    return $zone;
}

sub getZoneByXY {
    my ( $x, $y, $level ) = @_;
    my $scl = $level;
    my $h_size  =  __setHexSize( $level );
    my $unit_x  = 6 * $h_size;
    my $unit_y  = 6 * $h_size * $h_k;
    my $h_max   = round( $h_base / $unit_x + $h_base / $unit_y );
    my $h_lat_y = ( $h_k * $x * $unit_x + $y * $unit_y ) / 2;
    my $h_lon_x = ( $h_lat_y - $y * $unit_y ) / $h_k;
    my $h_loc   = __xy2loc( $h_lon_x, $h_lat_y );
    my $x_p = $x < 0 ? 1 : 0;
    my $y_p = $y < 0 ? 1 : 0;

    my $x_abs   = abs( $x ) * 2 + $x_p;
    my $y_abs   = abs( $y ) * 2 + $y_p;
    my $x_10000 = floor( ( $x_abs % 77600000 ) / 1296000 );
    my $x_1000  = floor( ( $x_abs % 1296000  ) / 216000  );
    my $x_100   = floor( ( $x_abs % 216000   ) / 3600    );
    my $x_10    = floor( ( $x_abs % 3600     ) / 60      );
    my $x_1     = floor( ( $x_abs % 3600     ) % 60      );
    my $y_10000 = floor( ( $y_abs % 77600000 ) / 1296000 );
    my $y_1000  = floor( ( $y_abs % 1296000  ) / 216000  );
    my $y_100   = floor( ( $y_abs % 216000   ) / 3600    );
    my $y_10    = floor( ( $y_abs % 3600     ) / 60      );
    my $y_1     = floor( ( $y_abs % 3600     ) % 60      );
    my $h_code  = $h_key[ $level % 60 ];

    if ( $h_max >= 1296000.0 / 2.0 ) {
        $h_code = $h_code . $h_key[$x_10000] . $h_key[$y_10000];
    }
    if ( $h_max >= 216000.0  / 2.0 ) {
        $h_code = $h_code . $h_key[$x_1000]  . $h_key[$y_1000];
    }
    if ( $h_max >= 3600.0    / 2.0 ) {
        $h_code = $h_code . $h_key[$x_100]   . $h_key[$y_100];
    }
    if ( $h_max >= 60.0      / 2.0 ) {
        $h_code = $h_code . $h_key[$x_10]    . $h_key[$y_10];
    }

    $h_code .= $h_key[$x_1] . $h_key[$y_1];

    my $zone     = {};

    $zone->{code} = $h_code;
    $zone->{lat}  = $h_loc->[1];
    $zone->{lon}  = $h_loc->[0];
    $zone->{x}    = $x;
    $zone->{y}    = $y;

    return $zone;
}


sub getSteps {
    my ( $start_zone, $end_zone ) = @_;
    my $x = $end_zone->{ x } - $start_zone->{ x };
    my $y = $end_zone->{ y } - $start_zone->{ y };
    my $xabs = abs( $x );
    my $yabs = abs( $y );

    my $xqad = $xabs ? $x / $xabs : undef;
    my $yqad = $yabs ? $y / $yabs : undef;

    my $m = 0;

    if( defined $xqad and defined $yqad and $xqad == $yqad ) {
        if( $yabs > $xabs ) {
            $m = $x;
        }
        else {
            $m = $y;
        }
    }

    return $xabs + $yabs - abs( $m ) + 1;
}


sub __setHexSize {
  return $h_base / 2.0 ** $_[0] / 3.0;
}

sub __loc2xy {
    my ( $lon, $lat ) = @_;
    my $x = $lon * $h_base / 180;
    my $y = $h_base * log( tan( ( 90 + $lat ) * PI / 360) ) / ( PI / 180 ) / 180;
    return [ $x, $y ];
}

sub __xy2loc {
    my ( $x, $y ) = @_;
    my $lon = ( $x / $h_base ) * 180;
    my $lat = ( $y / $h_base ) * 180;
    $lat = 180 / PI * ( 2 * atan( exp( $lat * PI / 180 ) ) - PI / 2 );
    return [ $lon, $lat ];
}

1; # Magic true value required at end of module
__END__

=head1 NAME

Geo::Hex - Convert between latitude/longitude and GeoHex code (version 2:world wide)


=head1 SYNOPSIS

    use Geo::Hex;
    
    # From latitude/longitude to hex code
    
    my $code = latlng2geohex( $lat, $lng, $level );
    
    # From hex code to center latitude/longitude
    
    my ( $center_lat, $center_lng, $level ) = geohex2latlng( $code );
    
    # From latitude/longitude to zone object*
    my $zone = getZoneByLocation( $lat, $lng, $level );
    
    # From hex code to zone object*
    my $zone = getZoneByCode( $code );

    # * zone object: hash value
    # $zone->{code} : GeoHex code
    # $zone->{lat}  : Latirude of given GeoHex's center point
    # $zone->{lon}  : Longitude of given GeoHex's center point
    # $zone->{x}    : Mercator X coordinate of given GeoHex's center point 
    # $zone->{y}    : Mercator Y coordinate of given GeoHex's center point 

=head1 EXPORT

=over

=item C<< latlng2geohex( $lat, $lng, $level ) >>

Convert latitude/longitude to GeoHex code.
$level is optional, and default value is 16.

=item C<< geohex2latlng( $hex ) >>

Convert GeoHex code to center latitude/longitude, and level value.

=item C<< getZoneByLocation( $lat, $lng, $level ) >>

Convert latitude/longitude to GeoHex zone object.
$level is optional, and default value is 16.

=item C<< getZoneByCode( $hex ) >>

Convert GeoHex code to GeoHex zone object.

=back


=head1 DEPENDENCIES

Exporter
POSIX
Math::Round
Math::Trig

=head1 AUTHOR

OHTSUKA Ko-hei  C<< <nene@kokogiko.net> >>


=head1 LICENCE AND COPYRIGHT

Copyright (c) 2009-2010, OHTSUKA Ko-hei C<< <nene@kokogiko.net> >>. All rights reserved.

This module is free software; you can redistribute it and/or
modify it under the same terms as Perl itself. See L<perlartistic>.


=head1 DISCLAIMER OF WARRANTY

BECAUSE THIS SOFTWARE IS LICENSED FREE OF CHARGE, THERE IS NO WARRANTY
FOR THE SOFTWARE, TO THE EXTENT PERMITTED BY APPLICABLE LAW. EXCEPT WHEN
OTHERWISE STATED IN WRITING THE COPYRIGHT HOLDERS AND/OR OTHER PARTIES
PROVIDE THE SOFTWARE "AS IS" WITHOUT WARRANTY OF ANY KIND, EITHER
EXPRESSED OR IMPLIED, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE. THE
ENTIRE RISK AS TO THE QUALITY AND PERFORMANCE OF THE SOFTWARE IS WITH
YOU. SHOULD THE SOFTWARE PROVE DEFECTIVE, YOU ASSUME THE COST OF ALL
NECESSARY SERVICING, REPAIR, OR CORRECTION.

IN NO EVENT UNLESS REQUIRED BY APPLICABLE LAW OR AGREED TO IN WRITING
WILL ANY COPYRIGHT HOLDER, OR ANY OTHER PARTY WHO MAY MODIFY AND/OR
REDISTRIBUTE THE SOFTWARE AS PERMITTED BY THE ABOVE LICENCE, BE
LIABLE TO YOU FOR DAMAGES, INCLUDING ANY GENERAL, SPECIAL, INCIDENTAL,
OR CONSEQUENTIAL DAMAGES ARISING OUT OF THE USE OR INABILITY TO USE
THE SOFTWARE (INCLUDING BUT NOT LIMITED TO LOSS OF DATA OR DATA BEING
RENDERED INACCURATE OR LOSSES SUSTAINED BY YOU OR THIRD PARTIES OR A
FAILURE OF THE SOFTWARE TO OPERATE WITH ANY OTHER SOFTWARE), EVEN IF
SUCH HOLDER OR OTHER PARTY HAS BEEN ADVISED OF THE POSSIBILITY OF
SUCH DAMAGES.
