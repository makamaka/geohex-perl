package Geo::Hex::Zone;

use strict;
use warnings;

our $VERSION = '1.00';

sub new {
    my ( $class, $arg ) = @_;
    bless $arg, $class;
}

sub lat { $_[0]->{lat} }

sub lon { $_[0]->{lon} }

sub x   { $_[0]->{x} }

sub y   { $_[0]->{y} }

sub code  { $_[0]->{code} }

sub level { $_[0]->{level} }

sub lng { $_[0]->lon }

sub hex_coords { die "hex_coords must be implemented by subclass."; }

1;
__END__

=pod

=head1 NAME

Geo::Hex::Zone - GeoHex zone base class

=head1 DESCRIPTION

GeoHex zone class.

=head1 METHODS

=head2 lat

Returns the latitude..

=head2 lon

Returns the longitude.

=head2 lng

The alias to C<lon>.

=head2 level

Returns the GeoHex level.

=head2 x

Returns the GeoHex X point.

=head2 y

Returns the GeoHex Y point.

=head2 code

Returns the GeoHex code.

=head2 hex_coords

    $polygon = $zone->hex_coords
    # => [
    #        [ lat1, lon1 ],
    #        [ lat2, lon2 ],
    #        [ lat3, lon3 ],
    #        [ lat4, lon4 ],
    #        [ lat5, lon5 ],
    #        [ lat6, lon6 ],
    #    ]

Returns the array reference of geohex coords.

This method is implemented by subclasses in Geo::Hex::V* classes.

=head1 SEE ALSO

L<Geo::Hex>,
L<Geo::Hex::V1>,
L<Geo::Hex::V2>,
L<Geo::Hex::V3>

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
