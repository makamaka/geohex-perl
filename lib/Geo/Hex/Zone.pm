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


1;
__END__

=pod

=head1 NAME

Geo::Hex::Zone - GeoHex zone base class

=head1 COPYRIGHT AND LICENSE

This library is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.

=cut
