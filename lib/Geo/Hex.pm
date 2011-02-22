package Geo::Hex;

use warnings;
use strict;
use Carp ();
use Exporter;

our $VERSION = '0.01';

our @ISA    = qw(Exporter);

our @EXPORT    = qw(decode_geohex encode_geohex);
our @EXPORT_OK = qw(latlng2geohex geohex2latlng latlng2zone geohex2zone);

my $Default_SPEC = 3;
my $Current_SPEC = 0;

unless ( $Current_SPEC ) {
    $Current_SPEC = __PACKAGE__->_set_functions( $Default_SPEC );
}


sub import {
    my ( $class, %args ) = @_;
    my $v = delete $args{ v } || delete $args{ version } || $Default_SPEC;

    $v =~ /^[123]$/ or Carp::croak "The GeoHex spec version is allowed to 1 to 3";

    if ( $v != $Current_SPEC ) {
        $Current_SPEC = $class->_set_functions( $v );
    }

    $class->export_to_level(1, undef, %args);
}


sub _set_functions {
    my ( $class, $v ) = @_;
    my $pkg  = "Geo::Hex::V$v";
    (my $path = $pkg . '.pm')  =~ s{::}{/}g;

    require $path;

    no strict 'refs';

    *_latlng2geohex = *{"$pkg\::latlng2geohex"};
    *_geohex2latlng = *{"$pkg\::geohex2latlng"};
    *_latlng2zone   = *{"$pkg\::latlng2zone"};
    *_geohex2zone   = *{"$pkg\::geohex2zone"};

    return $v;
}

#
# FUNCTIONS
#

*encode_geohex = *latlng2geohex;
*decode_geohex = *geohex2latlng;

sub latlng2geohex {
    return _latlng2geohex( @_ );
}

sub geohex2latlng {
    return _geohex2latlng( @_ );
}

sub latlng2zone {
    return _latlng2zone( @_ );
}

sub geohex2zone {
    return _geohex2zone( @_ );
}


#
# METHODS
#

sub new {
    my ( $class, @args ) = @_;

    ref $class && Carp::croak "$class is not a GeoHex class name.";

    my %args = @_ == 2 ? %{ $args[0] } : @args;
    my $v = $args{ version } || $args{ v } || $Default_SPEC;

    $v =~ /^[123]$/ or Carp::croak "The GeoHex spec version is allowed to 1 to 3";

    return Geo::Hex::Coder->new( v => $v );
}


sub spec_version { return $Default_SPEC; }


#
# Coder Class
#

package Geo::Hex::Coder;

use warnings;
use strict;

my %CoderVersion;


sub new {
    my ( $class, %opt ) = @_;
    my $v = $opt{ v };
    unless ( $v ) {
        Carp::croak('GeoHex version must be specified.');
    }

    my $pkg = $CoderVersion{ $v };

    unless ( $CoderVersion{ $v } ) {
       $pkg = $CoderVersion{ $v } =  $class->_make_coder_class( $v );
    }

    bless { v => $v }, $pkg;
}


sub spec_version {
    $_[0]->{v};
}


sub _make_coder_class {
    my ( $class, $v ) = @_;

    my $pkg = 'Geo::Hex' . $v  . '::Coder';


    eval sprintf( <<'MODULE', $pkg, $v );
package %s;

use strict;
require Geo::Hex::V%d;

our @ISA = qw(Geo::Hex::Coder);

sub encode {
    my ( $self, @args ) = @_;
    @args == 3
        or Carp::croak('encode() must take 3 args(lat, lon, level).');
    return Geo::Hex::V%2$d::latlng2geohex(@args);
}

sub decode {
    my ( $self, $code ) = @_;
    return Geo::Hex::V%2$d::geohex2latlng( $code );
}

sub to_zone {
    my ( $self, @args ) = @_;
   return @args == 1 ? Geo::Hex::V%2$d::geohex2zone( $args[0] )
        : @args == 3 ? Geo::Hex::V%2$d::latlng2zone(@args)
        : Carp::croak('encode() must take 3 args(lat, lon, level) or 1 args(Geo::Hex::Zone).');
}
MODULE

    Carp::croak( $@ ) if $@;

    return $pkg;
}



1;
__END__

=head1 NAME

Geo::Hex - GeoHex decoder/encoder

=head1 SYNOPSIS

    use Geo::Hex;
    
    # OO-style
    my $geohex = Geo::Hex->new( version => 3 ); # v3 by default
    
    $geohex->spec_version; # => 3
    
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
    
    my $polygon = $zone->hex_coords; # return the hex coords (six points hold lat and lon)
    
    
    # Export function - GeoHex v3 by default
    ($lat, $lon, $level) = decode_geohex( $code );
    $code = encode_geohex( $lat, $lon, $level );
    
    # Explicit export function
    use Geo::Hex v => 3, qw(latlng2geohex geohex2latlng latlng2zone geohex2zone);
    
    # From latitude/longitude to hex code
    $code = latlng2geohex( $lat, $lng, $level );
        # From hex code to center latitude/longitude
    my ( $center_lat, $center_lng, $level ) = geohex2latlng( $code );

=head1 VERSION

This is a beta version, so interfaces may be changed in future.

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

Returns specification version.

=head1 EXPORT FUNCTIONS

=head2 decode_geohex

    ($lat, $lon, $level) = decode_geohex( $code );

Convert latitude/longitude to GeoHex code.

=head2 encode_geohex

    $code = encode_geohex( $lat, $lon, $level );

Convert GeoHex code to center latitude/longitude, and level value.

=head1 FUNCTIONS

    use Geo::Hex v => 3;

=head2 latlng2geohex

    $code = latlng2geohex( $lat, $lon, $level );

Same as C<encode_geohex>.

=head2 geohex2latlng

    ($lat, $lon, $level) = geohex2latlng( $code );

Same as C<decode_geohex>.

=head2 latlng2zone

    $zone = latlng2zone( $lat, $lon, $level );

Takes a location and its level, and returns L<GeoHex::Zone>.

=head2 geohex2zone

    $zone = geohex2zone( $code );

Takes a geohex code and returns L<GeoHex::Zone>.

=head1 SEE ALSO

L<https://sites.google.com/site/geohexdocs/>,
L<http://geogames.net/geohex/v3>

L<Geo::Hex::V1>,
L<Geo::Hex::V2>,
L<Geo::Hex::V3>,
L<Geo::Hex::Zone>

=head1 AUTHORS

Frontend module L<Geo::Hex> by Makamaka Hannyaharamitu

L<Geo::Hex::V1> are originally written by OHTSUKA Ko-hei  C<< <nene@kokogiko.net> >>

L<Geo::Hex::V2> are originally written by OHTSUKA Ko-hei and maintained by Makamaka Hannyaharamitu

L<Geo::Hex::V2::XS> are originally written by lestrrat

L<Geo::Hex::V3> are originally written by soh335

=head1 LICENCE AND COPYRIGHT

GeoHex by @sa2da (http://geogames.net) is licensed under
Creative Commons BY-SA 2.1 Japan License.

Geo::Hex - Copyright 2011 Makamaka Hannyaharamitu

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut


