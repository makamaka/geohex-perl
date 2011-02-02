package Geo::Hex::Zone;

use strict;
use warnings;

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

