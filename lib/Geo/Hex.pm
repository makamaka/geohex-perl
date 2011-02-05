package Geo::Hex;

use warnings;
use strict;
use Carp ();
use Exporter;

our $VERSION = '0.01';

our @ISA    = qw(Exporter);

our @EXPORT    = qw(decode_geohex encode_geohex);
our @EXPORT_OK = qw(latlng2geohex geohex2latlng getZoneByLocation getZoneByCode);

my $Default_SPEC = 3;

sub import {

}


sub new {
    my ( $class, @args ) = @_;

    ref $class && Carp::croak "$class is not a GeoHex class name.";

    my %args = @_ == 2 ? %{ $args[0] } : @args;
    my $v = $args{ version } || $args{ v } || $Default_SPEC;

    $v =~ /^[123]$/ or Carp::croak "The GeoHex spec version is allowed to 1 to 3";

    my $pkg = $class . $v . '::Coder';

    return bless { v => $v }, $pkg;
}


sub spec_version { return $Default_SPEC; }


#
#
#

package
    Geo::Hex::Coder;

sub spec_version {
    $_[0]->{v};
}

sub encode {}

sub decode {}

package
    Geo::Hex3::Coder;

our @ISA = qw(Geo::Hex::Coder);

require Geo::Hex3;

sub encode {
    my ( $self, @args ) = @_;
    @args == 3
        or Carp::croak('encode() must take 3 args(lat, lon, level).');
    return Geo::Hex3::latlng2geohex(@args);
}

sub decode {
    my ( $self, $code ) = @_;
    return wantarray ? Geo::Hex3::geohex2latlng( $code ) : [ Geo::Hex3::geohex2latlng( $code ) ];
}

sub to_zone {
    my ( $self, @args ) = @_;
   return @args == 1 ? Geo::Hex3::geohex2zone( $args[0] )
        : @args == 3 ? Geo::Hex3::latlng2zone(@args)
        : Carp::croak('encode() must take 3 args(lat, lon, level) or 1 args(Geo::Hex::Zone).');
}


package
    Geo::Hex2::Coder;

our @ISA = qw(Geo::Hex::Coder);

require Geo::Hex2;

sub encode {
    my ( $self, @args ) = @_;
    @args == 3
        or Carp::croak('encode() must take 3 args(lat, lon, level).');
    return Geo::Hex2::latlng2geohex(@args);
}

sub decode {
    my ( $self, $code ) = @_;
    return wantarray ? Geo::Hex2::geohex2latlng( $code ) : [ Geo::Hex2::geohex2latlng( $code ) ];
}

sub to_zone {
    my ( $self, @args ) = @_;
    return @args == 1 ? Geo::Hex2::geohex2zone( $args[0] )
         : @args == 3 ? Geo::Hex2::latlng2zone(@args)
        : Carp::croak('encode() must take 3 args(lat, lon, level) or 1 args(Geo::Hex::Zone).');
}


package
    Geo::Hex1::Coder;

our @ISA = qw(Geo::Hex::Coder);

require Geo::Hex1;

sub encode {
    my ( $self, @args ) = @_;
    @args == 3
        or Carp::croak('encode() must take 3 args(lat, lon, level).');
    return Geo::Hex1::latlng2geohex(@args);
}

sub decode {
    my ( $self, $code ) = @_;
    return wantarray ? Geo::Hex1::geohex2latlng( $code ) : [ Geo::Hex3::geohex2latlng( $code ) ];
}

sub to_zone {
    my ( $self, @args ) = @_;
    return @args == 1 ? Geo::Hex1::geohex2zone( $args[0] )
         : @args == 3 ? Geo::Hex1::latlng2zone(@args)
         : Carp::croak('encode() must take 3 args(lat, lon, level) or 1 args(Geo::Hex::Zone).');
}


1;
__END__

=head1 NAME

Geo::Hex - GeoHex decoder/encoder

=head1 SYNOPSIS

    use Geo::Hex;
    
    # OO-style
    my $geohex = Geo::Hex->new( version => 3 ); # v3 by default
    
    my ($lat, $lon, $level) = $geohex->decode( 'XM4885487' );
    my $code                = $geohex->encode( $lat, $lon, $level );
    # => XM4885487
    
    my $zone = $geohex->to_zone( 'XM4885487' );
       $zone = $geohex->to_zone( $lat, $lon, $level );
    
    # * zone object: hash value
    # $zone->code  : GeoHex code
    # $zone->level : Level
    # $zone->lat   : Latirude of given GeoHex's center point
    # $zone->lon   : Longitude of given GeoHex's center point
    # $zone->x     : Mercator X coordinate of given GeoHex's center point 
    # $zone->y     : Mercator Y coordinate of given GeoHex's center point 
    
    $geohex->spec_version; # => 3
    
    
    # Export function - GeoHex v3 by default
    ($lat, $lon, $level) = decode_geohex( $code );
    $code = encode_geohex( $lat, $lon, $level );
    
    
    # Explicit export function
    use Geo::Hex v => 3, qw(latlng2geohex geohex2latlng latlng2zone code2zone);
    
    # From latitude/longitude to hex code
    $code = latlng2geohex( $lat, $lng, $level );
        # From hex code to center latitude/longitude
    my ( $center_lat, $center_lng, $level ) = geohex2latlng( $code );
    
    
    # Explicit export function - original javascript name
    use Geo::Hex v => 3, qw(getZoneByLocation getZoneByCode);
    # From latitude/longitude to zone object*
    $zone = getZoneByLocation( $lat, $lng, $level );
    # From hex code to zone object*
    $zone = getZoneByCode( $code );

=head1 CLASS METHODS

=head2 new

    $geohex = Geo::Hex->new( %option );

Creates a new Geo::Hex::Coder object. It can take options:

=over 4

=item version

The GeoHex specification vresion.

=item v

The synonym to C<version> option.

=back

=head2 spec_version

Returns specification version.


=head1 INSTANCE METHODS

=head2 decode

    ( $lat, $lon, $level ) = $geohex->decode( $code );

=head2 encode

    $code = $geohex->encode( $lat, $lon, $level );

=head2 to_zone

    $zone = $geohex->to_zone( $code );
    
    $zone = $geohex->to_zone( $lat, $lon, $level );

=head2 spec_version


=head1 EXPORT FUNCTIONS

=head2 decode_geohex

    ($lat, $lon, $level) = decode_geohex( $code );

=head2 encode_geohex

    $code = encode_geohex( $lat, $lon, $level );


=head1 FUNCTIONS

=head2 latlng2geohex

    latlng2geohex( $lat, $lng, $level );
    
    latlng2geohex( $zone );

Convert latitude/longitude to GeoHex code.

=head2 geohex2latlng

    geohex2latlng( $code );

Convert GeoHex code to center latitude/longitude, and level value.


=head1 SEE ALSO

L<http://geogames.net/geohex/v3>

L<Geo::Hex::Zone>, 
L<Geo::Hex1>,
L<Geo::Hex2>,
L<Geo::Hex3>

=head1 AUTHOR

Makamaka Hannyaharamitu

=head1 LICENCE AND COPYRIGHT

GeoHex by @sa2da (http://geogames.net) is licensed under
Creative Commons BY-SA 2.1 Japan License.

Copyright 2011 Makamaka Hannyaharamitu

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.


=cut


