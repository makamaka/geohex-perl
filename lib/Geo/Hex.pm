package Geo::Hex;

use warnings;
use strict;
use Carp ();
use Exporter;

our $VERSION = '0.01';

our @ISA    = qw(Exporter);

our @EXPORT    = qw(decode_geohex encode_geohex);
our @EXPORT_OK = qw(latlng2geohex geohex2latlng getZoneByLocation getZoneByCode);


sub import {

}




1;
__END__

=head1 NAME

Geo::Hex - GeoHex decoder/encoder

=head1 SYNOPSIS

    use Geo::Hex;
    
    # OO-style
    my $geohex = Geo::Hex->new( version => 3 ); # v3 by default
    
    my $zone = $geohex->decode( 'XM4885487' );
    my $code = $geohex->encode( $zone ); # = $geohex->encode( $zone->lat, $zone->lon, $zone->level )
                                         # => XM4885487
    
    # * zone object: hash value
    # $zone->code  : GeoHex code
    # $zone->level : Level
    # $zone->lat   : Latirude of given GeoHex's center point
    # $zone->lon   : Longitude of given GeoHex's center point
    # $zone->x     : Mercator X coordinate of given GeoHex's center point 
    # $zone->y     : Mercator Y coordinate of given GeoHex's center point 
    
    # Export function - GeoHex v3 by default
    $zone = decode_geohex( 'XM4885487' );
    $code = encode_geohex( $zone );
    
    
    # Explicit export function
    use Geo::Hex v => 3, qw(latlng2geohex geohex2latlng);
    
    # From latitude/longitude to hex code
    $code = latlng2geohex( $lat, $lng, $level );
        # From hex code to center latitude/longitude
    my ( $center_lat, $center_lng, $level ) = geohex2latlng( $code );
    
    
    # Explicit export function - Javascript original method
    use Geo::Hex v => 3, qw(getZoneByLocation getZoneByCode);
    # From latitude/longitude to zone object*
    $zone = getZoneByLocation( $lat, $lng, $level );
    # From hex code to zone object*
    $zone = getZoneByCode( $code );

=head1 EXPORT

=over

=item C<< latlng2geohex( $lat, $lng, $level ) >>

Convert latitude/longitude to GeoHex code.
$level is optional, and default value is 16.

=item C<< geohex2latlng( $hex ) >>

Convert GeoHex code to center latitude/longitude, and level value.

=back

=head1 SEE ALSO

L<http://geogames.net/geohex/v3>

=head1 AUTHOR

Makamaka Hannyaharamitu

=head1 LICENCE AND COPYRIGHT

GeoHex by @sa2da (http://geogames.net) is licensed under
Creative Commons BY-SA 2.1 Japan License.

Copyright 2011 Makamaka Hannyaharamitu

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut


